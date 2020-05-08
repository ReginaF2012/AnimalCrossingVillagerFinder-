#CLI controller


class CLI

    BASE_URL = "https://animalcrossing.fandom.com"
    # for villager guessing game
    @points = 0
    def call
        welcome
        make_villagers
        #add_attributes_to_villagers
        #binding.pry
        menu
        goodbye
    end

    def error_message
        puts "Sorry I didn't understand you"
    end

    def error_message2
      puts "Sorry I can't understand you. Read over the menu options carefully!"
    end

    def welcome
      puts "Welcome to Animal Crossing Villager Finder!"
      puts "Preparing Villager info, this could take a few minutes... (there are over 300 villagers!)"
    end

    def goodbye
        puts "Goodbye!"
    end    

    def make_villagers
        villagers_array = Scraper.scrape_index_page(BASE_URL+"/wiki/Villager_list_(New_Horizons)")
        Villager.create_from_collection(villagers_array)
    end

    def add_attributes_to_villager(villager_name)
        villager = Villager.find_by_name(villager_name)
        attributes = Scraper.scrape_wiki_page(villager.villager_wiki)
        villager.add_villager_attributes(attributes)
    end
    
    #This is the method I would use if I wanted to scrape everything at the start.
    #def add_attributes_to_villagers
    #    Villager.all.each do |villager|
    #    attributes = Scraper.scrape_wiki_page(villager.villager_wiki)
    #    villager.add_villager_attributes(attributes)
    #    end
    #end
    
    def menu
      puts "If you know the name of the villager you want to know more about enter 'name'."
      puts "If you would like to see all of the villagers, enter 'all'."
      puts "If you would like to see villagers listed by personality enter 'personality'."
      puts "If you would like to see villagers listed by species enter 'species'."
      puts "If you would like to play a game enter 'game'"
      puts "Type exit to leave."
      
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
    random_villager = Villager.all.shuffle.first
    add_attributes_to_villager(random_villager.name)
    puts random_villager.image
    puts "Who's that villager? Enter their name below! (remember names are case sensitive!)"
    puts "Enter 'back' to go back to main menu"
    input = gets.strip
    if input == "back"
      menu
    elsif input == random_villager.name
      puts "Congratulations! That is correct!" 
      @points =+ 1
      puts "Your Score: #{@points}"
      puts "Getting the next villager..."
      sleep(2)
      guess_villager_game
    else 
      puts "Sorry that is incorrect! Better luck on the next one!"
      @points =+ 0
      puts "Your Score: #{@points}"
      puts "Getting the next villager..."
      sleep(2)
      guess_villager_game
    end
  end

  def villager_info_from_name
    puts "Please enter the name of the villager that you want to know more about:"
    input = gets.strip
      if Villager.find_by_name(input).is_a?(Villager)
        add_attributes_to_villager(input)
        Villager.display_attributes(input)
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
          puts "Villager names are case sensitive! Would you like to try again?(y/n)"
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
            if input == "y"
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
    puts "#{Villager.all_species.join(", ")}."

    input = gets.strip.downcase.capitalize

    if input == "Back"
        menu

    elsif Villager.all_species.include?(input)

      Villager.list_by_species(input)
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
    # Because the personalities are listed on the website with a ♂ or ♀ and I didn't want to get rid of that
    # I decided to just hard code this array of personality types to check if the user selected a valid personality
    personality_types = ["Cranky", "Lazy", "Jock", "Smug", "Normal", "Sisterly", "Snooty", "Peppy"]
    puts "Enter 'back' to go back to the menu"
    puts "Select a personality by typing in one of the following:"
    puts "Cranky, Lazy, Jock, Smug, Normal, Sisterly, Snooty, Peppy"

    input = gets.strip.downcase.capitalize

    if input == "Back"
        menu

    elsif personality_types.include?(input)

      Villager.list_by_personality(input)

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