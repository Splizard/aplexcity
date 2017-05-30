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

void setup() {
  size(800,600);
}

void mousePressed() {
  //Determine board coordinates.
  int x = (int)(mouseX/50.0);
  int y = (int)(mouseY/50.0);
  
  //Outside of the board.
  if (x > 8 || y > 8) {
    return;
  }
  
  game.mousePressed(x, y);
}

void draw() {
   clear();
   game.draw();
}