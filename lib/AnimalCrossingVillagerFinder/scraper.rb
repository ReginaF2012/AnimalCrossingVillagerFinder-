
#require 'nokogiri'
#require 'open-uri'
#require 'pry'


class Scraper 

    def self.scrape_index_page(index_url)
        index_page = Nokogiri::HTML(open(index_url))
        villagers = []
       
        index_page.css("table.sortable tr")[1..].each do |table_row|
             villager_name = table_row.css("td a")[0].text
             villager_catchphrase = table_row.css("td i").text.gsub('"','')
             villager_birthday = table_row.css("td")[4].text.chomp.gsub(/^\s/, "")
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
                :catchphrase => villager_catchphrase }
        end
      villagers
    end
 end