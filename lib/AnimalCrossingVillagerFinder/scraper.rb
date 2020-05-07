
#require 'nokogiri'
#require 'open-uri'
#require 'pry'

BASE_URL = "https://animalcrossing.fandom.com"

class Scraper 
    def self.scrape_index_page(index_url)
        index_page = Nokogiri::HTML(open(index_url))
        villagers = []
       
        index_page.css("table.sortable tr")[1..].each do |table_row|
             villager_name = table_row.css("td a")[0].text
             #gsub is getting rid of the additional quotes around the catchphrase
             villager_catchphrase = table_row.css("td i").text.gsub('"','')
             #gsub is getting rid of the leading space on the birthday
             villager_birthday = table_row.css("td")[4].text.chomp.gsub(/^\s/, "")
             villager_wiki_page = BASE_URL + table_row.css("td a").attribute("href").value
             # Jacob and Spork have different names in NA and PAL, so this has to be accounted for
             if villager_name == "Jacob" || villager_name == "Spork"
                villager_personality = table_row.css("td a")[3].text
                villager_species = table_row.css("td a")[4].text
             else
             villager_personality = table_row.css("td a")[2].text
             villager_species = table_row.css("td a")[3].text
             end
             villagers << {:name => villager_name, 
                :personality => villager_personality, 
                :species => villager_species,
                :birthday => villager_birthday,
                :catchphrase => villager_catchphrase,
                :villager_wiki => villager_wiki_page }
        end
      villagers
    end
    
    #This one needs to return a hash because this hash is what's being passed into the add_villager_attributes method
    def self.scrape_wiki_page(wikipage)
        attributes = {}
        doc = Nokogiri::HTML(open(wikipage))

        attribute_table = doc.css("div.pi-data-value.pi-font")[5..]

        attribute_table.each.with_index do |row, i|
          #binding.pry
          attributes[doc.css("h3.pi-data-label")[i+5].text.downcase.split(" ").join("_").to_sym] = row.text
        end

        # I can't quite figure out ReGex to use chomp with multiple arguments. The game the quote was from was tacked on to the end of the quote
        # so I did this to remove all of the game titles from the end
        if doc.css("blockquote i")[0] == nil
          quote = doc.css("blockquote i").text.chomp("Animal Crossing").chomp("Wild World").chomp("City Folk").chomp("New Leaf").chomp("HHD").chomp("Pocket Camp")
        else
          quote = doc.css("blockquote i")[0].text.chomp("Animal Crossing").chomp("Wild World").chomp("City Folk").chomp("New Leaf").chomp("HHD").chomp("Pocket Camp")
        end
        attributes[:quote] = quote
        attributes
    end
 end