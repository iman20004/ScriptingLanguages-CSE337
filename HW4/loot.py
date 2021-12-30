########## IMAN ALI ##########
########## 112204305 #############
########## imaali #############

import random

pirateColors = ["blue", "green", "purple", "gold"]
maxPlayersAllowed = 5
minPlayersAllowed = 2
playerNames = ["Joy", "Nan", "Sat"]


class MerchantShip:
    def __init__(self, value):
        self.value = value

    def get_value(self):
        return self.value


class PirateShip:
    def __init__(self, color, attack_value):
        self.color = color
        self.attack_value = attack_value

    def get_value(self):
        return self.attack_value

    def get_color(self):
        return self.color


class Captain:
    def __init__(self, color):
        self.color = color

    def get_color(self):
        return self.color


class Admiral:
    __instance__ = None

    def __init__(self):
        if Admiral.__instance__ is None:
            Admiral.__instance__ = self
        else:
            raise RuntimeError("You cannot create another Admiral")

    @staticmethod
    def get_instance():
        if not Admiral.__instance__:
            Admiral()
        return Admiral.__instance__


class Player:
    def __init__(self, name: str):
        self.name = name
        self.merchant_ships_at_sea = []
        self.merchant_ships_captured = []
        self.hand = []
        self.merchant_pirates = {}
        self.dealer = False

    # Assign player as dealer, shuffle and distribute 6 cards to each player
    def deal(self, game_state):
        self.dealer = True
        random.shuffle(game_state.deck.cards)
        card = 0
        for i in range(6):
            for player in game_state.players:
                current = game_state.deck.cards[card]
                player.hand.append(current)
                game_state.deck.cards.remove(current)
                card += 1

    # Stimulates player drawing card from the deck
    def draw_card(self, game_state):
        if len(game_state.deck.cards) > 0:
            card = game_state.deck.cards.pop()
            self.hand.append(card)
        else:
            raise Exception('Deck is empty! Cannot draw a card!')

    # Remove MerchantShip card from hand and float it
    def float_merchant(self, card):
        if not isinstance(card, MerchantShip):
            return False

        if card not in self.hand:
            return False

        self.hand.remove(card)
        self.merchant_ships_at_sea.append(card)
        return True

    # Attack a floating ship
    def play_pirate(self, pirate_card, merchant_card, p1):
        if pirate_card not in self.hand:
            return False

        if not isinstance(merchant_card, MerchantShip):
            return False

        if merchant_card not in p1.merchant_ships_at_sea:
            return False

        if not isinstance(pirate_card, PirateShip):
            return False

        # if nobody has attacked this ship before then attack with any color
        if merchant_card not in p1.merchant_pirates:
            p1.merchant_pirates[merchant_card] = [(self, pirate_card)]
            self.hand.remove(pirate_card)
            return True

        # Cant play pirate card after captain or admiral
        last_card = p1.merchant_pirates[merchant_card][- 1][1]
        if isinstance(last_card, Captain) or isinstance(last_card, Admiral):
            return False

        # Check if some other player has attacked with this color
        for pair in p1.merchant_pirates[merchant_card]:
            if pair[1].get_color() == pirate_card.get_color() and pair[0] != self:
                return False

        # Check if player itself has attacked previously and color is not same
        for pair in p1.merchant_pirates[merchant_card]:
            if pair[0] is self:
                if pirate_card.get_color() != pair[1].get_color():
                    return False

        # If player hasn't attacked before then attack
        p1.merchant_pirates[merchant_card].append((self, pirate_card))
        self.hand.remove(pirate_card)
        return True

    def play_captain(self, captain_card, merchant_card, p1):
        if captain_card not in self.hand:
            return False

        if not isinstance(merchant_card, MerchantShip):
            return False

        if merchant_card not in p1.merchant_ships_at_sea:
            return False

        if not isinstance(captain_card, Captain):
            return False

        # if nobody has attacked this ship before then attack with any color
        if merchant_card not in p1.merchant_pirates:
            p1.merchant_pirates[merchant_card] = [(self, captain_card)]
            self.hand.remove(captain_card)
            return True

        # Check if some other player has attacked with this color
        for pair in p1.merchant_pirates[merchant_card]:
            if isinstance(pair[1], Admiral):
                continue

            if pair[1].get_color() == captain_card.get_color() and pair[0] != self:
                return False

        # Check if player itself has attacked previously and color is same
        for pair in p1.merchant_pirates[merchant_card]:
            if pair[0] is self:
                if captain_card.get_color() != pair[1].get_color():
                    return False

        p1.merchant_pirates[merchant_card].append((self, captain_card))
        self.hand.remove(captain_card)
        return True

    def play_admiral(self, admiral_card, merchant_card):
        if admiral_card not in self.hand:
            return False

        if merchant_card not in self.merchant_ships_at_sea:
            return False

        if not isinstance(admiral_card, Admiral):
            return False

        if not isinstance(merchant_card, MerchantShip):
            return False

        # if nobody has attacked this ship before then attack
        if merchant_card not in self.merchant_pirates:
            self.merchant_pirates[merchant_card] = [(self, admiral_card)]
            self.hand.remove(admiral_card)
            return True

        self.merchant_pirates[merchant_card].append((self, admiral_card))
        self.hand.remove(admiral_card)
        return True


class Deck:
    __instance__ = None

    def __init__(self):
        if Deck.__instance__ is None:
            Deck.__instance__ = self
            self.cards = []

            # Add Admiral
            self.cards.append(Admiral.get_instance())  # 0

            # Add 5 twos, 6 threes, 5 fours, 5 fives, 2 sixes, 1 seven, and 1 eight merchant cards
            for i in range(5):
                self.cards.append(MerchantShip(2))  # 1,5,9,13,17
                self.cards.append(MerchantShip(4))  # 2,6,10,14,18
                self.cards.append(MerchantShip(5))  # 3,7,11,15,19
                self.cards.append(MerchantShip(3))  # 4,8,12,16,20

            self.cards.append(MerchantShip(3))  # 21
            self.cards.append(MerchantShip(7))  # 22
            self.cards.append(MerchantShip(8))  # 23
            self.cards.append(MerchantShip(6))  # 24
            self.cards.append(MerchantShip(6))  # 25

            # Add four captains
            self.cards.append(Captain("blue"))  # 26
            self.cards.append(Captain("green"))  # 27
            self.cards.append(Captain("purple"))  # 28
            self.cards.append(Captain("gold"))  # 29

            # Add pirate ship cards 2 ones, 4 twos, 4 threes, and 2 fours for each color
            for i in ["blue", "green", "purple", "gold"]:
                self.cards.append(PirateShip(i, 1))  # 30,42,54,66
                self.cards.append(PirateShip(i, 1))  # 31,43,55,67

                self.cards.append(PirateShip(i, 2))  # 32,44,56,68
                self.cards.append(PirateShip(i, 2))  # 33,45,57,69
                self.cards.append(PirateShip(i, 2))  # 34,46,58,70
                self.cards.append(PirateShip(i, 2))  # 35,47,59,71

                self.cards.append(PirateShip(i, 3))  # 36,48,60,72
                self.cards.append(PirateShip(i, 3))  # 37,49,61,73
                self.cards.append(PirateShip(i, 3))  # 38,50,62,74
                self.cards.append(PirateShip(i, 3))  # 39,51,63,75

                self.cards.append(PirateShip(i, 4))  # 40,52,64,76
                self.cards.append(PirateShip(i, 4))  # 41,53,65,77

        else:
            raise RuntimeError("You cannot create another Deck")

    @staticmethod
    def get_instance():
        if not Deck.__instance__:
            Deck()
        return Deck.__instance__


class Game:
    def __init__(self, deck):
        self.deck = deck
        self.players = []
        self.current_player = None

    # Creates a list of players instances with given names
    def create_players(self, names, min_players, max_players):
        if len(names) < min_players or len(names) > max_players:
            raise RuntimeError

        for name in names:
            self.players.append(Player(name))

    # Returns random player
    def random_player(self):
        if not self.players:
            return None

        rand = random.randint(0, len(self.players) - 1)
        return self.players[rand]

    # Returns player to the left of the dealer
    def start(self):
        dealer_ind = -1
        for ind, player in enumerate(self.players):
            if player.dealer:
                dealer_ind = ind

        return self.players[dealer_ind - 1]

    # Returns player to right of current player
    def next(self):
        current_player_ind = -1
        for ind, player in enumerate(self.players):
            if player is self.current_player:
                current_player_ind = ind

        next_ind = current_player_ind + 1
        # wrap around
        if current_player_ind == (len(self.players) - 1):
            next_ind = 0

        return self.players[next_ind]

    # Returns player at pos (1-indexed)
    def choose_player(self, pos):
        if pos > len(self.players) or pos <= 0:
            return None
        return self.players[pos - 1]

    # Assign merchant ships at sea to appropriate winner at end of round
    def capture_merchant_ships(self):
        # Check every merchant ship floated
        for player in self.players:
            for ship in player.merchant_ships_at_sea:

                # Never attacked
                if ship not in player.merchant_pirates:
                    player.merchant_ships_captured.append(ship)
                    player.merchant_ships_at_sea.remove(ship)
                    continue

                # Admiral & Captain case
                last_card = player.merchant_pirates[ship][-1][1]
                if isinstance(last_card, Admiral) or isinstance(last_card, Captain):
                    last_player = player.merchant_pirates[ship][-1][0]
                    last_player.merchant_ships_captured.append(ship)
                    player.merchant_ships_at_sea.remove(ship)
                    del player.merchant_pirates[ship]
                    continue

                # Check pirates
                player_strength = {}

                for (attack_plyr, attack_card) in player.merchant_pirates[ship]:
                    if isinstance(attack_card, PirateShip):
                        if attack_plyr not in player_strength:
                            player_strength[attack_plyr] = attack_card.get_value()

                        elif attack_plyr in player_strength:
                            player_strength[attack_plyr] = player_strength[attack_plyr] + attack_card.get_value()

                highest_player = []
                max_score = max(player_strength.values())
                for plyr, strength in player_strength.items():
                    if strength == max_score:
                        highest_player.append(plyr)

                # No winner. Tie!
                if len(highest_player) != 1:
                    continue

                highest_player[0].merchant_ships_captured.append(ship)
                player.merchant_ships_at_sea.remove(ship)
                del player.merchant_pirates[ship]

    # List of all winner with highest score
    def show_winner(self):
        player_scores = {}
        for player in self.players:
            score = 0
            for captured in player.merchant_ships_captured:
                score += captured.get_value()

            player_scores[player] = score

        winners = []
        max_score = max(player_scores.values())
        if max_score == 0:
            return winners

        for plyr, scr in player_scores.items():
            if scr == max_score:
                winners.append((plyr, scr))

        return winners
