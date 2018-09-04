class MARK {
  float x = 0, y = 0, z = 0;
  float r = 1, theta = 0;
  float w = 1, h = 1;
  float scale = 1.0;
  String textStr = "";
  
  PGraphics pg;
  
  MARK(){
    init(0, 0, 0, 1, 1, 1, ""); 
  }
  
  MARK(float _x, float _y, float _z, float _r, float _w, float _h, String _text) {
    init(_x, _y, _z, _r, _w, _h, _text);
  }
  void init(float _x, float _y, float _z, float _r, float _w, float _h, String _text) {
    x = _x;    y = _y;    z = _z;
    r = _r;
    w = _w;    h = _h;
    textStr = _text;
    
    pg = createGraphics(int(w)+4, int(h)+4);
    pg.beginDraw();
    pg.pushMatrix();
    pg.translate(w/2, h/2);
    
    pg.stroke(0, 255, 0);
    pg.strokeWeight(3);
    
    pg.fill(0, 0, 0, 50);
    pg.rectMode(CENTER);
    pg.rect(0, 0, w, h, 5);
     
    pg.fill(0, 255, 0);
    pg.textAlign(CENTER, CENTER);
    pg.textSize(24);
    pg.text(textStr, 0, 0);
    
    pg.popMatrix();
    pg.endDraw();
  }
  void setScale(float scale){
    this.scale = scale;
  }
  void show() {
    pushStyle();
    
    stroke(0, 255, 0, 90);
    strokeWeight(3);
    
    pushMatrix();
    translate(x*scale, y*scale, 0);
    
      pushMatrix();
      translate(0, 0, z*scale);
      rotateX(-radians(90));
      rotateY(-radians(90));
      
      // use double buffering! ==> refer to PGraphics 
      //fill(0, 0, 0, 50);
      //rectMode(CENTER);
      //rect(0, 0, w*scale, h*scale, 5);
      
      //fill(0, 255, 0);
      //textAlign(CENTER, CENTER);
      //textSize(24);
      //text(textStr, 0, 0);
      
      imageMode(CENTER);
      image(pg, 0, 0, w*scale, h*scale);
      
      popMatrix();
      
    rotate(radians(theta++));
    
    noFill();
    ellipse(0, 0, r*scale, r*scale);
    line(0, 0, r/2*scale, 0);
    
    final int interval = 4;
    noStroke();
    fill(0, 255, 0);
    for(int i=0; i<interval; i++) {
      rotate(i * radians(360/interval));
      pushMatrix();
        translate(r/2 + 5, 0, 0);
        triangle(15, 0, 5, 4, 5, -4);
      popMatrix();
    }
       
    popMatrix();
    popStyle();
  }
}
  