########### IMAN ALI ###########
########### imaali ###########
########### 112204305 ###########

class ValueError < RuntimeError
end

class Cave
  def initialize()
    @edges = [[1, 2], [2, 10], [10, 11], [11, 8], [8, 1], [1, 5], [2, 3], [9, 10], [20, 11], [7, 8], [5, 4],
                      [4, 3], [3, 12], [12, 9], [9, 19], [19, 20], [20, 17], [17, 7], [7, 6], [6, 5], [4, 14], [12, 13],
                      [18, 19], [16, 17], [15, 6], [14, 13], [13, 18], [18, 16], [16, 15], [15, 14]]
    @rooms = {}

    # Create all the rooms
    (1..20).each {|i|
      @rooms[i] = Room.new(i)
    }

    # Connect the rooms according to the edges
    @edges.each {|e|
      @rooms[e[0]].connect(@rooms[e[1]])
    }
  end

  # Adds hazard to count times random rooms
  def add_hazard(thing, count)
    random = rand(1..(20-count))
    (0...count).each {
      @rooms[random].add(thing)
      random += 1
    }
  end

  # Returns a random room
  def random_room
    return @rooms[rand(1..20)]
  end

  # Move hazard from 'frm' room to 'to' room, if doesnt exist then ValueError
  def move(thing, frm, to)
    @rooms.each do |room|
      if room == frm
        begin
          room.remove(thing)
        rescue ValueError
          raise ValueError
        end
      end
    end

    @rooms.each do |room|
      if room == to
        room.add(thing)
      end
    end
  end

  # Returns first room with a hazard, if none exist then None
  def room_with(thing)
    (1..20).each {|i|
      if not @rooms[i].empty?
        return @rooms[i]
      end
    }

    return nil
  end

  # Returns a room that is safe, otherwise None
  def entrance
    (1..20).each {|i|
      if @rooms[i].safe?
        return @rooms[i]
      end
    }
    return nil
  end

  # Returns room at number
  def room(number)
    return @rooms.fetch(number)
  end
end

class Player
  def initialize
    @encounters = {}
    @room = nil
  end
  attr_reader :room

  # Store callbacks for encountering hazards
  def encounter(thing, &callback)
    @encounters[thing] = callback
  end

  # Enter room and return results of encountering a hazard if there is one
  def enter(room)
    @room = room
  end

  # Explore neighbors and sense their hazards
  def explore_room(msg)
    @room.exits.each {|neigh_num|
      @room.neighbor(neigh_num).hazards.each { |haz|
        #@senses[haz].call(self)
        haz = haz.to_s
        if (haz == 'bats')
          msg.push("You hear a rustling sound nearby")
        elsif (haz == 'guard')
          msg.push("You smell something terrible nearby")
        elsif (haz == 'pit')
          msg.push("You feel a cold wind blowing from a nearby cavern.")
        end
      }
    }
  end
end

class Room
  def initialize(number)
    @number = number
    @hazards = []
    @neighbors = []
  end

  # Making these properties accessible from outside the class
  attr_reader :number, :hazards, :neighbors

  # Add hazard to room
  def add(thing)
    @hazards.push(thing) if not has?(thing)
  end

  # Remove hazard from room if exists, else return ValueError
  def remove(thing)
    if has?(thing)
      @hazards.delete(thing)
    else
      raise ValueError
    end
  end

  # Check if room has hazards, if yes True, else False
  def has?(thing)
    @hazards.include? thing
  end

  # Returns true if room has no hazards, else False
  def empty?
    @hazards.empty?
  end

  # Returns true if no hazards in this room or its neighbors, else False
  def safe?
    return false if not empty?

    @neighbors.each {|neigh|
      return false if not neigh.empty?
    }

    return true
  end

  # Connects to rooms via the neighbors list
  def connect(other_room)
    if not @neighbors.include? other_room
      @neighbors.push(other_room)
      other_room.connect(self)
    end

  end

  # Returns a list of all neighbors numbers
  def exits
    adjacent = []
    @neighbors.each {|neigh| adjacent.push(neigh.number)}
    return adjacent
  end

  # Returns neighbor with that number, and if that number not a neighbor then None
  def neighbor(number)
    @neighbors.each {|neigh|
      if neigh.number == number
        return neigh
      end
      }

      return nil
  end

  # Returns a random neighbor
  def random_neighbor
    if @neighbors.empty?
      raise IndexError
    end
    random = rand(@neighbors.length())
    return @neighbors[random]
  end
end

class Console
  def initialize(player, narrations)
    @player   = player
    @narrations = narrations
  end
  attr_accessor :player, :narrations

  def show_room_description
    @narrations.push("-----------------------------------------")
    @narrations.push("You are in room #{@player.room.number}.")

    @player.explore_room(@narrations)

    @narrations.push("Exits go to: <#{@player.room.exits.join(', ')}>")
    @narrations.push("-----------------------------------------")
  end
end
