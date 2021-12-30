########## IMAN ALI ##########
########## 112204305 #############
########## imaali #############

require 'test/unit'
require 'test/unit/assertions'
require_relative "./loot.rb"

class LootDeckTest < Test::Unit::TestCase

  def test_insert_empty_dir
    deck = Deck.get_instance()
    assert_equal(78, deck.cards.length(), 'Deck does not contain 78 cards!')
  end

  def test_two_deck_error
    deck = Deck.get_instance()
    assert_raises RuntimeError do
        Deck.new()
    end
  end

  def test_one_admiral_present
    deck = Deck.get_instance()
    admiral = Admiral.get_instance()
    assert_true(deck.cards.include?(admiral), "Expected one admiral in the deck!")
  end

  def test_two_admiral_error
    deck = Deck.get_instance()
    assert_raises RuntimeError do
        Admiral.new()
    end
  end

  def test_num_merchants
    deck = Deck.get_instance()
    num_merchants = 0
    deck.cards.each do |card|
        if card.instance_of?(MerchantShip)
            num_merchants += 1
        end
    end
    assert_equal(25, num_merchants, "Deck does not contain 25 MerchantShip cards!")
  end

  def test_merchants_value
    deck = Deck.get_instance()
    num_twos = 0
    num_threes = 0
    num_fours = 0
    num_fives = 0
    num_sixes = 0
    num_sevens = 0
    num_eights = 0
    total = 0

    deck.cards.each do |card|
        if card.instance_of?(MerchantShip)
            if card.value == 2
                num_twos += 1
                total += 2
            elsif card.value == 3
                num_threes += 1
                total += 3
            elsif card.value == 4
                num_fours += 1
                total += 4
            elsif card.value == 5
                num_fives += 1
                total += 5
            elsif card.value == 6
                num_sixes += 1
                total += 6
            elsif card.value == 7
                num_sevens += 1
                total += 7
            elsif card.value == 8
                num_eights += 1
                total += 8
            end
          end
    end

    assert_equal(5, num_twos, "Deck does not contain 5 merchant cards of value 2!")
    assert_equal(6, num_threes, "Deck does not contain 6 merchant cards of value 3!")
    assert_equal(5, num_fours, "Deck does not contain 5 merchant cards of value 4!")
    assert_equal(5, num_fives, "Deck does not contain 5 merchant cards of value 5!")
    assert_equal(2, num_sixes, "Deck does not contain 2 merchant cards of value 6!")
    assert_equal(1, num_sevens, "Deck does not contain 1 merchant cards of value 7!")
    assert_equal(1, num_eights, "Deck does not contain 1 merchant cards of value 8!")
    assert_equal(100, total, "Total value of MerchantShips is not 100!")
  end

  def test_num_pirates
    deck = Deck.get_instance()
    num_pirates = 0
    deck.cards.each do |card|
        if card.instance_of?(PirateShip)
            num_pirates += 1
        end
    end
    assert_equal(48, num_pirates, "Deck does not contain 48 PirateShip cards!")
  end

  def test_num_captains
    deck = Deck.get_instance()
    num_captains = 0
    deck.cards.each do |card|
        if card.instance_of?(Captain)
            num_captains += 1
        end
    end
    assert_equal(4, num_captains, "Deck does not contain 4 Captain cards!")
  end

  def test_pirate_colors
    deck = Deck.get_instance()
    colors = []
    deck.cards.each do |card|
        if card.instance_of?(PirateShip)
            if not colors.include?(card.color)
                colors.append(card.color)
            end
        end
    end

    assert_equal(4, colors.length(), "Expected 4 fleets of PirateShip cards!")
    assert_true(colors.include?('blue'), "Expected blue fleet of PirateShips!")
    assert_true(colors.include?('green'), "Expected green fleet of PirateShips!")
    assert_true(colors.include?('purple'), "Expected purple fleet of PirateShips!")
    assert_true(colors.include?('gold'), "Expected gold fleet of PirateShips!")
  end

  def test_captain_colors
    deck = Deck.get_instance()
    colors = []
    deck.cards.each do |card|
        if card.instance_of?(Captain)
          if not colors.include?(card.color)
                colors.append(card.color)
            end
        end
    end

    assert_equal(4, colors.length(), "Expected 4 fleets of Captain cards!")
    assert_true(colors.include?('blue'), "Expected blue fleet Captain!")
    assert_true(colors.include?('green'), "Expected green fleet Captain!")
    assert_true(colors.include?('purple'), "Expected purple fleet Captain!")
    assert_true(colors.include?('gold'), "Expected gold fleet Captain!")
  end

  def test_pirates_values
    deck = Deck.get_instance()
    colors = {
        "blue" => [],
        "green" => [],
        "purple" => [],
        "gold" => []
    }

    deck.cards.each do |card|
        if card.instance_of?(PirateShip)
            colors[card.color].append(card)
        end
    end

    colors.each do |fleet, cards|
        ones = 0
        twos = 0
        threes = 0
        fours = 0
        cards.each do |pirate|
            if pirate.attack_value == 1
                ones += 1

            elsif pirate.attack_value == 2
                twos += 1

            elsif pirate.attack_value == 3
                threes += 1

            elsif pirate.attack_value == 4
                fours += 1
            end
        end

        assert_equal(2, ones, "Expected 2 ones of " + fleet + " pirate fleet")
        assert_equal(4, twos, "Expected 4 twos of " + fleet + " pirate fleet")
        assert_equal(4, threes, "Expected 4 threes of " + fleet + " pirate fleet")
        assert_equal(2, fours, "Expected 2 fours of " + fleet + " pirate fleet")
    end
  end

end
