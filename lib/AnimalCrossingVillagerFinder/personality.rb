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

    def self.all_names
      all.map{ |personality| personality.name}
    end

    def add_personality_attributes(attributes_hash)
      attributes_hash.each do |k, v|
      send(("#{k}="), v)
    end
      self
    end
  
    def villagers
      Villager.all.find_all{ |villager| villager.personality == self}
    end

    def species
      villagers.map{ |villager| villager.species}
    end
  
    def self.find_by_name(name)
      all.find{ |personality| personality.name == name}
    end
  
  end