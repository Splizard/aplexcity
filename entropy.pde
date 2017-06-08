color empty  = color(0, 0, 0, 0);
color black  = color(0, 0, 0);
color white  = color(255, 255, 255);
color red    = color(255, 0, 0);  
color green  = color(0, 255, 0); 
color blue   = color(0, 0, 255);  
color yellow = color(255, 255, 0); 
color pink   = color(255, 0, 255);
color purple = color(100, 0, 145);
color orange = color(255, 130, 0);
color brown  = color(100, 50, 0);

color[] types = {black, white, red, green, blue, yellow, pink, purple, orange, brown};

Game game = new Game();

   PImage blackToken;
   PImage whiteToken;
   PImage redToken;
   PImage greenToken;
   PImage blueToken;
   PImage yellowToken;
   PImage pinkToken;
   PImage purpleToken;
   PImage orangeToken;
   PImage brownToken;

void setup() {
  //size(800,600);
  fullScreen();
        
  blackToken = loadImage("LandPollution.png");
  whiteToken = loadImage("White.png");
  redToken = loadImage("Fire.png");
  greenToken = loadImage("Nature.png");
  blueToken = loadImage("Water.png");
  yellowToken = loadImage("Electricity.png");
  pinkToken = loadImage("People.png");
  purpleToken = loadImage("Technology.png");
  orangeToken = loadImage("Explosives.png");
  brownToken = loadImage("WaterPollution.png");
  
}

void mousePressed() {
     loop();
  if (mouseX > width-150 && mouseY <  52) {
     game = new Game(); 
     return;
  }
  
    
  //Determine board coordinates.
  int x = (int)((mouseX/1.5 - 100)/50.0);
  int y = (int)((mouseY/1.5 - 50)/50.0);
  
  if (mouseX > 800 && mouseY < 52 && mouseX < 1000) {
     try {
      game.mousePressed(x, y);
    } catch (Exception e) {
     println("error!");
    }
  }
  
  if (mouseX < 100) return;
  if (mouseY < 50) return;

  
  //Outside of the board.
  if (x > 7 || y > 7 || x < 0 || y < 0) {
    return;
  }
  
  
  try {
    game.mousePressed(x, y);
  } catch (Exception e) {
     println("error!");
  }
}

void draw() {
   clear();
   pushMatrix();
   scale(1.5);
   translate(100, 50);
   game.draw();
   popMatrix();
   
   textSize(42);
   fill(color(255,255,255));
    text("Restart", width-150, 52);
    
    text("Skip stage", 800, 52);
}