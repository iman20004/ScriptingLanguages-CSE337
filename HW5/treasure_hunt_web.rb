###### IMAN ALI #######
###### 112204305 ######
###### imaali ######
require 'rubygems'
require 'sinatra'
require_relative "./game.rb"
use Rack::Session::Pool


def encounters(haz)
  if (haz == :guard)
    @ending = session[:ending]
    @ending.push "You woke up the guard and he ate you!"
    session[:ending] = @ending
    redirect '/game_lost'
  elsif (haz == :pit)
    @ending = session[:ending]
    @ending.push "You fell into a bottomless pit. Enjoy the ride!"
    session[:ending] = @ending
    redirect '/game_lost'
  elsif (haz == :bats)
    @game.console.narrations.push "Giant bats whisked you away to a new cavern!"

    old_room = @game.player.room
    new_room = @game.cave.random_room

    @game.player.enter(new_room)
    #how to encounter this rooms hazards
    if not @game.player.room.empty?
      @ending = session[:ending]
      @ending.push "Giant bats whisked you away to a new cavern!"
      session[:ending] = @ending
    end

    @game.player.room.hazards.each do |haz|
      encounters(haz)
    end

    @game.cave.move(:bats, old_room, new_room)
  end
end

before do
  @game = session[:game]
end

after do
  session[:game] = @game
end

get '/?' do
  @game = nil
  @time = Time.now.getutc
  erb :home
end

get '/play_game' do
  if @game == nil
    erb :warning
  else
    erb :game
  end
end

post '/play_game' do
  @game = Game.new
  # Kick off the event loop
  @game.player.enter(@game.cave.entrance)
  @game.console.show_room_description
  redirect '/play_game'
end

post '/action_game' do
  # Kick off the event loop
  @action = params[:action].to_s
  @room = params[:room].to_i

  @game.console.narrations.push("What do you want to do? (m)ove or (s)hoot? " + @action)
  @game.console.narrations.push("Where? " + @room.to_s)

  unless ["m","s"].include?(@action)
    @game.console.narrations.push "Invalid ACTION! Try again!"
    @game.console.narrations.push("-----------------------------------------")
    redirect '/play_game'
  end

  unless @game.player.room.exits.include?(@room)
    @game.console.narrations.push "Invalid DESTINATION! Try again!"
    @game.console.narrations.push("-----------------------------------------")
    redirect '/play_game'
  end

  if (@action == 'm')
    @game.player.enter(@game.player.room.neighbor(@room))

    # encounters
    if not @game.player.room.empty?
      session[:ending] = []
      #go in order
      @game.player.room.hazards.each do |haz|
        encounters(haz)
      end
    end

    @game.console.show_room_description
    redirect '/play_game'

  elsif (@action == 's')
    destination = @game.player.room.neighbor(@room)
    if(destination.has?(:guard))
      redirect '/game_won'
    else
      @game.console.narrations.push "Your arrow missed!"
      @game.console.narrations.push("-----------------------------------------")
      old_guard_room = @game.cave.room_with(:guard)
      if [:move, :stay].sample == :move
        new_guard_room = old_guard_room.random_neighbor
        @game.cave.move(:guard, old_guard_room, new_guard_room)

        @game.console.narrations.push("You heard a rumbling in a nearby cavern.")
      end

      if @game.player.room.has?(:guard)
        @ending = ["You woke up the guard and he ate you!"]
        session[:ending] = @ending
        redirect '/game_lost'
      end

      redirect '/play_game'
    end
  end
end

get '/game_won' do
  @game = nil
  erb :won
end

get '/game_lost' do
  @game = nil
  @ending = session[:ending]
  erb :lost
end

after '/game_lost' do
  session[:ending] = []
end
