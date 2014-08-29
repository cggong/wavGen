module Stave
  #This library should be using some image libraries written 
  #separately, otherwise it will be stupid and excruciating, 
  #not to say a much less DRY and disgusting code. 
  #The image library should provide an interface and hide out 
  #stupid details. 
  #In other words, model, view, controller should be separated. 

  class MusicObject
    #should have methods self.width, self.draw
  end

  class Accidental < MusicObject
    attr_accessor :note 
    #Every Accidental belongs to a note, except at the beginning of a mesure. 
    def initialize(note)
      @note = note
    end
  end

  class Flat < Accidental
  end

  class Natural < Accidental
  end

  class Sharp < Accidental
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
    recipe = {4 => Note, 3 => HalfNote, 2 => HalfNote, 1 => QuaterNote,
              1.5 => QuaterNote, 0.75 => EighthNote, 0.5 => EighthNote, 
              0.375 => SixteenthNote, 0.25 => SixteenNote}
    dottedList = [3, 1.5, .75, .375]
    dotted = dottedList.include? duration
    recipe[duration].new dotted, clef
    #It's obvious that after the controller call newNote, it's gonna 
    #send some messages to the new note, so that it can be provided
    #enough information so that it can figure out how to draw itself. 
  end

  class SimpleMusicObject < MusicObject
    #for simple music objects, their appearance doesn't vary, such as 
    #clefs. 
  end

  class Clef < SimpleMusicObject
  end

  class Treble < Clef
  end

  class Bass < Clef
  end

  class BarLine < SimpleMusicObject
  end

  class Rest < SimpleMusicObject
    attr_reader :duration
    def initialize(duration)
      @duration = duration
    end
  end


  class TimeSignature < MusicObject
    attr_accessor :up, :down
  end

  class Measure
    attr_accessor :objects, :meter
    #meter consists of two integers, determines TimeSignature. 
    def draw
      #append BarLine, invoke MusicObject.draw
    end
  end

  class Stave #collection of Measures
    attr_accessor :measures
    def draw
      #draw staff, invoke Measure.draw
      #also be cautious about cross-measure ties. 
    end
  end
end
