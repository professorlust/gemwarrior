# lib/gemwarrior/shell.rb
# Runs the command line interface for Gem Warrior

require 'highline'
require 'cli-console'

require_relative 'common'
require_relative 'player'
require_relative 'inventory'

module Gemwarrior
  class Shell
    private
    extend CLI::Task
        
    public

    def initialize(world, player)
      @world = world
      @player = player
    end
    
    usage 'Usage: character'
    desc 'How am I doing?'
    def character(params)
      @player.check_self
    end
    
    usage 'Usage: inventory'
    desc 'What stuff do I got?'
    def inventory(params)
      print "You check your inventory"
      @player.inventory
    end
    
    usage 'Usage: rest'
    desc 'Lie down somewhere and rest'
    def rest(params)
      hours = rand(1..23)
      minutes = rand(1..59)
      seconds = rand(1..59)
      
      hours_text = hours == 1 ? "hour" : "hours"
      mins_text = minutes == 1 ? "minute" : "minutes"
      secs_text = seconds == 1 ? "second" : "seconds"
      
      puts "You lie down somewhere quasi-flat and after a few moments, due to extreme exhaustion, you fall into a deep slumber. Approximately #{hours} #{hours_text}, #{minutes} #{mins_text}, and #{seconds} #{secs_text} later, you wake up with a start, look around you, notice nothing in particular, and get back up, ready to go again."
    end
    
    usage 'Usage: look'
    desc 'Get a description of the surroundings'
    def look(params)
      @player.cur_loc.describe
    end
    
    usage 'Usage: world'
    desc 'List all of the locations in the world'
    def world(params)
      @world.locations
    end
    
    usage 'Usage: monsters'
    desc 'List all of the monsters in the world'
    def monsters(params)
      @world.monsters
    end
  end
end