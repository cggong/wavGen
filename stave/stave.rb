module Stave
  #This library should be using some image libraries written 
  #separately, otherwise it will be stupid and excruciating, 
  #not to say a much less DRY and disgusting code. 
  #The image library should provide an interface and hide out 
  #stupid details. 
  #In other words, model, view, controller should be separated. 

  #I'm gonna store the drawing commands in some data structure, 
  #presumably a list. After I stored it, let the client program
  #to parse it for itself, see staveview.h

  #This module primarily concerns with the rendering of stave. 
  #Inputting DSL can be implemented in another module. 


  #This is a useful method. 
  #https://ruby-china.org/topics/17382
  def define_class(name, ancestor = Object)
    Object.const_set(name, Class.new(ancestor))
    Object.const_get(name).class_eval(&Proc.new) if block_given?
    Object.const_get(name)      # return defined class always
  end



  class Position
    #Each music object occupies some place, which should be 
    #characterized by this class. A position has two representations: 
    #the first (high level) as the x-coordinate on the stave if the 
    #stave is rendered on an infinitely wide page, and line number
    #on which it occupies. *** I'll call it a, b. ***
    #the second (low level) as x and y on the image. 
    attr_accessor :a, :b, :pa 
    #pa is parent's a

    #When we specify a position in MusicObject, we specify the high
    #level version. The conversion between high and low position
    #should be implemented in the class, which enables us to create
    #low-level drawing commands to the C++ drawing program. 

    #Position can be chained: intuitively you have a position object 
    #points at 211B. The position object should be able to create 
    #a Position instance that enable you to describe relative position
    #to it, which in turn still has such capability (see def around). 
    def initialize(parent = nil)
      @pa = parent ? parent.a + parent.pa : 0
    end

    def here(block) #This is fucking good! 
      instance_eval &block
    end

    def advance!(distance)
      a += distance
    end

    def around
      Position.new self
    end

    private
    def get_b_val(tone)
    end

    def drawOval(tone) #and a bunch of drawing methods. 
      #ultimately calls Draw.drawWholeNote
    end

    def drawSolidOval(tone)
    end

  end


  module Draw #layout constants and drawing methods
    W = 100 #width of page
    H = 5 #distance between two lines.
    D = 20 #space between two five-lines. 

    #regarding an oval for note: 
    EX = 8
    EY = 5

    #Distance between accidental and note
    ShortDist = 1

    def self.drawOval(x, y)
    end

    def self.drawSolidOval(x, y)
    end

    def self.drawThinLine(x1, y1, x2, y2)
    end

    def self.drawThickSlantedLine(x1, y1, x2, y2, thickness)
    end

  end


  class Flag
    #Flags seems to be so annoying that I decided to make it a 
    #separate class. 
  end

  class MusicObject
    #should have methods width, draw, and beware: ALL THE draw
    #METHODS ARE EXECUTED UNDER Position.instance_eval. 
    attr_accessor :width
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

  class NoAccidental < Accidental
  end

  class Note < MusicObject #A bunch of notes sticking together
    attr_accessor :clef, :duration, :tones, :accidental
    #clef: :treble, :bass
    private
    def structure(tones) #can't explain, please ask the author! 
      #How are the notes structured? 
      evenTones = tones.select &:even? 
      oddTones = tones.select &:odd? 
      if evenTones.length > oddTones.length 
      then [evenTones, oddTones] 
      else [oddTones, evenTones]
      end
    end

    def drawOvals
      solid = ![WholeNote, HalfNote].contains? self.class
      draw_command = solid ? :drawSolidOval : :drawOval
      curPos = around
      tones[1].each do |tone| #tone[1] has less notes, appear on the left. 
                curPos.send draw_command, tone
                #Now I can't use curPos.here, the incongruity is because
                #this drawing command is simple, and by using it instead
                #we avoid creating a new Proc or lambda. 
              end
      curPos.advance! Draw::EX
      tones[0].each do |tone|
                curPos.send draw_command, tone
              end
    end
  end

  class FlaggedNote < Note 
    #Cautious! Flagged notes can stick together, so:
    attr_accessor :flag
  end

  class NonflaggedNote < Note
    #notes playing at the same time. 
  end

  class WholeNote < NonflaggedNote
    def draw

    end

    def initialize(tones)
      @tones = structure tones
    end
  end

  class HalfNote < NonflaggedNote
  end

  class QuaterNote < NonflaggedNote
  end

  class EighthNote < FlaggedNote
  end

  class SixteenthNote < FlaggedNote
  end

  #Define dotted version of these notes. These should be almost the same. 
  noteKinds = [WholeNote, HalfNote, QuaterNote, EighthNote, SixteenthNote]
  #Now something annoying comes. Logically DEighthNote, DSixteenthNote
  #derives from FlaggedNote, and yet they don't flag. 
  #Second thought: No they don't derive from them. See code below. 
  noteKinds.each do |kind|
             define_class('D' + kind.to_s, NonflaggedNote) do 
               attr_accessor :note
               def initialize
                 note = kind.new 
               end

               def width
                 #something like call that in note, then add a constant, i.e., width of dot. 
               end

               def draw
                 #something like call that in note, then draw a dot. 
               end
             end
             #So clean! The code didn't grow out of control! 
           end
  

  def newNote(duration, clef)
    recipe = {4 => WholeNote, 3 => DHalfNote, 2 => HalfNote, 1 => QuaterNote,
              1.5 => DQuaterNote, 0.75 => DEighthNote, 0.5 => EighthNote, 
              0.375 => DSixteenthNote, 0.25 => SixteenNote}
    recipe[duration].new clef
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
      Proc.new do
            curPos = around
            #append BarLine, invoke MusicObject.draw
            objects.each do |object|
                     curPos.here object.draw
                     #The code is so beautiful! C++ sucks! 
                     #This is such a huge DSL. Be cautious. 
                     #This syntax is the most appealing because it separates
                     #the position from the drawing implementation, and there
                     #is no other implementation that does so as well. 
                     curPos.advance! object.width
                   end
          end
    end
  end

  class Stave #collection of Measures
    attr_accessor :measures
    def draw
      #Stave.draw is fundamentally different from that of other music
      #objects: it doesn't return a Proc, while others do. This is 
      #reasonable because Stave.draw needn't be put in some other 
      #Position. 

      #draw staff, invoke Measure.draw
      #also be cautious about cross-measure ties. 
      curPos = Position.new #current position
      measures.each do |measure|
                curPos.here measure.draw
                curPos.advance! measure.width
              end
    end
  end
end
