#CLI controller


class CLI

  BASE_URL = "https://animalcrossing.fandom.com"

  def call
      welcome
      Scraper.info_scrape("https://animalcrossing.fandom.com/wiki/Villager")
      Scraper.initial_scrape("https://animalcrossing.fandom.com/wiki/Villager_list_(New_Horizons)")
      menu
  end
  
  def error_message
      puts "Sorry I didn't understand you"
  end

  def error_message2
    puts "Sorry I can't understand you. Read over the menu options carefully!"
  end

  def welcome
    puts ""
    puts ""
    puts ""
    puts ""
    puts ""
    puts ""
    puts ""
    puts ""
    puts "Welcome to Animal Crossing Villager Finder!"
    puts "Gathering villager info, this could take a moment... (there are over 300 villagers!)"
  end

  def goodbye
      puts "Goodbye!"
  end    


  def add_attributes_to_villager(villager)
      Scraper.second_scrape(villager)
  end
  
  def add_attributes_to_species(species)
        if species.name == "Frog" || species.name == "Octopus"
          species.info = "Sorry, there isn't any more information about this species!"
        else
          Scraper.species_attributes_scrape(species)
        end
  end
  
  def add_attributes_to_personality(personality)
   Scraper.personality_attributes_scrape(personality)
  end

  def menu
    puts "If you know the name of the villager you want to know more about enter 'name'."
    puts "If you would like to see all of the villagers, enter 'all'."
    puts "If you would like to see villagers listed by personality enter 'personality'."
    puts "If you would like to see villagers listed by species enter 'species'."
    puts "If you would like to play a game enter 'game'"
    puts "If you would like to learn more about villagers, species, or personalities, enter 'learn'."
    puts "Enter 'exit' to leave."
    
    input = gets.strip.downcase

    if input == "exit"

      goodbye
      exit

    end

     while input != "exit"

       if input == "name"

        villager_info_from_name

       elsif input == "all"

        list_of_all_villagers

       elsif input == "personality"

        villager_by_personality

       elsif input == "species"

        villager_by_species

       elsif input == "game"

        guess_villager_game

       elsif input == "learn"
        
        learn

       else

        error_message2
        menu

       end

    end
  end

  def learn
    puts "Enter 'back' to go back to the main menu."
    puts "Enter the name of what you would like to learn more about:"
    puts "..........Villagers...Species...Personalities.........."
    input = gets.strip.downcase

    if input == "exit"
      exit
    elsif input == "back"
      menu
    elsif input == "villagers"
      puts "#{Villager.info}"
      puts "Would you like to learn about something else? (y/n)"

      input = gets.strip.downcase
      if input == "exit"
        exit
      elsif input == "back"
        menu
      elsif input == "y"
        learn
      elsif input == "n"
        menu
      else
        error_message
        learn
      end

    elsif input == "personalities"
      puts "#{Personality.info}"
      puts "Enter the name of one of the personalities to learn more about a specific personality!"
      puts "The personalities are: #{Personality.all_names.join(", ")}."
      puts "Enter 'back' to go back to the main menu."
      puts "Would you like to learn about something else? (y/n)"
      input = gets.strip.downcase
      
      if input == "exit"
        exit
      elsif input == "back"
        menu
      elsif input == "y"
        learn
      elsif input == "n"
        menu
      elsif Personality.find_by_name(input).is_a?(Personality)
        selected_personality = Personality.find_by_name(input)
        add_attributes_to_personality(selected_personality)
        puts "#{selected_personality.info}"
        puts "Would you like to learn more about something else? (y/n)"
        
        input = gets.strip.downcase
        if input == "exit"
          exit
        elsif input == "back" || input == "n"
          menu
        elsif input == "y"
          learn
        else 
          error_message
          learn
        end
      else
      error_message2
      learn
      end

    elsif input == "species"

      puts "Enter 'back' to go back to the menu."
      puts "Enter 'learn' to go back to the learn menu."
      puts "Select a species to learn about by typing in one of the following:"
      puts "#{Species.all_names[0..5].join(", ")}"
      puts "#{Species.all_names[5..10].join(", ")}"
      puts "#{Species.all_names[10..15].join(", ")}"
      puts "#{Species.all_names[15..20].join(", ")}"
      puts "#{Species.all_names[20..25].join(", ")}"
      puts "#{Species.all_names[25..30].join(", ")}"
      puts "#{Species.all_names[30..].join(", ")}."
      input = gets.strip.downcase
      if input == "exit"
        exit
      elsif input == "back"
        menu
      elsif input == "learn"
        learn
      elsif Species.find_by_name(input).is_a?(Species)
        selected_species = Species.find_by_name(input)
        add_attributes_to_species(selected_species)
        puts "#{selected_species.info}"
        puts "Would you like to learn more about something else? (y/n)"
        input = gets.strip.downcase
        if input == "exit"
          exit
        elsif input == "back" || input == "n"
          menu
        elsif input == "y"
          learn
        else 
          error_message
          learn
        end
        
      else 
        error_message2
        learn
      end
    end

  end

  def guess_villager_game
    points = 0
    i = 0
    input = nil
    while input != "exit" || input != "back"
      i += 1
  
    random_villager = Villager.all.shuffle.first
  
    add_attributes_to_villager(random_villager)
  
    puts random_villager.image
  
    puts "Who's that villager? Enter their name below!"
    puts "Enter 'back' to go back to main menu"
  
    input = gets.strip.downcase
    if input == "exit"
      goodbye
      exit
  
    elsif input == "back"
  
      menu
    end
  
    
      if input.downcase == random_villager.name.downcase
  
        puts "Congratulations! That is correct!"
        points += 1
        puts "Your Score: #{points}/#{i}"
        puts "Getting the next villager..."
        sleep(2)
  
      else
  
        puts "Sorry that is incorrect! Better luck on the next one!"
        puts "That villager's name is: #{random_villager.name}!"
        puts "Your Score: #{points}/#{i}"
        puts "Getting the next villager..."
        sleep(2)
  
      end
    end
  end


def villager_info_from_name
  
  puts "Enter 'back' to go back to the main menu."
  puts "Please enter the name of the villager that you want to know more about:"

  input = gets.strip.downcase
    if input == "exit"

      goodbye
      exit
    
    elsif input == "back"
      
      menu

    elsif Villager.find_by_name(input).is_a?(Villager)
      selected_villager = Villager.find_by_name(input)
      add_attributes_to_villager(selected_villager)
      Villager.display_attributes(selected_villager)

      puts "Do you have the name of another villager you would like to learn more about?(y/n)"

      input = gets.strip.downcase

        if input == "y"

          villager_info_from_name

        elsif input == "n"

          menu
          
        else

          error_message2
          menu

        end
    else

        error_message
        puts "Would you like to try again?(y/n)"

        input = gets.strip.downcase

        if input == "y"

          villager_info_from_name

        elsif input == "n"

          menu

        else

          error_message2
          menu

        end
      end
end

def list_of_all_villagers

  Villager.list_by_name 

  puts "Would you like to learn more about one of these villagers?(y/n)"

  input = gets.strip.downcase
    
    if input == "exit"

      goodbye
      exit

    elsif input == "y"

      villager_info_from_name

    elsif input == "n"

      menu

    else
      error_message
      puts "Would you like to learn more about one of these villagers?(y/n)"
      input = gets.strip.downcase
              
        if input == "y"

          villager_info_from_name

        elsif input == "n"
           
          menu

        else

          error_message2
          menu

        end

    end
end

def villager_by_species
  puts "Enter 'back' to go back to the menu"
  puts "Select a species by typing in one of the following:"
  puts "#{Species.all_names[0..5].join(", ")}"
  puts "#{Species.all_names[5..10].join(", ")}"
  puts "#{Species.all_names[10..15].join(", ")}"
  puts "#{Species.all_names[15..20].join(", ")}"
  puts "#{Species.all_names[20..25].join(", ")}"
  puts "#{Species.all_names[25..30].join(", ")}"
  puts "#{Species.all_names[30..].join(", ")}."
  
  input = gets.strip.downcase
  
  if input == "exit"

    goodbye
    exit

  elsif input == "back"

      menu

  elsif Species.find_by_name(input).is_a?(Species)

    Species.find_by_name(input).villagers.each_with_index do |villager, i|
   
      puts "#{i+1}: #{villager.name}"

    end

    puts "Would you like to know more about one of these villagers?(y/n)"

    input = gets.strip.downcase

    if input == "y"

      villager_info_from_name

    elsif input == "n"

      puts "Would you like to see a different list of villagers by species?(y/n)"
      input = gets.strip.downcase

        if input == "y"

          villager_by_species

        elsif input == "n"

          menu

        end

    else

      error_message
      villager_by_species

    end

  else

    error_message
    villager_by_species
end
end

def villager_by_personality
  
  puts "Enter 'back' to go back to the menu"
  puts "Select a personality by typing in one of the following:"
  puts "Cranky, Lazy, Jock, Smug, Normal, Sisterly, Snooty, Peppy"

  input = gets.strip.downcase

  if input == "exit"

    goodbye
    exit

  elsif input == "back"

      menu

  elsif Personality.find_by_name(input).is_a?(Personality)

    Personality.find_by_name(input).villagers.each_with_index do |villager, i|

      puts "#{i+1}: #{villager.name}"

    end

    puts "Would you like to know more about one of these villagers?(y/n)"

    input = gets.strip.downcase

    if input == "y"

      villager_info_from_name

    elsif input == "n"

      puts "Would you like to see a different list of villagers by personality?(y/n)"
      input = gets.strip.downcase

        if input == "y"

          villager_by_personality

        elsif input == "n"

          menu

        end

    else

      error_message
      villager_by_personality

    end

  else

      error_message
      villager_by_personality
      
  end
end
end