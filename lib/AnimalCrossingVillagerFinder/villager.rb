class Villager 
  attr_accessor :name, :personality, :species, :birthday, :catchphrase

  @@url = "https://animalcrossing.fandom.com/wiki/Villager_list_(New_Horizons)"

  @@all = []

  def initialize(attributes_array)
    attributes_array.each { |key, value| self.send("#{key}=", value) }
    @@all << self
  end 

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
    all.each_with_index{|villager, i| puts "#{i+1}: #{villager.name}"}
  end

  def self.list_by_personality(personality_type)
    villager_of_personality = all.find_all{ |villager| villager.personality.include?(personality_type)}
    villager_of_personality.each_with_index{ |villager, i| puts "#{i+1}. #{villager.name}"}
  end 

  def self.list_by_species(species_type)
    villager_of_species = all.find_all{ |villager| villager.species.include?(species_type)}
    villager_of_species.each_with_index{ |villager, i| puts "#{i+1}. #{villager.name}"}
  end 

  def self.make_villagers
    villagers_array = Scraper.scrape_index_page(@@url)
    create_from_collection(villagers_array)
  end
  
  def self.all_personalities
    all.map{ |villager| villager.personality}.uniq
  end

  def self.all_species
    all.map{ |villager| villager.species}.uniq
  end

  def self.find_villager_by_name(name)
  all.find{ |villager| villager.name == name}
  end
  
  #I may end up combining this method with the .find_villager_by_name method, for some reason I'm thinking
  #I might have a situation where I want to get the villager by name but maybe not display all of the info for it
  def self.display_attributes(name)
    villager = self.find_villager_by_name(name)
    puts "Villager name: #{villager.name}"
    puts "Villager species: #{villager.species}"
    puts "Villager personality: #{villager.personality}"
    puts "Villager catchphrase: #{villager.catchphrase}"
    puts "Villager birthday: #{villager.birthday}"
  end

end