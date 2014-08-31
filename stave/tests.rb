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


class M
  attr_accessor :a
  def here(&block)
    instance_eval &block
  end
  def forward(a1)
    p a + a1
  end
  def initialize(a)
    @a=a
  end
end
m = M.new 3
m.here do
   forward 2
 end
