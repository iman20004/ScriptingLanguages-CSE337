########## IMAN ALI ##########
########## 112204305 #############
########## imaali #############

$pirateColors = [:blue, :green, :purple, :gold]
$maxPlayersAllowed = 5
$minPlayersAllowed = 2
$playerNames = ["Joy", "Nan", "Sat"]

class MerchantShip
  def initialize(value)
    @value = value
  end
  attr_reader :value
end

class PirateShip
  def initialize(color, attack_value)
    @color = color
    @attack_value = attack_value
  end
  attr_reader :color, :attack_value
end

class Captain
  def initialize(color)
    @color = color
  end
  attr_reader :color
end

class Admiral
  @@instance = nil

  def initialize
    if @@instance.nil?
      return self
    else
      raise RuntimeError
    end
  end

  def Admiral.get_instance
    if @@instance.nil?
      @@instance = Admiral.new()
    end
    return @@instance
  end
end

class Player
  def initialize(name)
    @name = name
    @merchant_ships_at_sea = []
    @merchant_ships_captured = []
    @hand = []
    @merchant_pirates = {}
    @dealer = false
  end

  attr_accessor :name, :merchant_ships_at_sea, :merchant_ships_captured, :hand, :merchant_pirates, :dealer


  def deal(game_state)
    @dealer = true
    game_state.deck.cards.shuffle!()
    card = 0
    (1..6).each do
      game_state.players.each do |player|
        current = game_state.deck.cards[card]
        player.hand.append(current)
        game_state.deck.cards.delete(current)
        card += 1
      end
    end
  end

  def draw_card(game)
    if game.deck.cards.length() > 0
      card = game.deck.cards.pop
      @hand.append(card)
    else
        raise RuntimeError
    end
  end

  def float_merchant(card)
    if not card.instance_of?(MerchantShip)
      return false
    end

    if not @hand.include?(card)
      return false
    end

    @hand.delete(card)
    @merchant_ships_at_sea.append(card)
    return true
  end


  def play_pirate(pirate_card, merchant_card, pl)
    if not @hand.include?(pirate_card)
      return false
    end

    if not merchant_card.instance_of?(MerchantShip)
        return false
    end

    if not pl.merchant_ships_at_sea.include?(merchant_card)
      return false
    end

    if not pirate_card.instance_of?(PirateShip)
      return false
    end

    if not pl.merchant_pirates.key?(merchant_card)
      pl.merchant_pirates[merchant_card] = [[self, pirate_card]]
      @hand.delete(pirate_card)
      return true
    end

    last_card = pl.merchant_pirates[merchant_card][- 1][1]
    if last_card.instance_of?(Captain) or last_card.instance_of?(Admiral)
      return false
    end

    pl.merchant_pirates[merchant_card].each do |pair|
      if pair[1].color == pirate_card.color and pair[0] != self
        return false
      end
    end

    pl.merchant_pirates[merchant_card].each do |pair|
      if pair[0] == self and pirate_card.color != pair[1].color
        return false
      end
    end

    pl.merchant_pirates[merchant_card].append([self, pirate_card])
    @hand.delete(pirate_card)
    return true
  end

  def play_captain(captain_card, merchant_card, pl)
    if not @hand.include?(captain_card)
      return false
    end

    if not merchant_card.instance_of?(MerchantShip)
        return false
    end

    if not pl.merchant_ships_at_sea.include?(merchant_card)
      return false
    end

    if not captain_card.instance_of?(Captain)
      return false
    end

    if not pl.merchant_pirates.key?(merchant_card)
      pl.merchant_pirates[merchant_card] = [[self, captain_card]]
      @hand.delete(captain_card)
      return true
    end

    pl.merchant_pirates[merchant_card].each do |pair|
      if pair[1].instance_of?(Admiral)
        next
      end

      if pair[1].color == captain_card.color and pair[0] != self
        return false
      end
    end

    pl.merchant_pirates[merchant_card].each do |pair|
      if pair[0] == self and captain_card.color != pair[1].color
        return false
      end
    end

    pl.merchant_pirates[merchant_card].append([self, captain_card])
    @hand.delete(captain_card)
    return true
  end

  def play_admiral(admiral_card, merchant_card)
    if not @hand.include?(admiral_card)
      return false
    end

    if not merchant_card.instance_of?(MerchantShip)
        return false
    end

    if not @merchant_ships_at_sea.include?(merchant_card)
      return false
    end

    if not admiral_card.instance_of?(Admiral)
      return false
    end

    if not @merchant_pirates.key?(merchant_card)
      @merchant_pirates[merchant_card] = [[self, admiral_card]]
      @hand.delete(admiral_card)
      return true
    end

    @merchant_pirates[merchant_card].append([self, admiral_card])
    @hand.delete(admiral_card)
    return true
  end
end

class Deck
  @@instance = nil
    attr_writer :instance

  def initialize
    if @@instance.nil?
      @cards = []
      # Add Admiral
      @cards.push(Admiral.get_instance())

      # Add 5 twos, 6 threes, 5 fours, 5 fives, 2 sixes, 1 seven, and 1 eight merchant cards
      (1..5).each do
        @cards.push(MerchantShip.new(2))
        @cards.push(MerchantShip.new(4))
        @cards.push(MerchantShip.new(5))
        @cards.push(MerchantShip.new(3))
      end

      @cards.push(MerchantShip.new(3))
      @cards.push(MerchantShip.new(7))
      @cards.push(MerchantShip.new(8))
      @cards.push(MerchantShip.new(6))
      @cards.push(MerchantShip.new(6))

      # Add four captains
      @cards.push(Captain.new("blue"))
      @cards.push(Captain.new("green"))
      @cards.push(Captain.new("purple"))
      @cards.push(Captain.new("gold"))

      # Add pirate ship cards 2 ones, 4 twos, 4 threes, and 2 fours for each color
      ["blue", "green", "purple", "gold"].each do |i|
        @cards.push(PirateShip.new(i, 1))
        @cards.push(PirateShip.new(i, 1))

        @cards.push(PirateShip.new(i, 2))
        @cards.push(PirateShip.new(i, 2))
        @cards.push(PirateShip.new(i, 2))
        @cards.push(PirateShip.new(i, 2))

        @cards.push(PirateShip.new(i, 3))
        @cards.push(PirateShip.new(i, 3))
        @cards.push(PirateShip.new(i, 3))
        @cards.push(PirateShip.new(i, 3))

        @cards.push(PirateShip.new(i, 4))
        @cards.push(PirateShip.new(i, 4))
      end

    else
      raise RuntimeError
    end
  end

  attr_accessor :cards

  def self.get_instance
    if @@instance.nil?
      @@instance = Deck.new()
    end
    return @@instance
  end

  def self.instance=(v)
    @@instance = v
  end
end

class Game
  def initialize(deck)
    @deck = deck
    @players = []
    @current_player = nil
  end

  attr_reader :deck, :players, :current_player
  attr_writer :current_player

  def create_players(names, min_players, max_players)
    if names.length() < min_players or names.length() > max_players
      raise RuntimeError
    end

    names.each do |name|
      @players.push(Player.new(name))
    end

  end

  def random_player
    if @players.length() == 0
      return nil
    end

    ran = Random.rand(@players.length())
    return @players[ran]
  end

  def start
    if @players.length() == 0
      return nil
    end

    dealer_ind = -1
    @players.each_with_index do |player, ind|
      if player.dealer == true
        dealer_ind = ind
      end
    end

    return @players[dealer_ind - 1]
  end

  def next
    if @players.length() == 0
      return nil
    end

    current_player_ind = -1
    @players.each_with_index do |player, ind|
      if player == @current_player
        current_player_ind = ind
      end
    end

    next_ind = current_player_ind + 1
    # wrap around
    if current_player_ind == (@players.length() - 1)
      next_ind = 0
    end

    return @players[next_ind]
  end

  def choose_player(pos)
    if pos > @players.length() or pos <= 0
      return nil
    end
    return @players[pos - 1]

  end

  def capture_merchant_ships
    @players.each do |player|
      player.merchant_ships_at_sea.each do |ship|

        if not player.merchant_pirates.key?(ship)
          player.merchant_ships_captured.append(ship)
          player.merchant_ships_at_sea.delete(ship)
          player.merchant_pirates.delete(ship)
          next
        end

        # Admiral & Captain case
        last_card = player.merchant_pirates[ship][-1][1]
        if last_card.instance_of?(Admiral) or last_card.instance_of?(Captain)
          last_player = player.merchant_pirates[ship][-1][0]
          last_player.merchant_ships_captured.append(ship)
          player.merchant_ships_at_sea.delete(ship)
          player.merchant_pirates.delete(ship)
          next
        end

        # Check pirates
        player_strength = {}
        player.merchant_pirates[ship].each do |attack_plyr, attack_card|
          if attack_card.instance_of?(PirateShip)
            if not player_strength.include?(attack_plyr)
              player_strength[attack_plyr] = attack_card.attack_value
            elsif player_strength.include?(attack_plyr)
              player_strength[attack_plyr] = player_strength[attack_plyr] + attack_card.attack_value
            end
          end
        end

        highest_player = []
        max_score = player_strength.values().max()
        player_strength.each do |plyr, scr|
          if scr == max_score
            highest_player.append(plyr)
          end
        end

        if highest_player.length() != 1
          next
        end

        highest_player[0].merchant_ships_captured.append(ship)
        player.merchant_ships_at_sea.delete(ship)
        player.merchant_pirates.delete(ship)
      end
    end
  end

  def show_winner
    player_scores = {}
    @players.each do |player|
      score = 0
      player.merchant_ships_captured.each do |captured|
        score += captured.value
      end
      player_scores[player] = score
    end

    winners = []
    max_score = player_scores.values().max()
    if max_score == 0
      return winners
    end

    player_scores.each do |plyr, scr|
      if scr == max_score
        winners.append([plyr, scr])
      end
    end

    return winners
  end
end
