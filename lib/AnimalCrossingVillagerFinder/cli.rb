#CLI controller


class CLI

    BASE_URL = "https://animalcrossing.fandom.com"

    def call
        welcome
        Scraper.info_scrape("https://animalcrossing.fandom.com/wiki/Villager")
        #there aren't that many personalities, so I decided to scrape all info for them here
        add_attributes_to_personalities
        make_villagers
        add_attributes_to_species
        menu
    end
    #Before Thinking
    
    def error_message
        puts "#{' ' * 50}Sorry I didn't understand you"
    end

    def error_message2
      puts "#{' ' * 50}Sorry I can't understand you. Read over the menu options carefully!"
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
      puts "#{' ' * 50}Welcome to Animal Crossing Villager Finder!"
      puts "#{' ' * 50}Villager info, this could take a moment... (there are over 300 villagers!)"
    end

    def goodbye
        puts "#{' ' * 50}Goodbye!"
    end    

    def make_villagers
        villagers_array = Scraper.initial_scrape(BASE_URL+"/wiki/Villager_list_(New_Horizons)")
        Villager.create_from_collection(villagers_array)
    end

    def add_attributes_to_villager(villager_name)
        villager = Villager.find_by_name(villager_name)
        attributes = Scraper.scrape_wiki_page(villager.villager_wiki)
        villager.add_villager_attributes(attributes)
    end
    
    def add_attributes_to_species
        Species.all.each do |species|
        attributes = Scraper.species_attributes_scrape(species.url)
        species.add_species_attributes(attributes)
          if species.name == "Frog" || "Octopus"
            species.info = "Sorry, there isn't any more information about this species!"
          end
        end
    end
    
    def add_attributes_to_personalities
      Personality.all.each do |personality|
      attributes = Scraper.personality_attributes_scrape(personality.url)
      personality.add_personality_attributes(attributes)
      end
    end

    def menu
      puts "#{' ' * 50}If you know the name of the villager you want to know more about enter 'name'."
      puts "#{' ' * 50}If you would like to see all of the villagers, enter 'all'."
      puts "#{' ' * 50}If you would like to see villagers listed by personality enter 'personality'."
      puts "#{' ' * 50}If you would like to see villagers listed by species enter 'species'."
      puts "#{' ' * 50}If you would like to play a game enter 'game'"
      puts "#{' ' * 50}Type exit to leave."
      
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

         else

          error_message2
          menu

         end

      end
    end

  def guess_villager_game
    points = 0
    i = 0
    input = nil
    while input != "exit" || "back"
      i += 1

    random_villager = Villager.all.shuffle.first

    add_attributes_to_villager(random_villager.name)

    puts random_villager.image

    puts "Who's that villager? Enter their name below! (remember names are case sensitive!)".center(200)
    puts "Enter 'back' to go back to main menu".center(200)

    input = gets.strip
    if input == "exit"
      goodbye
      exit

    elsif input == "back"

      menu
    end

    
      if input == random_villager.name
  
        puts "Congratulations! That is correct!".center(100)
        points += 1
        puts "Your Score: #{points}".center(100)
        puts "Getting the next villager...".center(100)
        sleep(2)
  
      else
  
        puts "Sorry that is incorrect! Better luck on the next one!".center(100)
        puts "Your Score: #{points}".center(100)
        puts "Getting the next villager...".center(100)
        sleep(2)
  
      end
    end
  end
  end

  def villager_info_from_name
    
    puts "#{' ' * 50}Enter 'back' to go back to the main menu."
    puts "#{' ' * 50}Please enter the name of the villager that you want to know more about:"

    input = gets.strip
      if input == "exit"

        goodbye
        exit
      
      elsif input == "back"
        
        menu

      elsif Villager.find_by_name(input).is_a?(Villager)

        add_attributes_to_villager(input)
        Villager.display_attributes(input)

        puts "#{' ' * 50}Do you have the name of another villager you would like to learn more about?(y/n)"

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
          puts "#{' ' * 50}Villager names are case sensitive! Would you like to try again?(y/n)"

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

    puts "#{' ' * 50}Would you like to learn more about one of these villagers?(y/n)"

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
        puts "#{' ' * 50}Would you like to learn more about one of these villagers?(y/n)"
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
    puts "#{' ' * 50}Enter 'back' to go back to the menu"
    puts "#{' ' * 50}Select a species by typing in one of the following:"
    puts "#{' ' * 50}#{Species.all_names[0..5].join(", ")}"
    puts "#{' ' * 50}#{Species.all_names[5..10].join(", ")}"
    puts "#{' ' * 50}#{Species.all_names[10..15].join(", ")}"
    puts "#{' ' * 50}#{Species.all_names[15..20].join(", ")}"
    puts "#{' ' * 50}#{Species.all_names[20..].join(", ")}."

    
    input = gets.strip.downcase.capitalize
    
    if input == "exit"

      goodbye
      exit

    elsif input == "Back"

        menu

    elsif Villager.all_species.include?(input)

      Villager.list_by_species(input)

      puts "#{' ' * 50}Would you like to know more about one of these villagers?(y/n)"

      input = gets.strip.downcase

      if input == "y"

        villager_info_from_name

      elsif input == "n"

        puts "#{' ' * 50}Would you like to see a different list of villagers by species?(y/n)"
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
    
    puts "#{' ' * 50}Enter 'back' to go back to the menu"
    puts "#{' ' * 50}Select a personality by typing in one of the following:"
    puts "#{' ' * 50}Cranky, Lazy, Jock, Smug, Normal, Sisterly, Snooty, Peppy"

    input = gets.strip.downcase.capitalize

    if input == "exit"

      goodbye
      exit

    elsif input == "Back"

        menu

    elsif Personality.find_by_name(input).is_a?(Personality)

      Villager.list_by_personality(input)

      puts "#{' ' * 50}Would you like to know more about one of these villagers?(y/n)"

      input = gets.strip.downcase

      if input == "y"

        villager_info_from_name

      elsif input == "n"

        puts "#{' ' * 50}Would you like to see a different list of villagers by personality?(y/n)"
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