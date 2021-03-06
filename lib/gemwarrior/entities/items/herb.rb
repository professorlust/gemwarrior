# lib/gemwarrior/entities/items/herb.rb
# Entity::Item::Herb

require_relative '../item'

module Gemwarrior
  class Herb < Item
    def initialize
      super

      self.name           = 'herb'
      self.name_display   = 'Herb'
      self.description    = 'Green and leafy, this wild herb looks edible.'
      self.takeable       = true
      self.consumable     = true
      self.useable_battle = true
    end

    def use(world)
      puts 'You place the entire, smallish plant in your mouth, testing its texture. The mysterious herb is easily chewable, and you are able to swallow it without much effort. Slight tingles travel up and down your spine.'
      if world.player.at_full_hp?
        puts '>> The herb has no medicinal effect, as you already feel perfectly healthy, but it was kind of tasty.'
        { type: nil, data: nil }
      else
        hp_healed = rand(3..5)
        puts ">> You regain #{hp_healed} hit points.".colorize(:green)
        { type: 'health', data: hp_healed }
      end
    end
  end
end
