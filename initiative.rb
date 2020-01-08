def initiative()
    session = ""
    # while session != "end"
        puts "Enter the PCs names (press enter between each, enter 'done' when done)."
        pcs = []
        name = STDIN.gets.chomp
        while name != "done"
            pcs << name
            name = STDIN.gets.chomp
        end
        combat = ""
        response = ""
        # while combat != "end"
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
                else
                    return "Then what the fuck do you want?"
                end
            end
            arr = monster_list(encounter)
            initiative = monster_initiative(arr)
            puts "Roll initiative!"
            i = 0
            pcs.each do |pc|
                puts pc
                roll = STDIN.gets.chomp.to_i
                while initiative[roll] == nil
                    
            end
        # end
    # end
end

def monster_list(encounter)
    creatures = File.readlines("#{encounter}")
    bonuses = {}
    creatures.each_with_index do |c, i|
        c = c.chomp
        cs = c.split(" ")
        bonuses["#{cs[0]}"] = cs[1].to_i
        creatures[i] = cs[0]
    end
    return [creatures, bonuses]
end

def encounter_maker()
    arr = []
    puts "Enter names then initiative bonuses."
    name = STDIN.gets.chomp
    while name != "done"
        bonus = STDIN.gets.chomp
        arr << (name + " " + bonus)
        name = STDIN.gets.chomp
    end
    data = arr.join("\n")
    puts "Enter encounter name."
    name = STDIN.gets.chomp
    File.write(name, data)
    return name
end

def monster_initiative(arr)
    creatures = arr[0]
    bonuses = arr[1]
    initiative = []
    creatures.each do |c|
        roll = rand(20) + 1 + bonuses[c]
        initiative[roll] = c
    end
    return initiative
end

p initiative()