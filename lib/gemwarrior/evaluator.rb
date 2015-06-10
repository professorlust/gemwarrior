# lib/gemwarrior/evaluator.rb
# Evaluates prompt input

require 'pry'

module Gemwarrior  
  class Evaluator
    # CONSTANTS
    ## MESSAGES
    PROGRAM_NAME      = 'Gem Warrior'
    QUIT_MESSAGE      = 'Thanks for playing the game. Until next time...'.colorize(:yellow)
    RESUME_MESSAGE    = 'Back to adventuring!'.colorize(:green)
    SEPARATOR         = '=========================================================================='
    CHANGE_PARAMS     = 'Options: name'
    LIST_PARAMS       = 'Options: monsters, items, locations'
    DEBUG_PARAMS      = 'Options: vars, map, stat'
    DEBUG_STAT_PARAMS = 'Options: atk_lo, atk_hi, strength, dexterity'
    
    ## ERRORS
    ERROR_COMMAND_INVALID           = 'That is not something the game yet understands.'
    
    ERROR_GO_PARAM_MISSING          = 'Just wander aimlessly? A direction would be nice.'
    ERROR_GO_PARAM_INVALID          = 'The place in that direction is far, far, FAR too dangerous. You should try a different way.'
    ERROR_ATTACK_PARAM_MISSING      = 'You cannot just "attack". You gotta choose something to attack.'
    ERROR_ATTACK_PARAM_INVALID      = 'That monster does not exist here or can\'t be attacked.'
    ERROR_TAKE_PARAM_MISSING        = 'You cannot just "take". You gotta choose something to take.'
    ERROR_DROP_PARAM_MISSING        = 'You cannot just "drop". You gotta choose something to drop.'
    ERROR_EQUIP_PARAM_MISSING       = 'You cannot just "equip". You gotta choose something to equip.'
    ERROR_UNEQUIP_PARAM_MISSING     = 'You cannot just "unequip". You gotta choose something to unequip.'
    ERROR_CHANGE_PARAM_MISSING      = 'You cannot just "change". You gotta choose something to change.'
    ERROR_CHANGE_PARAM_INVALID      = 'You cannot change that...yet.'
    ERROR_LIST_PARAM_MISSING        = 'You cannot just "list". You gotta choose something to list.'
    ERROR_LIST_PARAM_INVALID        = 'You cannot list that...yet.'
    ERROR_DEBUG_PARAM_MISSING       = 'You cannot just "debug". You gotta choose a debug command.'
    ERROR_DEBUG_PARAM_INVALID       = 'You cannot debug that...yet.'
    ERROR_DEBUG_STAT_PARAM_MISSING  = 'You cannot just "change stats". You gotta choose a stat to change.'
    ERROR_DEBUG_STAT_PARAM_INVALID  = 'You cannot change that stat...yet.'
    
    attr_accessor :world, :commands, :aliases, :descriptions, :devcmds, :devaliases
    
    def initialize(world)
      self.world = world
      self.devcmds = %w(debug)
      self.devaliases = %w(db)
      self.commands = %w(character inventory list rest look take drop equip unequip go attack change help quit quit!)
      self.aliases = %w(c i ls r l t d e ue g a ch h q qq)
      self.descriptions = [
        'Display character information',
        'Look in your inventory',
        'List all the objects of a type that exist in the world',
        'Take a load off and regain stamina',
        'Look around your current location',
        'Take item',
        'Drop item',
        'Equip item',
        'Unequip item',
        'Go in a direction',
        'Attack a monster',
        'Change something',
        'This help menu',
        'Quit w/ confirmation (also exit/x)',
        'Quit w/o confirmation (also exit!/xx)'
      ]
    end
    
    def evaluate(input)
      case input
      # Ctrl-D or empty command
      when nil, ""
        return
      # real command
      else
        tokens = input.split
        unless input_valid?(input)
          return ERROR_COMMAND_INVALID
        end
      end

      command = tokens.first.downcase
      param1 = tokens[1]
      param2 = tokens[2]
      param3 = tokens[3]

      case command
      # dev commands
      when 'debug', 'db'
        if param1.nil?
          puts ERROR_DEBUG_PARAM_MISSING
          puts DEBUG_PARAMS
        else
          case param1
          when 'vars', 'v'
            world.print_all_vars
          when 'godmode', 'iddqd', 'god', 'g'
            world.player.god_mode = !world.player.god_mode
          when 'beastmode', 'beast', 'b'
            world.player.beast_mode = !world.player.beast_mode
          when 'map', 'm'
            world.print_map
          when 'stat'
            if param2.nil?
              puts ERROR_DEBUG_STAT_PARAM_MISSING
              puts DEBUG_STAT_PARAMS
            else
              case param2
              when 'atk_lo'
                unless param3.nil?
                  param3 = param3.to_i
                  if param3.is_a? Numeric
                    if param3 >= 0
                      world.player.atk_lo = param3
                    end
                  end
                end
              when 'atk_hi'
                unless param3.nil?
                  param3 = param3.to_i
                  if param3.is_a? Numeric
                    if param3 >= 0
                      world.player.atk_hi = param3
                    end
                  end
                end
              when 'strength', 'str', 'st'
                unless param3.nil?
                  param3 = param3.to_i
                  if param3.is_a? Numeric
                    if param3 >= 0
                      world.player.atk_lo = param3
                      world.player.atk_hi = param3
                    end
                  end
                end
              when 'dexterity', 'dex', 'd'
                unless param3.nil?
                  param3 = param3.to_i
                  if param3.is_a? Numeric
                    if param3 >= 0
                      world.player.dexterity = param3
                    end
                  end
                end
              else
                ERROR_DEBUG_STAT_PARAM_INVALID
              end
            end
          else
            ERROR_DEBUG_PARAM_INVALID
          end
        end
      # normal commands
      when 'character', 'c'
        world.player.check_self
      when 'inventory', 'i'
        if param1
          world.player.inventory.describe_item(param1)
        else
          world.player.list_inventory
        end
      when 'list', 'ls'
        if param1.nil?
          puts ERROR_LIST_PARAM_MISSING
          puts LIST_PARAMS
        else
          world.list(param1)
        end
      when 'rest', 'r'
        world.player.rest
      when 'look', 'l'
        if param1
          world.describe_entity(world.location_by_coords(world.player.cur_coords), param1)
        else
          world.describe(world.location_by_coords(world.player.cur_coords))
        end
      when 'take', 't'
        if param1.nil?
          ERROR_TAKE_PARAM_MISSING
        else
          world.player.inventory.add_item(world.location_by_coords(world.player.cur_coords), param1)
        end
      when 'drop', 'd'
        if param1.nil?
          ERROR_DROP_PARAM_MISSING
        else
          world.player.inventory.remove_item(param1)
        end  
      when 'equip', 'e'
        if param1.nil?
          ERROR_EQUIP_PARAM_MISSING
        else
          world.player.inventory.equip_item(param1)
        end
      when 'unequip', 'ue'
        if param1.nil?
          ERROR_UNEQUIP_PARAM_MISSING
        else
          world.player.inventory.unequip_item(param1)
        end
      when 'go', 'g'
        if param1.nil?
          ERROR_GO_PARAM_MISSING
        else
          direction = param1
          if world.can_move?(direction)
            world.player.go(world.locations, param1)
            world.location_by_coords(world.player.cur_coords).checked_for_monsters = false
            world.describe(world.location_by_coords(world.player.cur_coords))
          else
            ERROR_GO_PARAM_INVALID
          end
        end
      when 'attack', 'a'
        if param1.nil?
          ERROR_ATTACK_PARAM_MISSING
        else
          monster_name = param1
          if world.has_monster_to_attack?(monster_name)
            monster = world.location_by_coords(world.player.cur_coords).monster_by_name(monster_name)
            world.player.attack(world, monster)
          else
            ERROR_ATTACK_PARAM_INVALID
          end
        end
      when 'change', 'ch'
        if param1.nil?
          puts ERROR_CHANGE_PARAM_MISSING
          puts CHANGE_PARAMS
        else
          case param1
          when 'name'
            world.player.modify_name
          else
            ERROR_CHANGE_PARAM_INVALID
          end
        end
      when 'help', 'h'
        list_commands
      when 'quit', 'exit', 'q', 'x'
        puts "You sure you want to quit? (y/n): "
        response = gets.chomp.downcase
        if (response.eql?("y") || response.eql?("yes"))
          puts QUIT_MESSAGE
          exit(0)
        else
          puts RESUME_MESSAGE
        end
      when 'quit!', 'exit!', 'qq', 'xx'
        puts QUIT_MESSAGE
        exit(0)
      else
        return
      end
    end

    private
    
    def print_separator
      puts SEPARATOR
    end

    def list_commands
      i = 0
      print_separator
      commands.each do |cmd|
        puts " #{cmd.ljust(9)}, #{aliases[i].ljust(2)} -- #{descriptions[i]}"
        i = i + 1
      end
      print_separator
    end
    
    def input_valid?(input)
      tokens = input.split
      command = tokens[0]
      commands_and_aliases = commands | aliases | devcmds | devaliases

      if commands_and_aliases.include?(command.downcase)
        if tokens.size.between?(1,4)
          return true
        end
      elsif tokens.empty?
        return true
      end
    end
  end
end
