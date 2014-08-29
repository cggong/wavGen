module Stave
  #This library should be using some image libraries written 
  #separately, otherwise it will be stupid and excruciating, 
  #not to say a much less DRY and disgusting code. 
  #The image library should provide an interface and hide out 
  #stupid details. 

  class MusicObject
    #should have methods self.width, self.draw
  end

  class Note < MusicObject #A bunch of notes sticking together
    attr_accessor :clef, :duration
    #clef: :treble, :bass
  end

  class FlaggedNote < Note #Flagged notes can stick together. 
  end

  class NonflaggedNote < Note
  end

  class WholeNote < NonflaggedNote
  end

  class HalfNote < NonflaggedNote
  end

  class QuaterNote < NonflaggedNote
  end

  class EighthNote < FlaggedNote
  end

  class SixteenthNote < FlaggedNote
  end

  def newNote(duration, clef)
    recipe = {4 => :Note, 3 => HalfNote, 2 => HalfNote, 1 => QuaterNote,
              1.5 => QuaterNote, 0.75 => EighthNote, 0.5 => EighthNote, 
              0.375 => SixteenthNote, 0.25 => SixteenNote}
    dottedList = [3, 1.5, .75, .375]
    dotted = dottedList.include? duration
    recipe[duration].to_s.constantize.new dotted, clef
  end

  class Clef < MusicObject
  end

  class Treble < Clef
  end

  class Bass < Clef
  end

  class Stave #collection of MusicObjects
    attr_accessor :objs
    def draw
      #draw staff, invoke MusicObject.draw
    end
  end
end
