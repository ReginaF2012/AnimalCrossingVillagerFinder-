class Villager
  attr_accessor :name, :personality, :species, :birthday, :catchphrase, :villager_wiki, :quote, :initial_clothes,
  :skill, :goal, :favorite_song, :coffee, :appearances, :style, :home_request, :service, :provides, :hours, :regional_names, :image_link, :image
  @@all = []
  
  #Mass assignment is the way to go because I'm scraping a page with nokogiri, which lends itself to returning a hash
  def initialize(attributes_array)
    attributes_array.each { |key, value| self.send("#{key}=", value) }
    @@all << self
  end 

  def self.info=(info)
    @@info = info
  end

  def self.info
    @@info
  end

  #This method is built to take in the array of hashes from the scraper class
  def self.create_from_collection(villagers_array)
    villagers_array.each do |villager_hash|
      Villager.new(villager_hash)
    end
  end

  def self.all
    @@all
  end

  #Since I'm scraping from a list that's already alphabetical, I didn't bother to alphabetize this list
  def self.list_by_name
    all.each_with_index{|villager, i| puts "#{' ' * 50}#{i+1}: #{villager.name}"}
  end

  def self.list_by_personality(personality_type)
    villagers_of_personality = all.find_all{ |villager| villager.personality == Personality.find_by_name(personality_type)}
    villagers_of_personality.each_with_index{ |villager, i| puts "#{' ' * 50}#{i+1}. #{villager.name}"}
  end 

  def self.list_by_species(species_type)
    villager_of_species = all.find_all{ |villager| villager.species.include?(species_type)}
    villager_of_species.each_with_index{ |villager, i| puts "#{' ' * 50}#{i+1}. #{villager.name}"}
  end 

  def self.create_villagers(url)
    villagers_array = Scraper.scrape_index_page(url)
    create_from_collection(villagers_array)
  end

  def add_villager_attributes(attributes_hash)
    attributes_hash.each do |k, v|
      send(("#{k}="), v)
    end
    self
  end
  
  def self.all_personalities
    all.map{ |villager| villager.personality}.uniq
  end

  def self.all_species
    all.map{ |villager| villager.species}.uniq
  end

  def self.find_by_name(name)
  all.find{ |villager| villager.name == name}
  end
  
  #attr_accessor :name, :personality, :species, :birthday, :catchphrase, :villager_wiki, :quote, :initial_clothes,
  #:skill, :goal, :favorite_song, :coffee, :appearances, :style, :home_request, :service, :provides, :hours, :regional_names
  def self.display_attributes(name)
    villager = self.find_by_name(name)
    puts  villager.image
    puts "#{" " * 25}Image Link: #{villager.image_link}"
    puts ""
    puts "#{" " * 50}Name: #{villager.name}" if villager.name
    puts "#{" " * 50}Regional Names: #{villager.regional_names}" if villager.regional_names
    puts "#{" " * 50}Species: #{villager.species.name}" if villager.species
    puts "#{" " * 50}Personality: #{villager.personality.name}" if villager.personality
    puts "#{" " * 50}Catchphrase: '#{villager.catchphrase}'".gsub("'",'"') if villager.catchphrase
    puts "#{" " * 50}Birthday: #{villager.birthday}" if villager.birthday
    puts "#{" " * 50}Favorite Song: #{villager.favorite_song}" if villager.favorite_song
    puts "#{" " * 50}Initial Clothes: #{villager.initial_clothes}" if villager.initial_clothes
    puts "#{" " * 50}Skill: #{villager.skill}" if villager.skill
    puts "#{" " * 50}Goal: #{villager.goal}" if villager.goal
    puts "#{" " * 50}Coffee: #{villager.coffee}" if villager.coffee
    puts "#{" " * 50}Appearances: #{villager.appearances}" if villager.appearances
    puts "#{" " * 50}Style: #{villager.style}" if villager.style
    puts "#{" " * 50}Home Request: #{villager.home_request}" if villager.home_request
    puts "#{" " * 50}Service: #{villager.service}" if villager.service
    puts "#{" " * 50}Provides: #{villager.provides}" if villager.provides
    puts "#{" " * 50}Hours: #{villager.hours}" if villager.hours
    puts "#{" " * 50}Quote: '#{villager.quote}'" if villager.quote
  end

end