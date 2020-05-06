#CLI controller


class CLI

    def call
        welcome
        Villager.make_villagers
        #binding.pry
        menu
        goodbye
    end

    def error_message
        puts "Sorry I didn't understand you"
    end

    def welcome
      puts "Welcome to Animal Crossing Villager Finder!"
      puts "Preparing Villager info, this could take a minute..."
    end
    
    def menu
      puts "If you would like to see all of the villagers, enter 'all'."
      puts "If you would like to see villagers listed by personality or species"
      puts "enter 'personality' or 'species'."
      puts "If you know the name of the villager you want to know more about enter 'name'."
      input = ""
        while input != "exit"
            input = gets.strip.downcase
            if input = "name"
               puts "Please enter the name of the villager that you want to know more about:"
               input = gets.strip
               if Villager.display_attributes(input)
                Villager.display_attributes(input)
               else

               end
            elsif input == "all"
              Villager.list_by_name 
            elsif input == "personality"
              # Because the personalities are listed on the website with a ♂ or ♀ and I didn't want to get rid of that
              # I decided to just hard code this array of personality types to check if the user selected a valid personality
              personality_types = ["Cranky", "Lazy", "Jock", "Smug", "Normal", "Sisterly", "Snooty", "Peppy"]
              puts "Select a personality by typing in one of the following:"
              puts "Cranky, Lazy, Jock, Smug, Normal, Sisterly, Snooty, or Peppy."
              selection = gets.strip.downcase.capitalize 
       
              while personality_types.include?(selection) == false && selection != "exit"
                error_message
                puts "Select a personality by typing in one of the following:"
                puts "Cranky, Lazy, Jock, Smug, Normal, Sisterly, Snooty, or Peppy."
                puts "Enter 'exit' twice to exit."
                selection = gets.strip.downcase.capitalize
              end
                Villager.list_by_personality(selection)
            elsif input == "species"
                puts "Select a species by typing in one of the following:"
                puts "#{Villager.all_species.join(", ")}"
                selection = gets.strip.downcase.capitalize
                
                while Villager.all_species.include?(selection) == false && selection != "exit"
                  error_message
                  puts "Select a species by typing in one of the following:"
                  puts "Cranky, Lazy, Jock, Smug, Normal, Sisterly, Snooty, or Peppy."
                  puts "Enter 'exit' twice to exit."
                  selection = gets.strip.downcase.capitalize
                end
                  Villager.list_by_species(selection)
            end
        end
    end

    def goodbye
        puts "Goodbye!"
    end
end