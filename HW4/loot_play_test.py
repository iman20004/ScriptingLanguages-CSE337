########## IMAN ALI ##########
########## 112204305 #############
########## imaali #############

import unittest
import loot

class TestLootPlay(unittest.TestCase):

    def test_deal_six(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Joy", "Nan", "Sat"]
        game.create_players(playerNames, 2, 5)
        dealer = game.random_player()
        dealer.dealer = True
        game.current_player = dealer
        dealer.deal(game)
        for player in game.players:
            self.assertEqual(6, len(player.hand), "Expected 6 cards in each players hand!")

    def test_start_with_left(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna", "Rabab"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True
        dealer.deal(game)
        first_player = game.start()
        self.assertEqual("Paul", first_player.name, "Expected game to start with player left of dealer")

    def test_start_wrap_front(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna", "Rabab"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[0]
        dealer.dealer = True
        dealer.deal(game)
        first_player = game.start()
        self.assertEqual("Rabab", first_player.name, "Expected game to start with player left of dealer")

    def test_start_wrap_end(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna", "Rabab"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[3]
        dealer.dealer = True
        dealer.deal(game)
        first_player = game.start()
        self.assertEqual("Amna", first_player.name, "Expected game to start with player left of dealer")


    def test_proceed_clockwise(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna", "Rabab", "Q"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[2]
        dealer.dealer = True
        dealer.deal(game)
        first_player = game.start()
        game.current_player = first_player
        game.current_player = game.next()
        self.assertEqual("Amna", game.current_player.name, "Expected game to proceed in clockwise direction!")
        game.current_player = game.next()
        self.assertEqual("Rabab", game.current_player.name, "Expected game to proceed in clockwise direction!")
        game.current_player = game.next()
        self.assertEqual("Q", game.current_player.name, "Expected game to proceed in clockwise direction!")
        game.current_player = game.next()
        self.assertEqual("Paul", game.current_player.name, "Expected game to proceed in clockwise direction!")
        game.current_player = game.next()
        self.assertEqual("Iman", game.current_player.name, "Expected game to proceed in clockwise direction!")
        game.current_player = game.next()
        self.assertEqual("Amna", game.current_player.name, "Expected game to proceed in clockwise direction!")

    def test_invalid_max_players(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna", "Rabab", "Q", "Joo"]
        with self.assertRaises(RuntimeError):
            game.create_players(playerNames, 2, 5)

    def test_invalid_min_players(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul"]
        with self.assertRaises(RuntimeError):
            game.create_players(playerNames, 2, 5)

    def test_admiral_two(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()

        with self.assertRaises(RuntimeError):
            loot.Admiral()

    def test_draw_no_card(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)
        game.deck.cards = []
        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)

        with self.assertRaises(Exception):
            game.players[0].draw_card(game)

    def test_admiral_not_defense(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets pirate 1 purple, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[55])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 3 gold, pirate 4 gold, admiral
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[74])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[0])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertTrue(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed")
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays admiral but expect unsuccesful try
        self.assertFalse(third_plyr.play_admiral(third_plyr.hand[5], merchantShip), "Cant use admiral except for defense!")


    def test_admiral_wins_captain(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 3 gold, pirate 4 gold, pirate 1 purple
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[74])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[55])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertTrue(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed. First attack any color allowed!")
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays captain
        self.assertTrue(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player), "Expected play to succeed")
        fourth_plyr = game.next()
        game.current_player = fourth_plyr
        # Paul defends with admiral
        self.assertTrue(fourth_plyr.play_admiral(fourth_plyr.hand[0], merchantShip), "Expected play to succeed. Admiral can be played after captain!")

        # Paul should win admiral last card
        game.capture_merchant_ships()
        self.assertIn(merchantShip, fourth_plyr.merchant_ships_captured, "Expected admiral to win over captain since its last!")


    def test_captain_wins_admiral(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 3 gold, pirate 4 gold, pirate 1 purple
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[74])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[55])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertTrue(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed. First attack any color allowed!")
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays captain
        self.assertTrue(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player), "Expected play to succeed")
        fourth_plyr = game.next()
        game.current_player = fourth_plyr
        # Paul defends with admiral
        self.assertTrue(fourth_plyr.play_admiral(fourth_plyr.hand[0], merchantShip), "Expected play to succeed")
        fifth_plyr = game.next()
        game.current_player = fifth_plyr
        # Iman plays captain
        self.assertTrue(fifth_plyr.play_captain(fifth_plyr.hand[0], merchantShip, first_player), "Expected play to succeed. Can play captain after admiral!")

        # Imans captain should win over admiral
        game.capture_merchant_ships()
        self.assertIn(merchantShip, fifth_plyr.merchant_ships_captured, "Expected captain to win over admiral since its last!")

    def test_multiple_captains(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 3 green, pirate 4 gold, pirate 1 purple
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[50])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[55])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertTrue(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed")
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays pirate 3 green
        self.assertTrue(third_plyr.play_pirate(third_plyr.hand[3], merchantShip, first_player), "Expected play to succeed")
        fourth_plyr = game.next()
        game.current_player = fourth_plyr
        # Paul defends with admiral
        self.assertTrue(fourth_plyr.play_admiral(fourth_plyr.hand[0], merchantShip), "Expected play to succeed")
        fifth_plyr = game.next()
        game.current_player = fifth_plyr
        # Iman plays captain purple
        self.assertTrue(fifth_plyr.play_captain(fifth_plyr.hand[0], merchantShip, first_player), "Expected play to succeed")
        sixth_plyr = game.next()
        game.current_player = sixth_plyr
        # Amna plays captain green
        self.assertTrue(sixth_plyr.play_captain(sixth_plyr.hand[0], merchantShip, first_player), "Expected play to succeed")

        # Amnas captain should win since it was last
        game.capture_merchant_ships()
        self.assertIn(merchantShip, sixth_plyr.merchant_ships_captured, "Expected Amna's captain to win since its last!")

    def test_float_not_merchant(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        self.assertFalse(first_player.float_merchant(first_player.hand[5]),
                         "Expected play to fail! Cant float card thats not merchant")

    def test_float_merchant_not_in_hand(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman tried to float a merchant not in hand
        merchant = game.deck.cards[19]
        self.assertFalse(second_plyr.float_merchant(merchant), "Expected play to fail since merchant is not in hand!")

    def test_captain_not_in_hand(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman tried to float a merchant not in hand
        cap = game.deck.cards[27]
        self.assertFalse(second_plyr.play_captain(cap, merchantShip, first_player), "Expected play to fail since captain is not in hand!")

    def test_admiral_not_in_hand(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets merchant 8, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[23])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 3 gold, pirate 4 gold, pirate 1 purple
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[74])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[55])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertTrue(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player),
                        "Expected play to succeed")
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays captain
        self.assertTrue(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player),
                        "Expected play to succeed")
        fourth_plyr = game.next()
        game.current_player = fourth_plyr
        # Paul defends with admiral
        admiral = game.deck.cards[0]
        self.assertFalse(fourth_plyr.play_admiral(admiral, merchantShip), "Expected play to fail since admiral not in hand!")

    def test_pirate_not_in_hand(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman tries to play pirate not in hand
        pirate = game.deck.cards[66]
        self.assertFalse(second_plyr.play_pirate(pirate, merchantShip, first_player), "Expected play to fail since pirate is not in hand!")

    def test_play_other_players_color(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain green, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[27])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain purple, merchant 2, merchant 4, pirate 3 gold, pirate 4 gold, pirate 1 purple
        game.players[2].hand.append(game.deck.cards[28])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[74])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[55])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertTrue(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed. First attack any color allowed!")
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna tries to play purple pirate when other player already attacked with purple
        self.assertFalse(third_plyr.play_pirate(third_plyr.hand[5], merchantShip, first_player),
                         "Expected play to fail since color used to attack previously by other player!")
        self.assertFalse(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player),
                         "Expected play to fail since color used to attack previously by other player!")


    def test_play_not_admiral(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain green, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[27])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertTrue(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player),
                        "Expected play to succeed. First attack any color allowed!")
        third_plyr = game.next()
        game.current_player = third_plyr
        self.assertFalse(third_plyr.play_admiral(third_plyr.hand[3], merchantShip),
                        "Expected play to fail. Playing admiral on not admiral card!")


    def test_play_admiral_first(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain green, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[27])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        second_plyr.float_merchant(second_plyr.hand[2])
        third_plyr = game.next()
        game.current_player = third_plyr
        self.assertTrue(third_plyr.play_admiral(third_plyr.hand[0], merchantShip),
                        "Expected to succeed! Can play admiral if no one else attacked!")


    def test_pirate_diff_color_previously(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, pirate 4 gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[77])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[53])
        game.players[1].hand.append(game.deck.cards[58])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertTrue(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player),
                        "Expected play to succeed. First attack any color allowed!")
        third_plyr = game.next()
        game.current_player = third_plyr
        third_plyr.play_pirate(third_plyr.hand[3], merchantShip, first_player)
        second_plyr = game.next()
        game.current_player = second_plyr
        self.assertFalse(second_plyr.play_pirate(second_plyr.hand[4], merchantShip, first_player),
                         "Expected play to fail since previously attacked same ship with different color!")

    def test_play_pirate_not_pirate(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, pirate 4 gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[77])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[53])
        game.players[1].hand.append(game.deck.cards[58])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertFalse(second_plyr.play_pirate(second_plyr.hand[0], merchantShip, first_player),
                         "Expected play to fail since play pirate on not pirate card!")

    def test_play_against_non_merchant(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, pirate 4 gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[77])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[53])
        game.players[1].hand.append(game.deck.cards[58])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertFalse(second_plyr.play_pirate(second_plyr.hand[5], first_player.hand[4], first_player),
                         "Expected play to fail since play pirate on not merchant card!")
        self.assertFalse(second_plyr.play_captain(second_plyr.hand[0], first_player.hand[4], first_player),
                         "Expected play to fail since play captain on not merchant card!")

    def test_captain_diff_color_previously(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain blue, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[26])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 3 gold, pirate 4 gold, pirate 1 purple
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[74])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[55])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertTrue(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player),
                        "Expected play to succeed. First attack any color allowed!")
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays captain
        self.assertTrue(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player),
                        "Expected play to succeed")
        fourth_plyr = game.next()
        game.current_player = fourth_plyr
        # Paul defends with admiral
        self.assertTrue(fourth_plyr.play_admiral(fourth_plyr.hand[0], merchantShip), "Expected play to succeed")
        fifth_plyr = game.next()
        game.current_player = fifth_plyr
        # Iman tries to play blue captain
        self.assertFalse(fifth_plyr.play_captain(fifth_plyr.hand[0], merchantShip, first_player),
                         "Expected play to fail since previously attacked same ship with different color!")

    def test_pirate_after_captain(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain blue, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[26])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 3 gold, pirate 4 gold, pirate 1 purple
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[74])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[55])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays captain
        self.assertTrue(second_plyr.play_captain(second_plyr.hand[0], merchantShip, first_player), "Expected play to succeed!")
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays pirate
        self.assertFalse(third_plyr.play_pirate(third_plyr.hand[5], merchantShip, first_player),
                        "Expected play to fail! Cant play pirate after captain!")


    def test_pirate_after_admiral(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain blue, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[26])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 3 gold, pirate 4 gold, pirate 1 purple
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[74])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[55])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertTrue(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player),
                        "Expected play to succeed. First attack any color allowed!")
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays captain
        self.assertTrue(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player),
                        "Expected play to succeed")
        fourth_plyr = game.next()
        game.current_player = fourth_plyr
        # Paul defends with admiral
        self.assertTrue(fourth_plyr.play_admiral(fourth_plyr.hand[0], merchantShip), "Expected play to succeed")
        fifth_plyr = game.next()
        game.current_player = fifth_plyr
        # Iman tries to play pirate
        self.assertFalse(fifth_plyr.play_pirate(fifth_plyr.hand[4], merchantShip, first_player),
                         "Expected play to fail! Cant play pirate after admiral!")


    def test_unattacked_merchant(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain blue, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[26])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 3 gold, pirate 4 gold, pirate 1 purple
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[74])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[55])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")

        game.capture_merchant_ships()
        self.assertIn(merchantShip, first_player.merchant_ships_captured, "Unattacked merchant expected to be won by player who floated it!")

    def test_captain_wins_pirate(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 3 gold, pirate 4 gold, pirate 1 purple
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[74])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[55])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        self.assertIn(merchantShip, first_player.merchant_ships_at_sea, "Expected floating ship to be in merchant_ships_at_sea")
        self.assertNotIn(merchantShip, first_player.hand, "Expected merchant ship to be removed from hand after floating!")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertTrue(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed. First attack any color allowed!")
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays captain
        self.assertTrue(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player), "Expected play to succeed")

        # Amnas captain should win over pirate
        game.capture_merchant_ships()
        self.assertIn(merchantShip, third_plyr.merchant_ships_captured, "Expected captain to win over pirate!")
        self.assertNotIn(merchantShip, first_player.merchant_ships_at_sea, "Expected merchant to be removed from player who floated at sea!")

    def test_playcaptain_not_captain(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 3 gold, pirate 4 gold, pirate 1 purple
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[74])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[55])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        self.assertTrue(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed. First attack any color allowed!")
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays captain
        self.assertFalse(third_plyr.play_captain(third_plyr.hand[5], merchantShip, first_player),
                         "Expected play to fail since playing captain on a pirate")


    def test_draw_card(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul draws card
        drawn = game.deck.cards[77]
        first_player.draw_card(game)
        self.assertIn(drawn, first_player.hand, "Expected to see drawn card in hand!")
        self.assertEqual(7, len(first_player.hand), "Expected players number of cards in hand to be incremented")
        self.assertNotIn(drawn, game.deck.cards, "Expected to see drawn card to be removed from deck!")
        self.assertEqual(77, len(game.deck.cards), "Expected num cards in deck to be decremented")

    def test_play_pirate_unfloated_merchant(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])

        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        unfloated = game.deck.cards[13]
        self.assertFalse(second_plyr.play_pirate(second_plyr.hand[5], unfloated, first_player), "Expected to fail since merchant unfloated!")

    def test_play_captain_unfloated_merchant(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])

        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        self.assertTrue(first_player.float_merchant(merchantShip), "Expected play to succeed")
        second_plyr = game.next()
        game.current_player = second_plyr
        unfloated = game.deck.cards[13]
        self.assertFalse(second_plyr.play_captain(second_plyr.hand[0], unfloated, first_player), "Expected to fail since merchant unfloated!")

    def test_random_player_none(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        self.assertEqual(None, game.random_player(), "Expected None since no players")


    def test_choose_player(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna", "Rabab"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        self.assertEqual("Paul", game.choose_player(1).name, "Expected first player!")
        self.assertEqual("Iman", game.choose_player(2).name, "Expected second player!")
        self.assertEqual("Amna", game.choose_player(3).name, "Expected third player!")
        self.assertEqual("Rabab", game.choose_player(4).name, "Expected fourth player!")
        self.assertEqual(None, game.choose_player(0), "Expected None since no player at 0 position!")
        self.assertEqual(None, game.choose_player(5), "Expected None since no player at this position!")

    def test_show_winners(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 2, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[1])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 3, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[4])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 3 gold, pirate 4 gold, pirate 1 purple
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[74])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[55])

        self.assertEqual([], game.show_winner(), "Expected no winner!")

        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        first_player.float_merchant(merchantShip)
        second_plyr = game.next()
        game.current_player = second_plyr
        second_plyr.play_captain(second_plyr.hand[0], merchantShip, first_player)
        third_plyr = game.next()
        game.current_player = third_plyr
        third_plyr.float_merchant(third_plyr.hand[1])
        game.capture_merchant_ships()

        self.assertEqual([(second_plyr, 2), (third_plyr, 2)], game.show_winner(), "Expected multiple winners!")


    def test_tied_attacks(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, merchant 7, pirate 4 green, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[22])
        game.players[1].hand.append(game.deck.cards[52])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 3 gold, pirate 4 gold, pirate 1 purple
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[69])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[55])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        first_player.float_merchant(merchantShip)
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player)
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays pirate 2 gold
        third_plyr.play_pirate(third_plyr.hand[3], merchantShip, first_player)
        game.capture_merchant_ships()
        self.assertEqual([], first_player.merchant_ships_captured, "Expected merchant to remain in game until winner!")
        self.assertEqual([], second_plyr.merchant_ships_captured, "Expected merchant to remain in game until winner!")
        self.assertEqual([], third_plyr.merchant_ships_captured, "Expected merchant to remain in game until winner!")
        self.assertIn(merchantShip, first_player.merchant_ships_at_sea, "Expected merchant to remain in game until winner!")

    def test_multiple_pirates(self):
        loot.Deck.__instance__ = None
        deck = loot.Deck.get_instance()
        game = loot.Game(deck)

        playerNames = ["Paul", "Iman", "Amna"]
        game.create_players(playerNames, 2, 5)
        dealer = game.players[1]
        dealer.dealer = True

        # Deal first six cards to all players
        # Paul gets admiral, merchant 5, merchant 3, captain gold, pirate 2 blue, pirate 3 blue,
        game.players[0].hand.append(game.deck.cards[0])
        game.players[0].hand.append(game.deck.cards[3])
        game.players[0].hand.append(game.deck.cards[4])
        game.players[0].hand.append(game.deck.cards[29])
        game.players[0].hand.append(game.deck.cards[32])
        game.players[0].hand.append(game.deck.cards[36])
        # Iman gets captain purple, merchant 2, merchant 5, pirate 3 purple, pirate 4 purple, pirate 2 purple
        game.players[1].hand.append(game.deck.cards[28])
        game.players[1].hand.append(game.deck.cards[1])
        game.players[1].hand.append(game.deck.cards[7])
        game.players[1].hand.append(game.deck.cards[61])
        game.players[1].hand.append(game.deck.cards[65])
        game.players[1].hand.append(game.deck.cards[58])
        # Amna gets captain green, merchant 2, merchant 4, pirate 2 gold, pirate 4 gold, pirate 1 gold
        game.players[2].hand.append(game.deck.cards[27])
        game.players[2].hand.append(game.deck.cards[9])
        game.players[2].hand.append(game.deck.cards[2])
        game.players[2].hand.append(game.deck.cards[69])
        game.players[2].hand.append(game.deck.cards[77])
        game.players[2].hand.append(game.deck.cards[66])

        # First turn is Paul
        first_player = game.start()
        game.current_player = first_player
        # Paul plays his merchant 3
        merchantShip = first_player.hand[2]
        first_player.float_merchant(merchantShip)
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 2 purple
        second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player)
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays pirate 2 gold
        third_plyr.play_pirate(third_plyr.hand[3], merchantShip, first_player)
        first_player = game.next()
        game.current_player = first_player
        # Paul plays
        first_player.play_pirate(first_player.hand[4], merchantShip, first_player)
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 4 purple
        second_plyr.play_pirate(second_plyr.hand[4], merchantShip, first_player)
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays pirate 4 gold
        third_plyr.play_pirate(third_plyr.hand[3], merchantShip, first_player)
        game.capture_merchant_ships()
        self.assertIn(merchantShip, first_player.merchant_ships_at_sea,
                      "Expected merchant to remain in game until winner!")

        first_player = game.next()
        game.current_player = first_player
        # Paul plays
        first_player.play_pirate(first_player.hand[3], merchantShip, first_player)
        second_plyr = game.next()
        game.current_player = second_plyr
        # Iman plays pirate 3 purple
        second_plyr.play_pirate(second_plyr.hand[3], merchantShip, first_player)
        third_plyr = game.next()
        game.current_player = third_plyr
        # Amna plays pirate 1 gold
        third_plyr.play_pirate(third_plyr.hand[3], merchantShip, first_player)
        game.capture_merchant_ships()
        self.assertIn(merchantShip, second_plyr.merchant_ships_captured,
                      "Expected Iman to win the game cause greater strength!")
        self.assertNotIn(merchantShip, first_player.merchant_ships_at_sea,
                      "Expected Iman to win the game cause greater strength!")