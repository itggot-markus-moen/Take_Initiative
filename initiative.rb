def initiative()
    session = ""
    puts "Enter the PCs names (press enter between each, enter nothing when done)."
    pcs = []
    name = STDIN.gets.chomp
    while name != ""
        pcs << name
        name = STDIN.gets.chomp
    end
    combat = ""
    response = ""
    while session != "done"
        puts "Load encounter? (y/n)"
        response = STDIN.gets.chomp
        if response == "y"
            encounters = Dir["*.txt"]
            puts encounters
            puts "Please select encounter by number (1-#{encounters.length})."
            number = STDIN.gets.chomp.to_i - 1
            encounter = encounters[number]
        else
            puts "Build encounter? (y/n)"
            response = STDIN.gets.chomp
            if response == "y"
                encounter = encounter_maker()
            end
        end
        if response == "y"
            arr = monster_list(encounter)
            initiative = monster_initiative(arr)
            puts "Roll initiative!"
            i = 0
            pcs.each do |pc|
                puts pc
                roll = STDIN.gets.chomp.to_i
                initiative[pc] = roll
            end
            initiative = initiative.sort_by(&:last).reverse.to_h
            puts "Enter 'done' when done, 'help' for more commands."
            i = 0
            combat = ""
            while combat != "done"
                while combat != ""
                    if combat == "help"
                        puts "'list' for initiative order.\n"
                    end
                    if combat == "list"
                        j = 0
                        list = ""
                        while j < initiative.length
                            list += "#{initiative.values[j]}: #{initiative.keys[j]}\n"
                            j += 1
                        end
                        puts list
                    end
                    combat = STDIN.gets.chomp
                    end
                puts "#{initiative.values[i]}: #{initiative.keys[i]}\n\n"
                i += 1
                i = i % initiative.length
                combat = STDIN.gets.chomp
            end
        end
        puts "Enter 'done' if the session is over."
        session = STDIN.gets.chomp
    end
    return "Hope you had fun!"
end

def monster_list(encounter)
    creatures = File.readlines("#{encounter}")
    bonuses = {}
    creatures.each_with_index do |c, i|
        c = c.chomp
        cs = c.split(";")
        bonuses["#{cs[0]}"] = cs[1].to_i
        creatures[i] = cs[0]
    end
    return [creatures, bonuses]
end

def encounter_maker()
    arr = []
    puts "Enter names then initiative bonuses."
    name = STDIN.gets.chomp
    while name != ""
        bonus = STDIN.gets.chomp
        arr << (name + ";" + bonus)
        name = STDIN.gets.chomp
    end
    data = arr.join("\n")
    puts "Enter encounter name."
    name = STDIN.gets.chomp
    File.write("#{name}.txt", data)
    return "#{name}.txt"
end

def monster_initiative(arr)
    creatures = arr[0]
    bonuses = arr[1]
    initiative = {}
    creatures.each do |c|
        roll = rand(20) + 1 + bonuses[c]
        initiative[c] = roll
    end
    return initiative
end

puts initiative()