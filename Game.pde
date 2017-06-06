public enum GameState {
   Construction, Consumption, Completion, Conception, Combustion
}

int textsize = 24;

class Game {
  Board board;
  GameState state;
  int turn;
  
  int[] players;
  int activeplayer;
  
  
  Game() {
    board = new Board(8);
    state = GameState.Construction;
    players = new int[2];
  }
  
  void mousePressed(int x, int y) {
   switch (state) {
     case Conception:
       if (board.GetCounter(x, y) == empty && board.GetBuilding(x, y) == 0) { //Check that  the space is empty.
          board.PlaceCounter(x, y); 
          state = GameState.Construction;
          
          turn++;
          activeplayer++;
          if (activeplayer == players.length) {
             activeplayer = 0; 
          }
       }
       return;
      
     case Construction:
       if (board.GetBuilding(x, y) > 0) {
          state = GameState.Consumption;
          board.SetActiveBuilding(x, y);
          return;
       }
       
       if (board.CanPlaceBuilding(x, y)) {
         board.PlaceBuilding(x, y);
         
         if (turn > 1) {
             state = GameState.Conception;
          } else {
             turn++;
             activeplayer++;
            if (activeplayer == players.length) {
               activeplayer = 0; 
            }
          }
       }
       
     return;
     
     case Consumption:
    
      //The resources have been selected.
      if (board.IsActiveBuilding(x, y)) {
        
        int resourcecount = board.NumberOfSelectedResources();
      
        if (resourcecount != board.ActiveBuilding()) {
           state = GameState.Construction;
           board.ClearSelection();
           board.SetActiveBuilding(-1, -1);
           return;
        }
        
        players[activeplayer] += resourcecount;
        
        board.AbsorbResources();
        board.ClearSelection();
        board.SetActiveBuilding(-1, -1);
        state = GameState.Conception;
    } else {
      
      board.SelectResource(x, y); 
      
    }
   }
  }
  
  void draw() {
     board.draw(state == GameState.Conception);
     
     String text = "Player "+String.valueOf(activeplayer+1)+": ";
   
   switch (state) {
      case Construction:
        text += "Place/upgrade your buildings!";
        break;
      case Consumption:
        text += "Select resources to upgrade!";
        break;
      case Conception:
        text += "Place your resource.";
        break;
   }
   
   //Message.
   textSize(42);
   fill(color(255,255,255));
   text(text, 0, 9*50);
   
   text("Points:", 0, 10*50);
   text("Player 1: "+String.valueOf(players[0]), 0, 11*50);
    text("Player 2: "+String.valueOf(players[1]), 0, 12*50);
  }
}