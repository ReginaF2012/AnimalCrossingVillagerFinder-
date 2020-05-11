#? Would love to refactor and create a module for the methods that are shared within this class and the Personality class

class Species
  attr_accessor :name, :info, :url
  @@all = []
  
  def initialize(name)
    @name = name
    @@all << self
  end
  
  def self.all
    @@all
  end

  def villagers
    Villager.all.find_all{ |villager| villager.species == self}
  end
  
  # has many through with Personalitys. Didn't end up using it
  def personalities
    villagers.map{ |villager| villager.personality}
  end

  def self.all_names
    all.map{ |species| species.name}
  end

  def self.find_by_name(name)
    all.find{ |species| species.name.downcase == name.downcase }
  end

  def self.find_or_create_by_name(name)
    find_by_name(name) ? self.find_by_name(name) : name = Species.new(name)
  end

end