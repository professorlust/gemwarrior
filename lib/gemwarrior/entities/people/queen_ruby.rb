# lib/gemwarrior/entities/people/queen_ruby.rb
# Entity::Creature::Person::QueenRuby

require_relative '../person'
require_relative '../../misc/animation'

module Gemwarrior
  class QueenRuby < Person
    # CONSTANTS
    MOVE_TEXT = '** WHOOOOOOSH **'

    def initialize
      super

      self.name         = 'queen_ruby'
      self.name_display = 'Queen Ruby'
      self.description  = 'Queen Ruby glimmers like she was made from the substance of her name. She wears a wan smile, and her hands are delicately intertwined as she sits patiently.'
    end

    def use(world)
      speak('Thank you for bringing back the ShinyThing(tm)! The land of Jool is saved!')
      STDIN.getch
      speak("Please, #{world.player.name}, hand the ShinyThing(tm) to me, before all is lost!")
      puts

      print 'Hand over the ShinyThing(tm)? (y/n) '
      answer = gets.chomp.downcase
      
      case answer
      when 'y', 'yes'
        world.player.inventory.remove_item('sparkly_thing')
        speak('Oh, thank you! Now that the evil Emerald is defeated, and I, Queen Ruby, have the ShinyThing(tm) again, peace can come to the land of Jool. Your reward is...')
        STDIN.getch
        Animation.run(phrase: '...', oneline: true)
        STDIN.getch
        Animation.run(phrase: '...', oneline: true)
        STDIN.getch
        Animation.run(phrase: '...my thanks!"', oneline: true)
        STDIN.getch
        puts
        speak('Now, be a dear and run on home.')
        puts
        STDIN.getch
        puts 'And with that, she waves her arm in a tired, yet mystical, manner. Your mind and sight go blank, and you "poof" out of existence.'
        puts
        
        Animation.run(phrase: MOVE_TEXT)
        { type: 'move', data: 'Home' }
      when 'n', 'no'
        speak('No? No??? Well, you are not leaving this room until you do, so think long and hard about that.')
        { type: nil, data: nil }
      else
        speak('Take your time and let me know when you are going to give me the ShinyThing(tm), all right?')
        { type: nil, data: nil }
      end
    end
  end
end
