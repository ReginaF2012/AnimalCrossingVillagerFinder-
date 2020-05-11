class Personality
  @@all = []
  attr_accessor :name, :info, :url
  attr_reader :villagers
  
    def initialize
      @@all << self
    end
    #? Is this right??? I want to be able to set a class variable in the scraper class... it seems to work
    def self.info=(info)
      @@info = info
    end
  
    def self.info
      @@info
    end
  
    def self.all
      @@all
    end
    
    # I had a couple of places where I listed all of the personalities to the user to choose from
    # having a method that did this for me made this easier
    def self.all_names
      all.map{ |personality| personality.name}
    end
    
  
    # All of the villagers with a certain personality
    def villagers
      Villager.all.find_all{ |villager| villager.personality == self}
    end

    # This isn't used anywhere in my program but this is a 'has many through' relationship with species
    def species
      villagers.map{ |villager| villager.species}
    end
  
    def self.find_by_name(name)
      all.find{ |personality| personality.name.downcase == name.downcase}
    end
  
  end