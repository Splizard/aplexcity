
class Board {
   int size;
   color[] counters;
   int[] buildings;
   int activebuilding;
   boolean[] selected;
   
   Board(int s) {
      size = s; 
      counters = new color[size*size];
      buildings = new int[size*size];
      selected = new boolean[size*size];
      
      //Fill board with random counters.
      for (int i=0; i<size*size; i++) {
        counters[i] = types[(int)random(10)];
      } 
   }
   
   private boolean checkCollision (int a, int b) {
    return a%size < b%size + 2 && a%size + 2 > b%size && a/size < b/size + 2 && a/size + 2 > b/size;
   }
   
   color GetCounter(int x, int y) {
      return counters[y*size+x]; 
   }
   
   int GetBuilding(int x, int y) {
       if (buildings[y*size+x] > 0) {
        return buildings[y*size+x];
       }
        if (y > 0 && buildings[(y-1)*size+x] > 0) {
        return buildings[(y-1)*size+x];
       }
        if (y > 0 && x < size && buildings[(y-1)*size+x-1] > 0) {
          return buildings[(y-1)*size+x-1];
       }
        if (y > 0 && x < size && buildings[y*size+(x-1)] > 0) {
          return buildings[y*size+(x-1)];
       }
      return 0;
   }
   
   void SelectResource(int x, int y) {
      int i = activebuilding;
      
      if (!((i%size == x-2 && i/size == y ) //Right top.
          || (i%size == x+1 && i/size == y ) //Left top.
          || (i%size == x-2 && i/size == y-1 ) //Right bottom.
          || (i%size == x+1 && i/size == y-1) //Left bottom.
          || (i%size == x && i/size == y+1 ) //Top left.
          || (i%size == x-1 && i/size == y+1 ) //Top Right.
          || (i%size == x && i/size == y-2 ) //Bottom left.
          || (i%size == x-1 && i/size == y-2 ))) return; //Bottom right.
      
       selected[y*size+x] = !selected[y*size+x];
   }
   
    boolean IsActiveBuilding(int x, int y) {
      if (y*size+x == activebuilding || ((y-1)*size+x == activebuilding) || ((y-1)*size+x-1 == activebuilding) || (y*size+(x-1) == activebuilding))  {
         return true;
      }
      return false;
   }
   
   int ActiveBuilding() {
      if (activebuilding < 0 ) return 0;
      return buildings[activebuilding];
   }
   
   boolean CanPlaceBuilding(int x, int y) {
    if (counters[y*8+x] == black || counters[y*8+x] == brown || counters[y*8+x] == red) return false;
    if (counters[y*8+x+1] == black || counters[y*8+x+1] == brown || counters[y*8+x+1] == red) return false;
    if (counters[(y+1)*8+x] == black || counters[(y+1)*8+x] == brown  || counters[(y+1)*8+x] == red) return false;
    if (counters[(y+1)*8+x+1] == black || counters[(y+1)*8+x+1] == brown || counters[(y+1)*8+x+1] == red) return false; 
     
     for (int i = 0; i < buildings.length; i++) {
         if (buildings[i] > 0) {
           if (checkCollision(y*size+x, i)) {
              return false; 
           }
         }
      }
      return true;
   }
   
   int NumberOfSelectedResources() {
     int resourcecount = 0;
        for (int i =0; i < selected.length; i++) {
          if (counters[i] != empty) {
            if (selected[i]) { 
              resourcecount++;
            }
          }
        }
     return resourcecount;
   }
   
   void AbsorbResources() {
     for (int i =0; i < selected.length; i++) {
        if (selected[i]) { 
          counters[i] = empty;
        }
     }
           
     buildings[activebuilding]++; 
     activebuilding = -1;
   }
   
   void ClearSelection() {
     //Clear the selection.
     selected = new boolean[size*size];
   }
   
   void PlaceBuilding(int x, int y) {
       buildings[y*size+x] = 1;  //<>//
   }
   
   void SetActiveBuilding(int x, int y) {
       if (x < 0 || y < 0) {
         activebuilding = -1;
         return;
       } 
       if (buildings[y*size+x] > 0) {
         activebuilding = y*size+x;
       }
        if (buildings[(y-1)*size+x] > 0) {
         activebuilding = (y-1)*size+x;
       }
        if (buildings[(y-1)*size+x-1] > 0) {
         activebuilding = (y-1)*size+x-1;
       }
        if (buildings[y*size+(x-1)] > 0) {
         activebuilding = y*size+(x-1);
       }
   }
   
   color SetCounter(int x, int y, color counter) {
      return counters[y*size+x] = counter; 
   }
   
   void draw() {
      for (int i=0; i<size*size; i++) {
       if (selected[i]) {
           stroke(255, 0, 0);
         } else {
         stroke(0, 0, 0);
       }
       fill(255, 255, 255);
       rect(i%size*50,i/size*50,50,50);
       
       if (counters[i] != color(0,0,0,0)) {
         fill(counters[i]);
         ellipse(i%size*50+25, i/size*50+25, 50, 50);
       }
     }
     
     for (int i=0; i<64; i++) {
      if (buildings[i] > 0) {
           if (i == activebuilding) {
             fill(color(150, 150, 150));
           } else {
             fill(color(100, 100, 100));
           }
           ellipse(i%size*50+50, i/size*50+50, 100, 100);
           fill(color(0,0,0));
           textSize(textsize);
           text(String.valueOf(buildings[i]), i%size*50+50-textsize/4, i/size*50+50+textsize/4);
       }
     }
    
   }
}