public enum GameState {
   Building, Upgrading, Placing
}

int textsize = 24;

class Game {
  Board board;
  GameState state;
  int turn;
  
  
  Game() {
    board = new Board(8);
    state = GameState.Building;
  }
  
  void mousePressed(int x, int y) {
   switch (state) {
     case Placing:
       if (board.GetCounter(x, y) == empty) { //Check that  the space is empty.
          board.SetCounter(x, y, types[(int)random(10)]); 
          state = GameState.Building;
       }
       return;
      
     case Building:
       if (board.GetBuilding(x, y) > 0) {
          state = GameState.Upgrading;
          board.SetActiveBuilding(x, y);
          return;
       }
       
       if (board.CanPlaceBuilding(x, y)) {
         board.PlaceBuilding(x, y);
         
         if (turn > 0) {
             state = GameState.Placing;
          } else {
             turn++; 
          }
       }
       
     return;
     
     case Upgrading:
    
      //The resources have been selected.
      if (board.IsActiveBuilding(x, y)) {
        
        int resourcecount = board.NumberOfSelectedResources();
      
     
        if (resourcecount != board.ActiveBuilding()) {
           state = GameState.Building;
           board.ClearSelection();
           board.SetActiveBuilding(-1, -1);
           return;
        }
        
        board.AbsorbResources();
        board.ClearSelection();
        board.SetActiveBuilding(-1, -1);
        state = GameState.Placing;
    } else {
      
      board.SelectResource(x, y); 
      
    }
   }
  }
  
  void draw() {
     board.draw();
     
     String text = "";
   
   switch (state) {
      case Building:
        text = "Place/upgrade your buildings!";
        break;
      case Upgrading:
        text = "Select resources to upgrade!";
        break;
      case Placing:
        text = "Place your resource.";
        break;
   }
   
   //Message.
   textSize(42);
   fill(color(255,255,255));
   text(text, 0, 9*50);
  }
}