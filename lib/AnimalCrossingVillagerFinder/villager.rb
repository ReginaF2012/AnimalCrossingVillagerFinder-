class Villager

  #? There are many different attributes a villager MAY have I would like to know if there would be
  #? a way to create additional attribute accessors for this class in my second scrape, the way that I figured all of these 
  #? were potential attributes was by doing the second scrape and adding attributes to all of the villagers
  #? over and over and every time I got an error (ie: .style is not a method for whatever instance of a villager)
  #? I would add that attribute accessor and run my program again.
  attr_accessor :name, :personality, :species, :birthday, :catchphrase, :villager_wiki, :quote, :initial_clothes,
  :skill, :goal, :favorite_song, :coffee, :appearances, :style, :home_request, :service, :provides, :hours, :regional_names, :image_link, :image
  @@all = []
  
  
  def initialize
    @@all << self
  end 
  # For info scrape, to add info on the Villager class for the learn method in CLI
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


  # This takes in the hash produced by the second scrape
  def add_villager_attributes(attributes_hash)
    attributes_hash.each do |k, v|
      send(("#{k}="), v)
    end
    self
  end

  def self.find_by_name(name)
  all.find{ |villager| villager.name == name}
  end
  
  
  def self.display_attributes(name)
    villager = self.find_by_name(name)
    puts  villager.image
    # Even though I used the ASCII art for the villager game, I wanted to provide an image link because some of
    # the ASCII art is hard to tell what you're looking at (I figured it added some extra difficulty to the game though)
    puts "Image Link: #{villager.image_link}"
    puts ""
    puts ""
    # The if statements are because not all villagers have all of these attributes
    # I don't want any empty attributes being shown to the user
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