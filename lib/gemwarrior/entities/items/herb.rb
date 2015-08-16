# lib/gemwarrior/entities/items/herb.rb
# Item::Herb

require_relative '../item'

module Gemwarrior
  class Herb < Item
    def initialize
      super

      self.name         = 'herb'
      self.description  = 'Green and leafy, this wild herb looks edible.'
      self.atk_lo       = nil
      self.atk_hi       = nil
      self.takeable     = true
      self.useable      = true
      self.consumable   = true
      self.equippable   = false
    end

    def use(player = nil)
      puts 'You place the entire, smallish plant in your mouth, testing its texture. The mysterious herb is easily chewable, and you are able to swallow it without much effort. Slight tingles travel up and down your spine.'
      if player.at_full_hp?
        puts '>> The herb has no medicinal effect, as you already feel perfectly healthy, but it was kind of tasty.'
        { type: nil, data: nil }
      else
        puts '>> You regain a few hit points.'
        { type: 'health', data: rand(3..5) }
      end
    end
  end
end
