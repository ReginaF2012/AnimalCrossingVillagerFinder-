class Villager
  attr_accessor :name, :personality, :species, :birthday, :catchphrase, :villager_wiki, :quote, :initial_clothes,
  :skill, :goal, :favorite_song, :coffee, :appearances, :style, :home_request, :service, :provides, :hours, :regional_names, :image_link, :image
  @@all = []
  
  #Mass assignment is the way to go because I'm scraping a page with nokogiri, which lends itself to returning a hash
  def initialize
    @@all << self
  end 

  def self.info=(info)
    @@info = info
  end

  def self.info
    @@info
  end

  def self.all
    @@all
  end

  #Since I'm scraping from a list that's already alphabetical, I didn't bother to alphabetize this list
  def self.list_by_name
    all.each_with_index{|villager, i| puts "#{i+1}: #{villager.name}"}
  end

  def add_villager_attributes(attributes_hash)
    attributes_hash.each do |k, v|
      send(("#{k}="), v)
    end
    self
  end

  def self.find_by_name(name)
  all.find{ |villager| villager.name == name}
  end
  
  #attr_accessor :name, :personality, :species, :birthday, :catchphrase, :villager_wiki, :quote, :initial_clothes,
  #:skill, :goal, :favorite_song, :coffee, :appearances, :style, :home_request, :service, :provides, :hours, :regional_names
  def self.display_attributes(name)
    villager = self.find_by_name(name)
    puts  villager.image
    puts "Image Link: #{villager.image_link}"
    puts ""
    puts ""
    puts "Name: #{villager.name}" if villager.name
    puts "Regional Names: #{villager.regional_names}" if villager.regional_names
    puts "Species: #{villager.species.name}" if villager.species
    puts "Personality: #{villager.personality.name}" if villager.personality
    puts "Catchphrase: '#{villager.catchphrase}'".gsub("'",'"') if villager.catchphrase
    puts "Birthday: #{villager.birthday}" if villager.birthday
    puts "Favorite Song: #{villager.favorite_song}" if villager.favorite_song
    puts "Initial Clothes: #{villager.initial_clothes}" if villager.initial_clothes
    puts "Skill: #{villager.skill}" if villager.skill
    puts "Goal: #{villager.goal}" if villager.goal
    puts "Coffee: #{villager.coffee}" if villager.coffee
    puts "Style: #{villager.style}" if villager.style
    puts "Home Request: #{villager.home_request}" if villager.home_request
    puts "Service: #{villager.service}" if villager.service
    puts "Provides: #{villager.provides}" if villager.provides
    puts "Hours: #{villager.hours}" if villager.hours
    puts "Quote: '#{villager.quote}'" if villager.quote
    puts "Appearances: #{villager.appearances}" if villager.appearances
  end

end