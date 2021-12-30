############ IMAN ALI ############
########### 112204305 ############
########### IMAALI ############
import random
from enum import Enum

# Defines possible hazards in the game.
class Hazard(Enum):
    guard = "Guard"
    pit = "Pit"
    bats = "Bats"


# Defines possible actions a player can take.
class Action(Enum):
    move = "move"
    shoot = "shoot"
    stay = "stay"
    startle_guard = "startle_guard"


class Cave:
    def __init__(self):
        self.edges = [[1, 2], [2, 10], [10, 11], [11, 8], [8, 1], [1, 5], [2, 3], [9, 10], [20, 11], [7, 8], [5, 4],
                      [4, 3], [3, 12], [12, 9], [9, 19], [19, 20], [20, 17], [17, 7], [7, 6], [6, 5], [4, 14], [12, 13],
                      [18, 19], [16, 17], [15, 6], [14, 13], [13, 18], [18, 16], [16, 15], [15, 14]]

        self.rooms = {}
        # Create all the rooms
        for i in range(1, 21):
            self.rooms[i] = Room(i)

        # Connect the rooms according to the edges
        for e in self.edges:
            self.rooms[e[0]].connect(self.rooms[e[1]])

    # Adds hazard to count times random rooms
    def add_hazard(self, thing, count):
        rand = random.randint(1, 20-count)
        for i in range(count):
            self.rooms[rand].add(thing)
            rand += 1

    # Returns a random room
    def random_room(self):
        rand = random.randint(1, 20)
        return self.rooms[rand]

    # Returns first room with a hazard, if none exist then None
    def room_with(self, thing):
        for i in range(1, 21):
            if not self.rooms[i].empty():
                return self.rooms[i]

        return None

    # Move hazard from 'frm' room to 'to' room, if doesnt exist then ValueError
    def move(self, thing, frm, to):
        for r_num, r_obj in self.rooms.items():
            if r_obj == frm:
                try:
                    r_obj.remove(thing)
                except ValueError:
                    raise ValueError

        for num, room in self.rooms.items():
            if room == to:
                room.add(thing)

    # Returns room at number
    def room(self, number):
        if not self.rooms[number]:
            raise KeyError
        return self.rooms[number]

    # Returns a room that is safe, otherwise None
    def entrance(self):
        for i in range(1, 21):
            if self.rooms[i].safe():
                return self.rooms[i]

        return None


class Room:
    def __init__(self, number):
        self.number = number
        self.hazards = []
        self.neighbors = []

    # Check if room has hazards, if yes True, else False
    def has(self, thing):
        if thing in self.hazards:
            return True
        else:
            return False

    # Add hazard to room
    def add(self, thing):
        if not self.has(thing):
            self.hazards.append(thing)

    # Remove hazard from room if exists, else return ValueError
    def remove(self, thing):
        if self.has(thing):
            self.hazards.remove(thing)
        else:
            raise ValueError

    # Returns true if room has no hazards, else False
    def empty(self):
        return not bool(self.hazards)

    # Returns true if no hazards in this room or its neighbors, else False
    def safe(self):
        if not self.empty():
            return False

        for neigh in self.neighbors:
            # Check every neighbour
            if not neigh.empty():
                return False

        return True

    # Connects to rooms via the neighbors list
    def connect(self, other_room):
        if not other_room in self.neighbors:
            self.neighbors.append(other_room)
            other_room.connect(self)

    # Returns a list of all neighbors numbers
    def exits(self):
        all_adj = []
        for neigh in self.neighbors:
            all_adj.append(neigh.number)

        return all_adj

    # Returns neighbor with that number, and if that number not a neighbor then None
    def neighbor(self, number):
        for neigh in self.neighbors:
            if neigh.number == number:
                return neigh

        return None

    # Returns a random neighbor
    def random_neighbor(self):
        if not self.neighbors:
            raise IndexError
        return self.neighbors[random.randint(0, len(self.neighbors)-1)]


class Player:
    def __init__(self):
        self.senses = {}
        self.encounters = {}
        self.actions = {}
        self.room = None

    # Store callbacks for sensing hazards
    def sense(self, thing, callback):
        self.senses[thing] = callback

    # Store callbacks for encountering hazards
    def encounter(self, thing, callback):
        self.encounters[thing] = callback

    # Store callbacks for actions
    def action(self, thing, callback):
        self.actions[thing] = callback

    # Enter room and return results of encountering a hazard if there is one
    def enter(self, room):
        self.room = room

        # if there are hazards, then use callback of the first one encountered
        if not self.room.empty():
            for enc in self.encounters.keys():
                if self.room.has(enc):
                    self.encounters[enc]()
                    break

    # Explore neighbors and sense their hazards
    def explore_room(self):
        for neigh_num in self.room.exits():
            for haz in self.room.neighbor(neigh_num).hazards:
                self.senses[haz]()

    # Perform action on destination room
    def act(self, action, destination):
        if not self.actions.get(action):
            raise KeyError

        for act in self.actions:
            if act == action:
                self.actions[act](destination)


class Narrator:
    def __init__(self):
        self.ending_message = None

    def say(self, message):
        print(message)

    def ask(self, question):
        return input(question)

    def tell_story(self, story):
        while not self.ending_message:
            story()
        self.say("-----------------------------------------")
        self.say(self.ending_message)

    def finish_story(self, message):
        self.ending_message = message


class Console:
    def __init__(self, player, narrator):
        self.player = player
        self.narrator = narrator

    def show_room_description(self):
        self.narrator.say("-----------------------------------------")
        self.narrator.say("You are in room #" + str(self.player.room.number))
        self.player.explore_room()
        self.narrator.say("Exits go to: " + ",".join([str(x) for x in self.player.room.exits()]))

    def ask_player_to_act(self):
        actions = {"m": Action.move, "s": Action.shoot}
        self.accepting_player_input(
            lambda command, room_number: self.player.act(actions[command], self.player.room.neighbor(room_number)))

    def accepting_player_input(self, act):
        self.narrator.say("-----------------------------------------")
        command = self.narrator.ask("What do you want to do? (m)ove or (s)hoot?")
        if command not in ["m", "s"]:
            self.narrator.say("INVALID ACTION! TRY AGAIN!")
            return
        try:
            dest = int(self.narrator.ask("Where?"))
            if dest not in self.player.room.exits():
                self.narrator.say("INVALID ACTION! TRY AGAIN!")
                return
        except ValueError:
            self.narrator.say("INVALID ACTION! TRY AGAIN!")
            return
        act(command, dest)
