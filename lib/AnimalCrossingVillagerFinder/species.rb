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

  def personalities
    villagers.map{ |villager| villager.personality}
  end

  def self.all_names
    all.map{ |species| species.name}
  end

  def self.find_by_name(name)
    all.find{ |species| species.name == name }
  end

  def self.find_or_create_by_name(name)
    find_by_name(name) ? self.find_by_name(name) : name = Species.new(name)
  end

  def add_species_attributes(attributes_hash)
    attributes_hash.each do |k, v|
    send(("#{k}="), v)
  end
    self
  end

end