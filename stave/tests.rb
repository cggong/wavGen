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
