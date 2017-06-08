public enum GameState {
   Construction, Consumption, Completion, Conception, Combustion, Win, Lose
}

int textsize = 24;

class Game {
  Board board;
  GameState state;
  int turn;
  
  int[] players;
  boolean[] removed;
  int activeplayer;
  
  
  Game() {
    board = new Board(8);
    state = GameState.Construction;
    players = new int[2];
    removed = new boolean[players.length];
  }
  
  void IncrementTurn() {
    
    
    
    turn++;
    activeplayer++;
    if (activeplayer == players.length) {
       activeplayer = 0; 
    }
    
     int lastplayer = activeplayer;
    while (removed[activeplayer]) {
        activeplayer++;
        if (activeplayer == players.length) {
           activeplayer = 0; 
        }
        if (activeplayer == lastplayer) {
           state = GameState.Lose;
           return;
        }
    } 
  }
  
  void mousePressed(int x, int y) {
    
   switch (state) {
     case Conception:
       if (board.GetCounter(x, y) == empty && board.GetBuilding(x, y) == 0) { //Check that  the space is empty.
          board.PlaceCounter(x, y); 
          state = GameState.Combustion;
       }
       return;
      
     case Construction:
       if (x > 7 || y > 7) {
        state = GameState.Conception;
        
        if (board.Full()) {
          removed[activeplayer] = true;
          state = GameState.Construction;
          IncrementTurn();
          return;
        } 
        
        return; 
      }
     
       if (board.GetBuilding(x, y) > 0) {
          state = GameState.Consumption;
          board.SetActiveBuilding(x, y);
          
          if (board.ActiveBuilding() == 0) {
             state = GameState.Construction;
           }
          return;
       }
       
       if (board.CanPlaceBuilding(x, y)) {
         board.PlaceBuilding(x, y);
         
         if (turn > 1) {
             state = GameState.Conception;
             
       
            if (board.Full()) {
              removed[activeplayer] = true;
              state = GameState.Construction;
              IncrementTurn();
              return;
            }  
             
          } else {
             state = GameState.Combustion;
          }
       }
       
     return;
     
     case Consumption:
       if (x < 0 || x > 7 || y < 0 || y > 7) {
          state = GameState.Construction; 
       }
    
      //The resources have been selected.
      if (board.IsActiveBuilding(x, y)) {
        
        int resourcecount = board.NumberOfSelectedResources();
        
        if (resourcecount < 0) {
            if (-resourcecount != board.ActiveBuilding()) {
               state = GameState.Construction;
               board.ClearSelection();
               board.SetActiveBuilding(-1, -1);
               return;
            }
        
            players[activeplayer] += resourcecount;
            players[activeplayer] -= board.BurnResources();
            board.ClearSelection();
            state = GameState.Completion;
        
            return;
        }
      
        if (resourcecount != board.ActiveBuilding()) {
           state = GameState.Construction;
           board.ClearSelection();
           board.SetActiveBuilding(-1, -1);
           return;
        }
        
        players[activeplayer] += resourcecount;
        
        board.AbsorbResources();
        board.ClearSelection();
        state = GameState.Completion;
      } else {
        
        board.SelectResource(x, y); 
        
      }
      break;
      
   case Completion:
     
     if (board.IsActiveBuilding(x, y)) {
       board.CompleteBuilding();
       
       if (board.ActiveBuilding() >= 6) {
           state = GameState.Win;
           return;
       }
       
       board.SetActiveBuilding(-1, -1);
       state = GameState.Conception;
     } else {
       state = GameState.Conception;
       board.SetActiveBuilding(-1, -1);
     }
     
     //When there are 6 buildings on the board, the game is over.
     if (board.CompletedBuildings() >= 6) {
         state = GameState.Win;
     }
     
     if (state == GameState.Conception) {
        if (board.Full()) {
            removed[activeplayer] = true;
            state = GameState.Construction;
            IncrementTurn();
            return;
        }
     }
     
     break;
    
    case Combustion:
    
      if (x >= 7 || y >= 7) {
        state = GameState.Construction;
        IncrementTurn();
        return; 
      }
      
      int reds, oranges, yellows, blues;
      reds = 0;
      oranges = 0;
      yellows = 0;
      blues = 0;
      
      for (int i = 0; i <= 1; i++) {
        for (int j = 0; j <= 1; j++) {
          int counter = board.GetCounter(x+i, y+j);
          
          if (counter == red) reds ++;
          if (counter == orange) oranges ++;
          if (counter == yellow) yellows ++;
          if (counter == blue) blues ++;
          
        }
      }
      
      while (oranges > 0 && yellows > 0) {
          oranges--;
          yellows--;
          reds++;
      }
      
      if (reds > blues) {
         players[activeplayer] -= board.Combust(x, y);
         
         state = GameState.Construction;
      
        IncrementTurn();
      }
   }
  }
  
  void draw() {
     board.draw(state == GameState.Conception);
     
     String text = "Player "+String.valueOf(activeplayer+1)+"'s turn";
     String title = "";
     String rulesLn1 = "";
     String rulesLn2 = "";
   
   switch (state) {
      case Construction:
        title = "Construction Stage";
        rulesLn1 = "Place a building by clicking on the top left\non a 2x2 Square. You cannot place\non fire or pollution.\nClick on a building to upgrade it.";
        break;
      case Consumption:
        title = "Consumption Stage";
        rulesLn1 = "Click on resources around your building, \nyou need to select as many resources \nas the number displayed on the building. Click on the building again to consume them.";
        break;
      case Conception:
        title = "Conception Stage";
        rulesLn1 = "Click to the right of the board to see \nthe resource you need to place. Place this \nin an empty space. If there are \nno empty spaces, you are out of the game.";
        break;
      case Completion:
        title = "Completion Stage";
        rulesLn1 = "Click on a building in order to complete it, \nonce a building is completed, it can no \nlonger consume resources. You need six \ncompleted buildings to end the game.";
        break;
      case Combustion:
        title = "Combustion Stage";
        rulesLn1 = "Click on the top left of a 2x2 square with \n'fire' or 'electricty and explosives'. \nIf there is no water, the resources will be \nremoved and you will lose some points.";
        break;
      case Win:
        if (players[0] > players[1]) {
          text = "Player 1 Won!";
        } else if (players[0] < players[1]) {
          text = "Player 2 Won!";
        } else {
          text = "Tie!";
        }
        break;
      case Lose:
        if (players[0] > players[1]) {
          text = "Player 2 Won!";
        } else if (players[0] < players[1]) {
          text = "Player 1 Won!";
        } else {
          text = "Tie!";
        }
        break;
      
   }
   
   
   
   //Message.
   textSize(42);
   fill(color(255,255,255));
   
   text(title, 0, -12);
   text(text, 0, 9*50);
<<<<<<< HEAD
   text(rulesLn1, 430,450);
   text(rulesLn2, 400,500);
=======
>>>>>>> 0012a060ca8e83c2b091bb4621efe3d353b5681f
   
   textSize(24);
   text("Help:", 500, 450);
   text(rulesLn1, 500,500);
   text(rulesLn2, 500,525);
   
   textSize(42);
   //text("Points:", 0, 10*50);
   text("Player 1 has "+String.valueOf(players[0])+" points", 0, 11*50);
    text("Player 2 has "+String.valueOf(players[1])+" points", 0, 12*50);
  }
}