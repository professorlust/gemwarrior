# lib/gemwarrior/entities/monsters/bloodstorm.rb
# Bloodstorm monster

require_relative '../monster'

module Gemwarrior
  class Bloodstorm < Monster
    def initialize
      self.name         = 'bloodstorm'
      self.description  = 'A literal swirling, maniacal vortex of human hemoglobin.'
      self.face         = 'bloody'
      self.hands        = 'bloody'
      self.mood         = 'boiling'
      
      self.level        = rand(5..6)
      self.hp_cur       = rand((level * 2)..(level * 3))
      self.hp_max       = hp_cur
      self.atk_lo       = rand(level..(level * 1.5).floor)
      self.atk_hi       = rand((level * 1.5).floor..(level * 3).floor)
      self.defense      = rand(6..7)
      self.dexterity    = rand(5..7)

      self.inventory    = Inventory.new
      self.rox          = rand((level * 2)..(level * 3))
      self.xp           = rand(level..(level * 2))
      
      self.battlecry    = '/swirls'
    end
  end
end
