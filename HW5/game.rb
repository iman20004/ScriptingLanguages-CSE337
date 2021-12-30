require_relative "./treasure_hunt.rb"

class Game
  def initialize
    @cave = Cave.new
    @player = Player.new

    @console = Console.new(@player, [])

    @cave.add_hazard(:guard, 1)
    @cave.add_hazard(:pit, 3)
    @cave.add_hazard(:bats, 3)
  end
  attr_reader :cave, :player, :console
end
