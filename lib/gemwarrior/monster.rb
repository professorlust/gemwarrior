# lib/gemwarrior/monster.rb
# Monster creature

require_relative 'creature'

module Gemwarrior
  class Monster < Creature
    attr_accessor :xp, :atk_hi, :atk_lo, :rox, :xp_to_give, :battlecry
  
    def initialize(
      id, 
      name, 
      description, 
      face,
      hands, 
      mood, 
      level, 
      hp_cur, 
      hp_max, 
      atk_lo, 
      atk_hi, 
      inventory, 
      rox,
      xp_to_give,
      battlecry
    )
      self.id = id
      self.name = name
      self.description = description
      self.face = face
      self.hands = hands
      self.mood = mood
      
      self.level = level
      self.hp_cur = hp_cur
      self.hp_max = hp_max
      
      self.atk_lo = atk_lo
      self.atk_hi = atk_hi
      
      self.inventory = inventory
      self.rox = rox
      self.xp_to_give = xp_to_give
      
      self.battlecry = battlecry
    end
    
    def take_damage(dmg)
      self.hp_cur = hp_cur.to_i - dmg.to_i
    end

  end
end
