#require 'nokogiri'
#require 'open-uri'
#require 'pry'

BASE_URL = "https://animalcrossing.fandom.com"

class Scraper 
    
    # I wanted to scrape another page to provide additional info about aspects of the game
    #? I was having issues scraping the info for the Personality class in my initial scrape so
    #? I also created all of the instances of Personalitys here.
    def self.info_scrape(info_page_url)
      info_page = Nokogiri::HTML(open(info_page_url))
      Villager.info = info_page.css("p")[1].text
      Personality.info = info_page.css("p")[6].text.gsub("For instance:","")
      personality_list = info_page.css("ul li a")[118..125]
      personality_list.each do |row|
        new_personality = Personality.new
        new_personality.name = row.text
        new_personality.url = BASE_URL + row.attr("href")
        #binding.pry
      end
    end
    
    # This is the second scrape for Personality class instances
    #? Looking back would have liked to refactor this to take in a personality and add the traits that way
    #? rather than return a hash of attributes
    def self.personality_attributes_scrape(personality)
      personality_page = Nokogiri::HTML(open(personality.url))
      info = personality_page.css("p").text.gsub(/(Below).+/,"")
      # dealing with some weirdness in the lazy and snooty personality info
      if info.include?("Before Thinking") || info.include?("Snooty villagers will ask")
        info = personality_page.css("p")[0..8].text.gsub(/(Below).+/,"")
      end
      personality.info = info
    end
    
    #Second scrape for Species class instances
    #? Same as with the Personality instances, would've liked to take in an instance and add attributes
    #? rather than return a hash
    def self.species_attributes_scrape(species)
      species_page = Nokogiri::HTML(open(species.url))
      species_info = species_page.css(".mw-content-text").text.match(/\b[A-Z].+[(].+[)].+/x).to_s
      if species_info != species_page.css("p").text
        species_info += "#{" "}" + species_page.css("p").text.strip.chomp("New Horizons 9").gsub("== In oth|}", "").strip
        species_info.gsub!("/n", "")
      end
      species.info = species_info
    end
    

    # The initial scrape. Creates all instances of Villagers and Species.
    def self.initial_scrape(main_page_url)
        main_page = Nokogiri::HTML(open(main_page_url))
       
        main_page.css("table.sortable tr")[1..].each do |table_row|
             
             villager_name = table_row.css("td a")[0].text
             #gsub is getting rid of the additional quotes around the catchphrase
             villager_catchphrase = table_row.css("td i").text.gsub('"','')
             #gsub is getting rid of the leading space on the birthday
             villager_birthday = table_row.css("td")[4].text.chomp.gsub(/^\s/, "")
             villager_wiki_page = BASE_URL + table_row.css("td a").attribute("href").value
             # Jacob and Spork have different names in NA and PAL, so this has to be accounted for
             if villager_name == "Jacob" || villager_name == "Spork"
                new_species = Species.find_or_create_by_name(table_row.css("td a")[4].text)
                new_species.url = BASE_URL + table_row.css("td a")[4].attr("href")
               # Since I created the instances of Personalitys in the info_scrape I only needed to grab
               # the name of the personality
                villager_personality = table_row.css("td a")[3].text[2..]

                villager = Villager.new
                villager.name = villager_name
                villager.personality = Personality.find_by_name(table_row.css("td a")[3].text[2..])
                villager.species = Species.find_by_name(table_row.css("td a")[4].text)
                villager.birthday = villager_birthday
                villager.catchphrase = villager_catchphrase
                villager.villager_wiki = villager_wiki_page
                villager
             else
               new_species = Species.find_or_create_by_name(table_row.css("td a")[3].text)
               new_species.url = BASE_URL + table_row.css("td a")[3].attr("href")
               villager_personality = table_row.css("td a")[2].text[2..]

               villager = Villager.new
               villager.name = villager_name
               villager.personality = Personality.find_by_name(table_row.css("td a")[2].text[2..])
               villager.species = Species.find_by_name(table_row.css("td a")[3].text)
               villager.birthday = villager_birthday
               villager.catchphrase = villager_catchphrase
               villager.villager_wiki = villager_wiki_page
               villager
             end

        end
    end
    
    # Second scrape for Villager instances, adds more attributes
    #? Yet again would like to refactor to take in an instance and just add attributes rather than return a hash
    def self.second_scrape(villager)
        doc = Nokogiri::HTML(open(villager.villager_wiki))

        image_link = doc.css("img.pi-image-thumbnail").attr("src").value

        a = AsciiArt.new(image_link)
       
        image = a.to_ascii_art(color: true)

        attributes = {}

        #Prior to index 5, it is information I've already gotten from the initial scrape.
        # there are many attributes a villager may or may not have, this is why I decided to use mass assignment
        attribute_table = doc.css("div.pi-data-value.pi-font")[5..]

        attribute_table.each.with_index do |row, i|
          attributes[doc.css("h3.pi-data-label")[i+5].text.downcase.split(" ").join("_").to_sym] = row.text
          #This is the method that uses mass assignment in the villager class
          villager.add_villager_attributes(attributes)
        end

        #some villers don't have a quote
        if doc.css("blockquote i")[0] == nil
        #? I can't quite figure out ReGex to use chomp with multiple arguments. The game the quote was from was tacked on to the end of the quote (in a very ugly way)
        #? so I did this to remove all of the game titles.
        quote = nil
          #quote = doc.css("blockquote i").text.chomp("Animal Crossing").chomp("Wild World").chomp("City Folk").chomp("New Leaf").chomp("HHD").chomp("Pocket Camp")
        else
          quote = doc.css("blockquote i")[0].text.chomp("Animal Crossing").chomp("Wild World").chomp("City Folk").chomp("New Leaf").chomp("HHD").chomp("Pocket Camp")
        end

        villager.image = image
        villager.image_link = image_link
        villager.quote = quote
    end
 end
