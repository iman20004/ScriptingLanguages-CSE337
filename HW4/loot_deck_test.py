########## IMAN ALI ##########
########## 112204305 #############
########## imaali #############

import unittest
import loot


class TestLootDeck(unittest.TestCase):

    def test_num_cards(self):
        deck = loot.Deck.get_instance()
        self.assertEqual(78, len(deck.cards), "Deck does not contain 78 cards!")

    def test_two_deck_error(self):
        deck = loot.Deck.get_instance()
        with self.assertRaises(RuntimeError):
            loot.Deck()

    def test_one_admiral_present(self):
        deck = loot.Deck.get_instance()
        admiral = loot.Admiral.get_instance()
        self.assertIn(admiral, deck.cards, "Expected one admiral in the deck!")

    def test_two_admiral_error(self):
        deck = loot.Deck.get_instance()
        with self.assertRaises(RuntimeError):
            loot.Admiral()

    def test_num_merchants(self):
        deck = loot.Deck.get_instance()
        num_merchants = 0
        for card in deck.cards:
            if isinstance(card, loot.MerchantShip):
                num_merchants += 1

        self.assertEqual(25, num_merchants, "Deck does not contain 25 MerchantShip cards!")

    def test_merchants_value(self):
        deck = loot.Deck.get_instance()
        num_twos = 0
        num_threes = 0
        num_fours = 0
        num_fives = 0
        num_sixes = 0
        num_sevens = 0
        num_eights = 0
        total = 0

        for card in deck.cards:
            if isinstance(card, loot.MerchantShip):
                if card.value == 2:
                    num_twos += 1
                    total += 2

                if card.value == 3:
                    num_threes += 1
                    total += 3

                if card.value == 4:
                    num_fours += 1
                    total += 4

                if card.value == 5:
                    num_fives += 1
                    total += 5

                if card.value == 6:
                    num_sixes += 1
                    total += 6

                if card.value == 7:
                    num_sevens += 1
                    total += 7

                if card.value == 8:
                    num_eights += 1
                    total += 8

        self.assertEqual(5, num_twos, "Deck does not contain 5 merchant cards of value 2!")
        self.assertEqual(6, num_threes, "Deck does not contain 6 merchant cards of value 3!")
        self.assertEqual(5, num_fours, "Deck does not contain 5 merchant cards of value 4!")
        self.assertEqual(5, num_fives, "Deck does not contain 5 merchant cards of value 5!")
        self.assertEqual(2, num_sixes, "Deck does not contain 2 merchant cards of value 6!")
        self.assertEqual(1, num_sevens, "Deck does not contain 1 merchant cards of value 7!")
        self.assertEqual(1, num_eights, "Deck does not contain 1 merchant cards of value 8!")
        self.assertEqual(100, total, "Total value of MerchantShips is not 100!")

    def test_num_pirates(self):
        deck = loot.Deck.get_instance()
        num_pirates = 0
        for card in deck.cards:
            if isinstance(card, loot.PirateShip):
                num_pirates += 1

        self.assertEqual(48, num_pirates, "Deck does not contain 48 PirateShip cards!")

    def test_num_captains(self):
        deck = loot.Deck.get_instance()
        num_captains = 0
        for card in deck.cards:
            if isinstance(card, loot.Captain):
                num_captains += 1

        self.assertEqual(4, num_captains, "Deck does not contain 4 Captain cards!")

    def test_pirate_colors(self):
        deck = loot.Deck.get_instance()
        colors = []
        for card in deck.cards:
            if isinstance(card, loot.PirateShip):
                if card.color not in colors:
                    colors.append(card.color)

        self.assertEqual(4, len(colors), "Expected 4 fleets of PirateShip cards!")
        self.assertIn('blue', colors, "Expected blue fleet of PirateShips!")
        self.assertIn('green', colors, "Expected green fleet of PirateShips!")
        self.assertIn('purple', colors, "Expected purple fleet of PirateShips!")
        self.assertIn('gold', colors, "Expected gold fleet of PirateShips!")

    def test_captain_colors(self):
        deck = loot.Deck.get_instance()
        colors = []
        for card in deck.cards:
            if isinstance(card, loot.Captain):
                if card.color not in colors:
                    colors.append(card.color)

        self.assertEqual(4, len(colors), "Expected 4 fleets of Captain cards!")
        self.assertIn('blue', colors, "Expected blue fleet Captain!")
        self.assertIn('green', colors, "Expected green fleet Captain!")
        self.assertIn('purple', colors, "Expected purple fleet Captain!")
        self.assertIn('gold', colors, "Expected gold fleet Captain!")

    def test_pirates_values(self):
        deck = loot.Deck.get_instance()
        colors = {
            "blue": [],
            "green": [],
            "purple": [],
            "gold": []
        }

        for card in deck.cards:
            if isinstance(card, loot.PirateShip):
                colors[card.color].append(card)

        for fleet in colors:
            ones = 0
            twos = 0
            threes = 0
            fours = 0
            for pirate in colors[fleet]:
                if pirate.attack_value == 1:
                    ones += 1

                if pirate.attack_value == 2:
                    twos += 1

                if pirate.attack_value == 3:
                    threes += 1

                if pirate.attack_value == 4:
                    fours += 1

            self.assertEqual(2, ones, "Expected 2 ones of " + fleet + " pirate fleet")
            self.assertEqual(4, twos, "Expected 4 twos of " + fleet + " pirate fleet")
            self.assertEqual(4, threes, "Expected 4 threes of " + fleet + " pirate fleet")
            self.assertEqual(2, fours, "Expected 2 fours of " + fleet + " pirate fleet")