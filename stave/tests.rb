a = ['Foo', 'Bar']
a.each do |name|
   define_class(name) do 
     def self.o
       puts name
     end
   end
 end
#Foo.o outputs Foo
#Bar.o outputs Bar, excellent! 


class Pos
  attr_accessor :a
  def here(block)
    instance_eval &block
  end
  def forward(a1)
    p a + a1
  end
  def initialize(a)
    @a=a
  end
end

class Note
  def draw
    Proc.new do 
          forward 3
        end
  end
end

p = Pos.new 5
n = Note.new
p.here &n.draw

####################

module Con
  A=10
end
Con::A
#=>10

####################
class Note
  def self.a
    Con::A
  end
end

####################
class A
  def a
    self
  end
end
class AA < A
end
aa = AA.new
aa.a

