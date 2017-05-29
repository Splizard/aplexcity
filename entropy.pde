
color[] counters = new color[64];

boolean[] buildings = new boolean[64];

color[] types = new color[11];

void setup() {
  size(800,600);
  
  types[0] = color(0, 0, 0);      //Black.
  types[1] = color(255, 255, 255);//White.
  types[2] = color(255, 0, 0);    //Red.
  types[3] = color(0, 255, 0);    //Green.
  types[4] = color(0, 0, 255);    //Blue.
  types[5] = color(255, 255, 0);  //Yellow.
  types[6] = color(255, 0, 255);  //Pink.
  types[7] = color(100, 0, 145);  //Purple.
  types[8] = color(255, 130, 0);  //Orange.
  types[9] = color(100, 50, 0);   //Brown.
  
  
  for (int i=0; i<64; i++) {
    counters[i] = types[(int)random(10)];
  }
}

void mousePressed() {
  //Determine board coordinates.
  int x = (int)(mouseX/50.0);
  int y = (int)(mouseY/50.0);
  
  //Outside of the board.
  if (x > 8 || y > 8) {
    return;
  }
  
  //TODO check for pollution.
  buildings[y*8+x] = true;
}

int textsize = 24;

void draw() {
   for (int i=0; i<64; i++) {
     fill(255, 255, 255);
     rect(i%8*50,i/8*50,50,50);
     fill(counters[i]);
     ellipse(i%8*50+25, i/8*50+25, 50, 50);
   }
   
   for (int i=0; i<64; i++) {
    if (buildings[i]) {
         fill(color(100, 100, 100));
         ellipse(i%8*50+50, i/8*50+50, 100, 100);
         fill(color(0,0,0));
         textSize(textsize);
         text("1", i%8*50+50-textsize/4, i/8*50+50+textsize/4);
     }
   }
   
   //Message.
   textSize(42);
   fill(color(0,0,0));
   text("Place your building!", 0, 9*50);
}