using namespace std; 
//use some qt package? 
#include<QPainter> 
typedef QPainter* ImgDraw; 
//the QPainter on which we wanna draw the music notation on, 
//or whatever it is, QImage? figure it out later. 
class nmn { //nmn stands for numbered musical notation. 
  struct note { 
    int tone; //1 for do, 2 for re, etc. 
    int semi; //1 for sharp, 0 for none, -1 for flat. 
    int octave; //0 for middle, i for i octave above for i in [-1, 1]. 
    int dura[2]; //duration represented by a simplest ratio of two ints. 
  }; 
  vector<note> notes; 
  ImgDraw draw; //the drawing board that we gonna use. 
  const int width; 
  //pixel width of the drawing board, which will affect the layout! 
  static const int sz; //character size on layout. 
  static const int lnwth; //line width in pixel again. 
public: 
  nmn(ImgDraw draw); //give me the drawing board, which I'll maintain! 
  ~nmn(); 
  void IncDraw(ImgDraw draw); //Incrementally draw the last note. 
  void Draw(); //Draw all notes. 
  void addNote(int tone, int semi, int octave, int dura[]); 
  int* computeDura(double t); 
  //input is duration as double, output dura[2]. 
  //although perhaps you'll implement it, and I don't have to! 
  //OK, can't think of other APIs. Please let me know if I missed something! 
}; 
