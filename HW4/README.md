# Homework Assignment 4

## Learning Outcomes

After completion of this assignment, you should be able to:

- Prototype an application in Python and Ruby.

- Write unit tests to systematically test your scripts.


## Getting Started

To complete this homework assignment, you will need Ruby2 (preferably 2.6 or higher) and Python 3.5 or higher. These should have already been installed from previous assignments. It is recommended to use *pytest* to run any Python unit tests you may write. Install it using Python's package manager pip. Refer to the lecture notes for instructions on installation if needed.

Read the rest of the document carefully. This document describes everything that you will need to correctly implement the homework and submit the code for testing.

The first thing you need to do is download or clone this repository to your local system. Use the following command:

`$ git clone <ssh-link>`

After you clone, you will see a directory of the form *cise337-hw4-more-scripting-\<username\>*, where *username* is your GitHub username.

In this directory, you will find the following files:
- *loot.py*: Your Python implementation goes here.
- *loot.rb*: Your Ruby implementation goes here.
- *loot_deck_test.py*: Write test code to verify the correctness of the card deck for Python.
- *loot_play_test.py*: Write test code to verify playing the game for Python.
- *loot_deck_test.rb*: Write test code to verify the correctness of the card deck for Ruby.
- *loot_play_test.rb*: Write test code to verify playing the game for Ruby.

**At the top of each file you will find hints to fill your full name, NetID, and SBU ID. Please fill them accurately**. This information will be used to collect your scores from GitHub. If you do not provide this information, your submission may not be graded. You should write the implementation and the tests needed to verify the correctness of your implementation.


## Grading

We will run a different set of test cases to verify the correctness of your implementation. You will get credit for every passing test similar to previous assignments, except here we do not provide the test cases.

You will need to write your own unit tests in Python and Ruby using the unit test frameworks discussed in class. We will evaluate your tests using coverage tools to determine how well your tests cover the code in your implementation. Points will be based on coverage percentage.

The homework assignment is worth a total of 100 points. 40 points for the Python implementation, 40 points for the Ruby implementation, 10 points for the Python test cases, and 10 points for the Ruby test cases.

## Problem Specification
In this assignment, we will develop a card game called loot in Python and Ruby. We will first outline the rules of this game.

The object of the game is to be the player with the most gold coins when the deck is depleted and one player is out of cards.

The deck of cards has two kinds of cards -- merchant ship cards and pirate ship cards. There are 25 merchant ship cards, each with a value associated . Each merchant ship has a value associated with it indicating the amount of gold on the ship. The combined value of all merchant ship cards is a total of 100 gold: 5 twos, 6 threes, 5 fours, 5 fives, 2 sixes, 1 seven, and 1 eight.

There are 48 pirate ship cards; 12 each in 4 different colors -- blue, green, purple, and gold. The twelve ships of each color are divided into varying levels of attack strength: 2 ones, 4 twos, 4 threes, and 2 fours.

At the start of the game, the deck should be shuffled by any player and each player should be dealt with 6 cards. The game proceeds in rounds. In each round all the players take turns to play. The player to the left of the dealer starts and play continues clockwise. After each round all players capture the merchant ships they have contested and won. More on that shortly.

During a round when it is the player's turn, they can take one of the following actions:

- Draw a card from the deck.
- Float a merchant ship.
- Attack a merchant ship with a pirate ship.
- Attack a merchant ship with a captain card.
- Defend a merchant ship with an admiral card.

#### Draw A Card

A player can take the top card from the draw pile and add it to their hand. This ends the player's turn and play moves to the left. There is no limit to the no. of cards a player can have in their hand.

#### Float A Merchant Ship
A player can take a merchant ship from their hand and place it in front of them. This indicates that the merchant ship is now *at sea* and can be attacked by other pirates or defended by the player. However, if the merchant ship is not attacked before the player's next turn then the player can win or capture the merchant ship floated.

#### Attack With A Pirate Ship

A player can attack any floated merchant ship with a pirate ship in their hand. To attack a merchant ship X, the player must use a pirate ship with a color not yet used against X. If X has not been attacked before, the player may use any color of pirate ship to attack X. If the player has attacked X in previous rounds, then they must attack with a pirate ship of the same color that was used previously. For example, the player had attacked X with a blue colored pirate ship in a previous round, it must attack X with a blue-colored pirate ship in the current round as well.

Note a merchant ship can be attacked by any player including the player who floated it (to keep possession of the ship).

#### Attack With A Captain

Each colored pirate fleet has one pirate captain. A pirate captain card may be used to strengthen a player's attack locked in a battle over a merchant ship. A pirate captain has the highest attack strength or value associated with it. If such a card is played then the merchant ship will be won by the player who played the pirate captain card. Once a pirate captain card is played, the merchant ship cannot be attacked anymore unless another player plays a captain pirate card. In case of more than one pirate captain card, the pirate captain card played last wins. Note a player can play a pirate captain card if such a card is in their hand and if the color on the card matches the pirate cards used by the player to attack the merchant ship in previous rounds.

#### Defend With Admiral

The Admiral has the same strength as that of a pirate captain ship but can only be played to defend one's own merchant ship. There is only one admiral in the entire card deck. The last to play an admiral or pirate card wins the merchant ship. For example, if player A floats a merchant ship and player B attacks with a blue pirate ship of value 4 then the player A (on their turn) can take back the ship by playing an admiral unless another player or player B attacks with a blue pirate captain ship.

#### Tied Attack Strengths

If a merchant ship is attacked by several pirate ships of equal strength value then it must remain in play until a player wins the ship. If a merchant ship remains in play till end of game then the merchant ship is lost forever to the sea.

#### Capturing Merchant Ships

At the end of every round, players capture their respective merchant ships at sea. A player X can capture a merchant ship if:

- the merchant ship played by X has not been contested or attacked by any player.

- X has the highest attack strength or value on a merchant ship.

#### Game End

The game ends when all cards in the deck are over. Any tied merchant ships are discarded. The player with highest value of gold coins from the captured merchant ships is the winner.

### Implementation Details

We will implement the Loot game as described above in both Python and Ruby.

The Python implementation should be in the file `loot.py`. The Ruby implementation should be in the file `loot.rb`. Both files have a few global variables to indicate the pirate card colors and no. of players that can play the game. We assume that the game can be played by 2 to 5 players. You may use these variables in your implementation. Further, both files have starter code with the classes needed to implement the game. The classes are defined as follows:

- The *MerchantShip* class with a *value* attribute to indicate the value of the gold coins in the merchant ship. For Python, this class must have a method *get_value()* that returns the value of the merchant ship. For Ruby, *value* should be readable from outside the class.

- The *PirateShip* class with attributes *attack_value* and *color* to indicate the attack strength/value of the pirate ship and the color of the card. For Python, this class must have the methods -- *get_value()* that returns the attack strength of the pirate ship and *get_color()* that returns the color of the pirate ship. For Ruby, both attributes must be readable from outside the class.

- The *Captain* class with attribute *color* to indicate the color of the captain ship. For Python, this class must have a method *get_color()* that returns the value of the merchant ship. For Ruby, *color* should be readable from outside the class.

- The *Admiral* class. Since there can only be one admiral in the deck we should make this a *singleton* class, that is, there should only be one instance of this class. Any instance of this class should be created via the static method *get_instance()*. For Python, if more than one instance of this class is created then a runtime error of type *Exception* should be raised. For Ruby, *RuntimeError* exception should be raised.

- The *Deck* class with attribute *cards* to indicate the list of cards in the deck. Each card in the deck is either a merchant card, a pirate card, a captain or an admiral. The no. of cards in the deck should be the same as outlined above in *Problem Specification*. Since there can only be one deck, this class should be a singleton class. Any instance of this class should be created via the static method *get_instance()*. If more than one instance of this class is created then a runtime error of type *Exception* should be raised. For Ruby, an exception of type *RuntimeError* should be raised. Also, note the *cards* attribute must be readable from outside the class in Ruby.

- The *Player* class should contain attributes and methods that can be used by a player to play the game. *Note that for Ruby, the instance variables described below should be readable from outside the class*. The class should have should have the following:

  - *name* is an instance variable for a player's name. This is of type string.

  - *merchant_ships_at_sea* is an instance variable to denote the list of merchant ships floated by the player. An element in this list should be of type *MerchantShip*.

  - *merchant_ships_captured* is an instance variable to indicate the list of merchant ships captured by the player. An element in this list should be of type *MerchantShip*.

  - *hand* is an instance variable that represents the list of cards the player holds in their hand. A card in the list can be any card in the playing deck.

  - *merchant_pirates* is an instance variable that is used to keep track of the pirates attacking a merchant ship floated by the player. It is a dictionary with a merchant ship at sea as the key and a list of pairs *(Player,Attacker)* as the value. An *Attacker* is may be a *PirateShip, Captain, or Admiral*. For Ruby, this attribute must be writable from outside the class as well.

  - *dealer* is a Boolean instance variable used to indicate if the player is the assigned dealer, that is, deals the cards from the beginning to each player at the beginning of the game. This is set to *True* if a player is the dealer; *False* otherwise.

  - *deal(game_state)* is a method that takes an instance of the *Game* class as input. This method should assign the player as the dealer, shuffle the cards in the deck, and distribute exactly six cards to each player (including itself). Each player should have six unique cards initially as per the rules of the game.

  - *draw_card(game_state)* is a method that takes an instance of the *Game* class an input. This method should reduce the deck of cards by 1 and increment the player's hand by 1 card. It is used to simulate the action of a player drawing a card from a deck of cards in the game.

  - *float_merchant(card)* is a method that takes a card as input. It should take a merchant ship from the player's hand and float it to sea by appending to *merchant_ships_at_sea*. The method returns *True* if the action succeeded; *False* otherwise. The action will fail if the ship being floated is not a merchant ship.

  - *play_pirate(pirate_card, merchant_card, p1)* is a method that takes a pirate card, a merchant ship, a player as inputs. The pirate card must be in the player's hand and the merchant ship must have been floated to sea by another player *p1*. This method is used to attack a merchant ship out at sea with a pirate ship as per the rules outlined in the *Attack with a Pirate* section. The method returns *True* if the action of playing the pirate card succeeds; *False* otherwise.

  - *play_captain(captain_card, merchant_card, p1)* is a method that takes a captain card, a merchant ship, a player as inputs. The captain card must be in the player's hand and the merchant ship must have been floated to sea by another player *p1*. This method is used to attack a merchant ship out at sea with a captain ship as per the rules outlined in the *Attack with a Captain* section. The method returns *True* if the action of playing the captain succeeds; *False* otherwise.

  - *play_admiral(admiral_card, merchant_card)* is a method that takes an admiral card and a merchant ship. The admiral card must be in the player's hand and the merchant ship must have been floated to sea. This method is used to defend a merchant ship out at sea with an admiral ship as per the rules outlined in the *Defend with Admiral* section. The method returns *True* if the action of playing the admiral succeeds; *False* otherwise.

- The *Game* class should contain attributes and methods to help play the game. To this end, it should have the following attributes and methods:

  - *deck* is an instance variable for the instance of class *Deck*. For Ruby, this should be readable from outside the class as well.

  - *players* is instance variable for the list of players playing the game. Assume each element in the list to be an instance of *Player* class. For Ruby, this should be readable from outside the class as well.

  - *current_player* is an instance variable for the player currently playing. Assume this to be an instance of the *Player* class.

  - *create_players(names, min_players, max_players)* is a method that takes a list of strings in *names* denoting the names of participating players and create a list of instances of the *Player* class. This list is the same as the instance variable *players* playing the game. For Python, raise a runtime error of type *Exception* if less than 2 players or more than 5 players are playing the game. The method does not need to return a value. For Ruby, raise *RuntimeError*.

  - *random_player()* is a method that returns a random instance of the *Player* class from the list of *players* playing the game. If the list is empty return *None* or *Nil*.

  - *start()* is a method that returns the player instance to the left of the player assigned as a dealer in the *players* list. For instance, *players = [X,Y,Z]* and *X* is the dealer then *start()* should return the player Z since Z is to the left of X (notice how the list wraps around). Similarly, if Y is the dealer then *start()* should return X since X is to the left of the dealer Y. Assume that *players* will be non-empty and exactly one player in *players* will be a dealer.

  - *next()* is a method that returns the player instance to the right of the *current_player* in the *players* list. For instance, *players = [X,Y,Z]* and *X* is the current player then *next()* should return the player Y since Y is to the right of X. As another example, if Z is the current player then *next()* should return X since X is to the right of Z (notice how the list wraps around). Assume that *players* will be non-empty and exactly one player in *players* will be a dealer. Assume *current_player* will always be an instance of *Player*.

  - *choose_player(pos)* is a method that returns an element in *players* at position *pos*. The position *pos* is 1-indexed, that is, the first element is assumed to be position 1. The method returns *None* or *Nil* if *pos* is out of bounds. For example, if *[loot.Player('X'), loot.Player('Y'), loot.Player('Z')]* then *choose_player(2)* should return loot.Player('Y'). On the other hand, *choose_player(4)* should return *None* or *Nil*.

  - *capture_merchant_ships()* is a method that is used after every round to capture merchant ships locked in battle and assign it to the player who won the merchant ship. This method should be implemented according to the rules of the game described for capturing merchant ships. As an example, consider the scenario where 3 players X, Y, and Z are playing. Suppose X floats a merchant ship. Y attacks the merchant ship with green colored pirate card with attack value 2. Next, Z attacks the merchant ship with gold colored pirate card with attack value 3.Y again attacks the merchant ship with green colored pirate card with attack value 3. Next, Z attacks the merchant ship with gold colored pirate card with attack value 1. At this point, if the method is called it should assign the merchant ship to Y and remove it from stack of merchant ships floated by X. These will be kept track by the appropriate instance variables defined in the *Player* class.  

  - *show_winner()* is a method that returns a list of players with the highest no. of gold coins collected from the merchant ships captured. Each element in the list is a pair where the first element is an instance of *Player* and the second element is the total no. of gold coins the player won.


## Submitting Code to GitHub

You can submit code to your GitHub repository as many times as you want till the deadline. After the deadline, any code you try to submit will be rejected. To submit a file to the remote repository, you first need to add it to the local git repository in your system, that is, directory where you cloned the remote repository initially. Use following commands from your terminal:

`$ cd /path/to/cise337-hw4-more-scripting-<username>` (skip if you are already in this directory)

```
$ git add loot.py
$ git add loot_deck_test.py
$ git add loot_play_test.py
$ git add loot.rb
$ git add loot_deck_test.rb
$ git add loot_play_test.rb
```

To submit your work to the remote GitHub repository, you will need to commit the file (with a message) and push the file to the repository. Use the following commands:

`$ git commit -m "<your-custom-message>"`

`$ git push`
