
#require 'nokogiri'
#require 'open-uri'
#require 'pry'


class Scraper 

    def self.scrape_index_page(index_url)
        index_page = Nokogiri::HTML(open(index_url))
        villagers = []
        #binding.pry
        index_page.css("table.sortable tr")[1..].each do |table_row|
            #binding.pry
             villager_name = table_row.css("td a")[0].text
             if villager_name == "Jacob"
                villager_personality = table_row.css("td a")[3].text
                #binding.pry
                vilager_species = table_row.css("td a")[4].text
                villager_birthday = table_row.css("td")[4].text.chomp.gsub(/^\s/, "")
             else
             villager_personality = table_row.css("td a")[2].text
             villager_species = table_row.css("td a")[3].text
             end
             villagers << {:name => villager_name, :personality => villager_personality, :species => villager_species }
        end
      villagers
    end
 end