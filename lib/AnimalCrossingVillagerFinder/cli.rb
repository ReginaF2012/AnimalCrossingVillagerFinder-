#CLI controller


class CLI

    def call
        welcome
        Villager.make_villagers
        menu
        goodbye
    end

    def welcome
      puts "Welcome to Animal Crossing Villager Finder!"
      puts "Preparing Villager info, this could take a minute..."
    end
    
    def menu
      puts "If you would like to see all of the villagers, enter 'all'."
      puts "If you would like to see villagers listed by personality or species"
      puts "enter 'personality' or 'species'"
      input = ""
        while input != "exit"
            input = gets.strip.downcase
            if input == "all"
              Villager.list_by_name 
            elsif input == "personality"
              personality_types = ["Cranky", "Lazy", "Jock", "Smug", "Normal", "Sisterly", "Snooty", "Peppy"]
              puts "Select a personality by typing in one of the following:"
              puts "Cranky, Lazy, Jock, Smug, Normal, Sisterly, Snooty, or Peppy."
              selection = gets.strip.downcase.capitalize 
       
              while personality_types.include?(selection) == false && selection != "exit"
                puts "Sorry I didn't understand you."
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
                
                while species_types.include?(selection) == false && selection != "exit"
                  puts "Sorry I didn't understand you."
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