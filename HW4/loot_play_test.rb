########## IMAN ALI ##########
########## 112204305 #############
########## imaali #############

require 'test/unit'
require 'test/unit/assertions'
require_relative "./loot.rb"

class LootPlayTest < Test::Unit::TestCase

  def test_deal_six
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Joy", "Nan", "Sat"]
    game.create_players(playerNames, 2, 5)
    dealer = game.random_player()
    dealer.dealer = true
    game.current_player = dealer
    dealer.deal(game)
    game.players.each do |player|
      assert_equal(6, player.hand.length(), "Expected 6 cards in each players hand!")
    end
  end

  def test_start_with_left
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna", "Rabab"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true
    dealer.deal(game)
    first_player = game.start()
    assert_equal("Paul", first_player.name, "Expected game to start with player left of dealer")
  end

  def test_start_wrap_front
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna", "Rabab"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[0]
    dealer.dealer = true
    dealer.deal(game)
    first_player = game.start()
    assert_equal("Rabab", first_player.name, "Expected game to start with player left of dealer")
  end

  def test_start_wrap_end
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna", "Rabab"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[3]
    dealer.dealer = true
    dealer.deal(game)
    first_player = game.start()
    assert_equal("Amna", first_player.name, "Expected game to start with player left of dealer")
  end

  def test_proceed_clockwise
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna", "Rabab", "Q"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[2]
    dealer.dealer = true
    dealer.deal(game)
    first_player = game.start()
    game.current_player = first_player
    game.current_player = game.next()
    assert_equal("Amna", game.current_player.name, "Expected game to proceed in clockwise direction!")
    game.current_player = game.next()
    assert_equal("Rabab", game.current_player.name, "Expected game to proceed in clockwise direction!")
    game.current_player = game.next()
    assert_equal("Q", game.current_player.name, "Expected game to proceed in clockwise direction!")
    game.current_player = game.next()
    assert_equal("Paul", game.current_player.name, "Expected game to proceed in clockwise direction!")
    game.current_player = game.next()
    assert_equal("Iman", game.current_player.name, "Expected game to proceed in clockwise direction!")
    game.current_player = game.next()
    assert_equal("Amna", game.current_player.name, "Expected game to proceed in clockwise direction!")
  end

  def test_invalid_max_players
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna", "Rabab", "Q", "Joo"]
    assert_raises RuntimeError do
        game.create_players(playerNames, 2, 5)
    end
  end

  def test_invalid_min_players
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul"]
    assert_raises RuntimeError do
        game.create_players(playerNames, 2, 5)
    end
  end

  def test_admiral_two
    deck = Deck.get_instance()

    assert_raises RuntimeError do
        Admiral.new()
    end
  end

  def test_draw_no_card
    deck = Deck.get_instance()
    game = Game.new(deck)
    game.deck.cards = []
    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)

    assert_raises RuntimeError do
        game.players[0].draw_card(game)
    end
  end

  def test_admiral_not_defense
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_true(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed")
    third_plyr = game.next()
    game.current_player = third_plyr
    # Amna plays admiral but expect unsuccesful try
    assert_false(third_plyr.play_admiral(third_plyr.hand[5], merchantShip), "Cant use admiral except for defense!")
  end

  def test_admiral_wins_captain
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_true(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed. First attack any color allowed!")
    third_plyr = game.next()
    game.current_player = third_plyr
    # Amna plays captain
    assert_true(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player), "Expected play to succeed")
    fourth_plyr = game.next()
    game.current_player = fourth_plyr
    # Paul defends with admiral
    assert_true(fourth_plyr.play_admiral(fourth_plyr.hand[0], merchantShip), "Expected play to succeed. Admiral can be played after captain!")

    # Paul should win admiral last card
    game.capture_merchant_ships()
    assert_true(fourth_plyr.merchant_ships_captured.include?(merchantShip), "Expected admiral to win over captain since its last!")
  end

  def test_captain_wins_admiral
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_true(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed. First attack any color allowed!")
    third_plyr = game.next()
    game.current_player = third_plyr
    # Amna plays captain
    assert_true(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player), "Expected play to succeed")
    fourth_plyr = game.next()
    game.current_player = fourth_plyr
    # Paul defends with admiral
    assert_true(fourth_plyr.play_admiral(fourth_plyr.hand[0], merchantShip), "Expected play to succeed")
    fifth_plyr = game.next()
    game.current_player = fifth_plyr
    # Iman plays captain
    assert_true(fifth_plyr.play_captain(fifth_plyr.hand[0], merchantShip, first_player), "Expected play to succeed. Can play captain after admiral!")

    # Imans captain should win over admiral
    game.capture_merchant_ships()
    assert_true(fifth_plyr.merchant_ships_captured.include?(merchantShip), "Expected captain to win over admiral since its last!")
  end


  def test_multiple_captains
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_true(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed")
    third_plyr = game.next()
    game.current_player = third_plyr
    # Amna plays pirate 3 green
    assert_true(third_plyr.play_pirate(third_plyr.hand[3], merchantShip, first_player), "Expected play to succeed")
    fourth_plyr = game.next()
    game.current_player = fourth_plyr
    # Paul defends with admiral
    assert_true(fourth_plyr.play_admiral(fourth_plyr.hand[0], merchantShip), "Expected play to succeed")
    fifth_plyr = game.next()
    game.current_player = fifth_plyr
    # Iman plays captain purple
    assert_true(fifth_plyr.play_captain(fifth_plyr.hand[0], merchantShip, first_player), "Expected play to succeed")
    sixth_plyr = game.next()
    game.current_player = sixth_plyr
    # Amna plays captain green
    assert_true(sixth_plyr.play_captain(sixth_plyr.hand[0], merchantShip, first_player), "Expected play to succeed")

    # Amnas captain should win since it was last
    game.capture_merchant_ships()
    assert_true(sixth_plyr.merchant_ships_captured.include?(merchantShip), "Expected Amna's captain to win since its last!")
  end

  def test_float_not_merchant
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_false(first_player.float_merchant(first_player.hand[5]),
                     "Expected play to fail! Cant float card thats not merchant")
  end

  def test_float_merchant_not_in_hand
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman tried to float a merchant not in hand
    merchant = game.deck.cards[19]
    assert_false(second_plyr.float_merchant(merchant), "Expected play to fail since merchant is not in hand!")
  end

  def test_captain_not_in_hand
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman tried to float a merchant not in hand
    cap = game.deck.cards[27]
    assert_false(second_plyr.play_captain(cap, merchantShip, first_player), "Expected play to fail since captain is not in hand!")
  end

  def test_admiral_not_in_hand
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_true(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player),
                    "Expected play to succeed")
    third_plyr = game.next()
    game.current_player = third_plyr
    # Amna plays captain
    assert_true(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player),
                    "Expected play to succeed")
    fourth_plyr = game.next()
    game.current_player = fourth_plyr
    # Paul defends with admiral
    admiral = game.deck.cards[0]
    assert_false(fourth_plyr.play_admiral(admiral, merchantShip), "Expected play to fail since admiral not in hand!")
  end

  def test_pirate_not_in_hand
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman tries to play pirate not in hand
    pirate = game.deck.cards[66]
    assert_false(second_plyr.play_pirate(pirate, merchantShip, first_player), "Expected play to fail since pirate is not in hand!")
  end

  def test_play_other_players_color
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_true(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed. First attack any color allowed!")
    third_plyr = game.next()
    game.current_player = third_plyr
    # Amna tries to play purple pirate when other player already attacked with purple
    assert_false(third_plyr.play_pirate(third_plyr.hand[5], merchantShip, first_player),
                     "Expected play to fail since color used to attack previously by other player!")
    assert_false(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player),
                     "Expected play to fail since color used to attack previously by other player!")
  end


  def test_play_not_admiral
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_true(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player),
                    "Expected play to succeed. First attack any color allowed!")
    third_plyr = game.next()
    game.current_player = third_plyr
    assert_false(third_plyr.play_admiral(third_plyr.hand[3], merchantShip),
                    "Expected play to fail. Playing admiral on not admiral card!")
  end

  def test_play_admiral_first
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    second_plyr.float_merchant(second_plyr.hand[2])
    third_plyr = game.next()
    game.current_player = third_plyr
    assert_true(third_plyr.play_admiral(third_plyr.hand[0], merchantShip),
                    "Expected to succeed! Can play admiral if no one else attacked!")
  end

  def test_pirate_diff_color_previously
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_true(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player),
                    "Expected play to succeed. First attack any color allowed!")
    third_plyr = game.next()
    game.current_player = third_plyr
    third_plyr.play_pirate(third_plyr.hand[3], merchantShip, first_player)
    second_plyr = game.next()
    game.current_player = second_plyr
    assert_false(second_plyr.play_pirate(second_plyr.hand[4], merchantShip, first_player),
                     "Expected play to fail since previously attacked same ship with different color!")
  end

  def test_play_pirate_not_pirate
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_false(second_plyr.play_pirate(second_plyr.hand[0], merchantShip, first_player),
                     "Expected play to fail since play pirate on not pirate card!")
  end

  def test_play_against_non_merchant
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_false(second_plyr.play_pirate(second_plyr.hand[5], first_player.hand[4], first_player),
                     "Expected play to fail since play pirate on not merchant card!")
    assert_false(second_plyr.play_captain(second_plyr.hand[0], first_player.hand[4], first_player),
                     "Expected play to fail since play captain on not merchant card!")
  end

  def test_captain_diff_color_previously
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_true(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player),
                    "Expected play to succeed. First attack any color allowed!")
    third_plyr = game.next()
    game.current_player = third_plyr
    # Amna plays captain
    assert_true(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player),
                    "Expected play to succeed")
    fourth_plyr = game.next()
    game.current_player = fourth_plyr
    # Paul defends with admiral
    assert_true(fourth_plyr.play_admiral(fourth_plyr.hand[0], merchantShip), "Expected play to succeed")
    fifth_plyr = game.next()
    game.current_player = fifth_plyr
    # Iman tries to play blue captain
    assert_false(fifth_plyr.play_captain(fifth_plyr.hand[0], merchantShip, first_player),
                     "Expected play to fail since previously attacked same ship with different color!")
  end

  def test_pirate_after_captain
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays captain
    assert_true(second_plyr.play_captain(second_plyr.hand[0], merchantShip, first_player), "Expected play to succeed!")
    third_plyr = game.next()
    game.current_player = third_plyr
    # Amna plays pirate
    assert_false(third_plyr.play_pirate(third_plyr.hand[5], merchantShip, first_player),
                    "Expected play to fail! Cant play pirate after captain!")
  end

  def test_pirate_after_admiral
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_true(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player),
                    "Expected play to succeed. First attack any color allowed!")
    third_plyr = game.next()
    game.current_player = third_plyr
    # Amna plays captain
    assert_true(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player),
                    "Expected play to succeed")
    fourth_plyr = game.next()
    game.current_player = fourth_plyr
    # Paul defends with admiral
    assert_true(fourth_plyr.play_admiral(fourth_plyr.hand[0], merchantShip), "Expected play to succeed")
    fifth_plyr = game.next()
    game.current_player = fifth_plyr
    # Iman tries to play pirate
    assert_false(fifth_plyr.play_pirate(fifth_plyr.hand[4], merchantShip, first_player),
                     "Expected play to fail! Cant play pirate after admiral!")

  end

  def test_unattacked_merchant
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")

    game.capture_merchant_ships()
    assert_true(first_player.merchant_ships_captured.include?(merchantShip), "Unattacked merchant expected to be won by player who floated it!")
  end

  def test_captain_wins_pirate
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    assert_true(first_player.merchant_ships_at_sea.include?(merchantShip), "Expected floating ship to be in merchant_ships_at_sea")
    assert_false(first_player.hand.include?(merchantShip), "Expected merchant ship to be removed from hand after floating!")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_true(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed. First attack any color allowed!")
    third_plyr = game.next()
    game.current_player = third_plyr
    # Amna plays captain
    assert_true(third_plyr.play_captain(third_plyr.hand[0], merchantShip, first_player), "Expected play to succeed")

    # Amnas captain should win over pirate
    game.capture_merchant_ships()
    assert_true(third_plyr.merchant_ships_captured.include?(merchantShip), "Expected captain to win over pirate!")
    assert_false(first_player.merchant_ships_at_sea.include?(merchantShip), "Expected merchant to be removed from player who floated at sea!")
  end

  def test_playcaptain_not_captain
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    # Iman plays pirate 2 purple
    assert_true(second_plyr.play_pirate(second_plyr.hand[5], merchantShip, first_player), "Expected play to succeed. First attack any color allowed!")
    third_plyr = game.next()
    game.current_player = third_plyr
    # Amna plays captain
    assert_false(third_plyr.play_captain(third_plyr.hand[5], merchantShip, first_player),
                     "Expected play to fail since playing captain on a pirate")
  end

  def test_draw_card
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.hand.include?(drawn), "Expected to see drawn card in hand!")
    assert_equal(7, first_player.hand.length(), "Expected players number of cards in hand to be incremented")
    assert_false(game.deck.cards.include?(drawn), "Expected to see drawn card to be removed from deck!")
    assert_equal(77, game.deck.cards.length(), "Expected num cards in deck to be decremented")
  end

  def test_play_pirate_unfloated_merchant
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    unfloated = game.deck.cards[13]
    assert_false(second_plyr.play_pirate(second_plyr.hand[5], unfloated, first_player), "Expected to fail since merchant unfloated!")
  end

  def test_play_captain_unfloated_merchant
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.float_merchant(merchantShip), "Expected play to succeed")
    second_plyr = game.next()
    game.current_player = second_plyr
    unfloated = game.deck.cards[13]
    assert_false(second_plyr.play_captain(second_plyr.hand[0], unfloated, first_player), "Expected to fail since merchant unfloated!")
  end

  def test_random_player_none
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    assert_nil(game.random_player(), "Expected None since no players")
  end

  def test_choose_player
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna", "Rabab"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

    assert_equal("Paul", game.choose_player(1).name, "Expected first player!")
    assert_equal("Iman", game.choose_player(2).name, "Expected second player!")
    assert_equal("Amna", game.choose_player(3).name, "Expected third player!")
    assert_equal("Rabab", game.choose_player(4).name, "Expected fourth player!")
    assert_nil(game.choose_player(0), "Expected None since no player at 0 position!")
    assert_nil(game.choose_player(5), "Expected None since no player at this position!")
  end

  def test_show_winners
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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

    assert_equal([], game.show_winner(), "Expected no winner!")

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

    assert_equal([[second_plyr, 2], [third_plyr, 2]], game.show_winner(), "Expected multiple winners!")
  end

  def test_tied_attacks
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_equal([], first_player.merchant_ships_captured, "Expected merchant to remain in game until winner!")
    assert_equal([], second_plyr.merchant_ships_captured, "Expected merchant to remain in game until winner!")
    assert_equal([], third_plyr.merchant_ships_captured, "Expected merchant to remain in game until winner!")
    assert_true(first_player.merchant_ships_at_sea.include?(merchantShip), "Expected merchant to remain in game until winner!")
  end

  def test_multiple_pirates
    Deck.instance = nil
    deck = Deck.get_instance()
    game = Game.new(deck)

    playerNames = ["Paul", "Iman", "Amna"]
    game.create_players(playerNames, 2, 5)
    dealer = game.players[1]
    dealer.dealer = true

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
    assert_true(first_player.merchant_ships_at_sea.include?(merchantShip),
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
    assert_true(second_plyr.merchant_ships_captured.include?(merchantShip),
                  "Expected Iman to win the game cause greater strength!")
    assert_false(first_player.merchant_ships_at_sea.include?(merchantShip),
                  "Expected Iman to win the game cause greater strength!")
  end


end
