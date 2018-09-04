class RBUTTON {
  int x = 20, y = 20, w = 120, h = 30;
  String text;
  boolean oldMousePressed;
  Client sock;
  String command;
  
  RBUTTON(int rx, int ry, int rw, int rh, String text) 
  {
      x = rx;
      y = ry;
      w = rw;
      h = rh;
      this.text = text;
      
      sock = null;
  }

  void setPos(int rx, int ry) 
  {
    x = rx;
    y = ry;
  }
  
  boolean isMouseOver(int mx, int my)
  {
    if(mx > x && mx < (x+w) && my > y && my < (y + h)) return true;
    return false;
  }

  void drawButton(int mx, int my, boolean bMousePressed) 
  {  
    boolean bMouseOver = isMouseOver(mx, my);
    
    if(bMouseOver)
      fill(255, 255, 0);
    else
      noFill();
      
    stroke(255, 255, 0);
    strokeWeight(3);
    rectMode(CORNER);
    rect(x, y, w, h, 3);
    
    if(bMouseOver)
      fill(0);
    else
      fill(255, 255, 0);
    textAlign(CENTER, CENTER);
    textSize(24);
    text(text, x + w/2, y +  h/2 - 5);
    
    if(bMouseOver && oldMousePressed == true && bMousePressed == false) {
        println(text + ": clicked");
        if(sock != null) sock.write("*" + command + "$");
    }
      
    oldMousePressed = bMousePressed;
  }
  
  void SetEvent(Client sock, String cmd)
  {
    this.sock = sock;
    command = cmd;
  }
}