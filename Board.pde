
class Board {
   int size;
   color[] counters;
   int[] buildings;
   int[][][] internals; //Buildings, levels, counters.
   int activebuilding;
   boolean[] selected;

   
   color nextcounter;
   
   Board(int s) {
      size = s; 
      counters = new color[size*size];
      buildings = new int[size*size];
      internals = new int[size*size][][];
      selected = new boolean[size*size];
      nextcounter = types[(int)random(10)];
      
      //Fill board with random counters.
      for (int i=0; i<size*size; i++) {
        counters[i] = types[(int)random(10)];
      } 
   }
   
   //Depending on which color the tokens are, will determine which image is drawn.
   void drawToken(color token, float tokenX, float tokenY){
     if(token == black)image(blackToken, tokenX, tokenY);
     if(token == white)image(whiteToken, tokenX, tokenY);
     if(token == red)image(redToken, tokenX, tokenY);
     if(token == green)image(greenToken, tokenX, tokenY);
     if(token == blue)image(blueToken, tokenX, tokenY);
     if(token == yellow)image(yellowToken, tokenX, tokenY);
     if(token == pink)image(pinkToken, tokenX, tokenY);
     if(token == purple)image(purpleToken, tokenX, tokenY);
     if(token == orange)image(orangeToken, tokenX, tokenY);
     if(token == brown)image(brownToken, tokenX, tokenY);
    }
   
   private boolean checkCollision (int a, int b) {
    return a%size < b%size + 2 && a%size + 2 > b%size && a/size < b/size + 2 && a/size + 2 > b/size;
   }
   
   color GetCounter(int x, int y) {
      return counters[y*size+x]; 
   }
   
   int GetBuilding(int x, int y) {
       if (x < 0 || y < 0 || x > 7 || y > 7) {
          return 0; 
       }
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
          
       if (counters[y*size+x] == red || counters[y*size+x] == black || counters[y*size+x] == brown) {
          return; 
       }
      
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
    if ( x > 7|| y > 7 ) {
       return false; 
    }
     
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
     int blues, greens, yellows, purples;
     blues = 0;
     greens = 0;
     yellows = 0;
     purples = 0;
     
     int resourcecount = 0;
        for (int i =0; i < selected.length; i++) {
          if (counters[i] != empty) {
            if (selected[i]) { 
              resourcecount++;
              
              if (counters[i] == blue) blues++;
              if (counters[i] == green) greens++;
              if (counters[i] == purple) purples++;
              if (counters[i] == yellow) yellows++;
            }
          }
        }
        
        
        while (blues > 0 && greens > 0) {
          blues--;
          greens--;
          resourcecount++;
        }
        
        while (yellows > 0 && purples > 0) {
          yellows--;
          purples--;
          resourcecount++;
        }
        
     return resourcecount;
   }
   
   void AbsorbResources() {
     int id = 0;
     internals[activebuilding][buildings[activebuilding]] = new int[8];
     for (int i =0; i < selected.length; i++) {
        if (selected[i]) { 
          internals[activebuilding][buildings[activebuilding]][id] = counters[i];
          counters[i] = empty;
          id++;
          if (id==8) {
             id = 0; 
          }
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
       buildings[y*size+x] = 1; //<>//
       internals[y*size+x] = new int[8][];
       internals[y*size+x][0] = new int[8];
       internals[y*size+x][0][0] = counters[y*size+x];
       internals[y*size+x][0][1] = counters[y*size+x+1];
       internals[y*size+x][0][2] = counters[(y+1)*size+x+1];
       internals[y*size+x][0][3] = counters[(y+1)*size+x];
       
       counters[y*size+x] = empty;
       counters[y*size+x+1] = empty;
       counters[(y+1)*size+x+1] = empty;
       counters[(y+1)*size+x] = empty;
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
   
   void SetCounter(int x, int y, color counter) {
      counters[y*size+x] = counter; 
   }
   
   void PlaceCounter(int x, int y) {
      counters[y*size+x] = nextcounter;
      nextcounter = types[(int)random(10)];
   }
   
   void draw(boolean placing) {
      for (int i=0; i<size*size; i++) {
       if (selected[i]) {
           stroke(255, 0, 0);
         } else {
         stroke(0, 0, 0);
       }
       fill(255, 255, 255);
       rect(i%size*50,i/size*50,50,50);
       
       if (counters[i] != color(0,0,0,0)) {
         //fill(counters[i]);
         //ellipse(i%size*50+25, i/size*50+25, 50, 50);
         drawToken(counters[i], i%size*50, i/size*50);
       }
     }
     
     if (placing) {
         
       int x = mouseX/50;
       int y = mouseY/50;
       
       fill(nextcounter);
       ellipse(x*50+25, y*50+25, 50, 50);
     }
     
     for (int i=0; i<64; i++) {
      if (buildings[i] > 0) {
           if (i == activebuilding) {
             
             //Draw what is currently inside the top level of the building.
             for (int x = 0; x < internals[i].length; x++){
               if (internals[i][x] != null) {
                 for (int j = 0; j < internals[i][x].length; j++){
                   fill(internals[i][x][j]);  
                   ellipse((size+1+x)*50, j*50+50, 50, 50);
                 }
               }
             }
             
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
