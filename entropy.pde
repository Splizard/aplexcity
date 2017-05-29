
color[] counters = new color[64];

boolean[] selected = new boolean[64];

int[] buildings = new int[64];

color[] types = new color[11];

//The ID of the building we are upgrading.
int upgrading = -1;

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
  
  //We are placing resources.
   if (step == 2) {
       if (counters[y*8+x] == color(0,0,0,0)) { //Check that  the space is empty.
          counters[y*8+x] = types[(int)random(10)];
          step = 0;
          return;
       }
   }
  
  if (step == 0) {
    if (buildings[y*8+x] > 0) {
      upgrading = y*8+x;
      step = 1;         
      return;
    }
  
    //TODO check for pollution.
    buildings[y*8+x] = 1;
    
    if (turn > 0) {
       step = 2;
    } else {
       turn++; 
    }
  }
  
  //This is STEP1 upgrading a building.
  if (step == 1) {
    
    //The resources have been selected.
    if (y*8+x == upgrading) {
      int resourcecount = 0;
      for (int i =0; i < selected.length; i++) {
         
        //TODO check that the resources are adjacent.
        if (selected[i]) { 
          resourcecount++;
        }
      }
      
      if (resourcecount == buildings[upgrading]) {
           for (int i =0; i < selected.length; i++) {
              if (selected[i]) { 
                counters[i] = color(0,0,0,0);
              }
           }
           
           buildings[upgrading]++;
           step = 2;
      } else {
         step = 0; 
      }
      
      //Clear the selection.
      selected = new boolean[64];
    } else {
       selected[y*8+x] = !selected[y*8+x]; 
    }
  }
}

int textsize = 24;

int step = 0;
int turn = 0;

void draw() {
   clear();
   for (int i=0; i<64; i++) {
     if (selected[i]) {
       stroke(255, 0, 0);
     } else {
       stroke(0, 0, 0);
     }
     fill(255, 255, 255);
     rect(i%8*50,i/8*50,50,50);
     
     if (counters[i] != color(0,0,0,0)) {
       fill(counters[i]);
       ellipse(i%8*50+25, i/8*50+25, 50, 50);
     }
   }
   
   for (int i=0; i<64; i++) {
    if (buildings[i] > 0) {
         fill(color(100, 100, 100));
         ellipse(i%8*50+50, i/8*50+50, 100, 100);
         fill(color(0,0,0));
         textSize(textsize);
         text(String.valueOf(buildings[i]), i%8*50+50-textsize/4, i/8*50+50+textsize/4);
     }
   }
   
   
   String text = "";
   
   switch (step) {
      case 0:
        text = "Place/upgrade your buildings!";
        break;
      case 1:
        text = "Select resources to upgrade!";
        break;
      case 2:
        text = "Place your resource.";
        break;
   }
   
   //Message.
   textSize(42);
   fill(color(255,255,255));
   text(text, 0, 9*50);
}