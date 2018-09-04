//선언
int numBalls = 100;
Ball[] balls = new Ball[numBalls]; //Ball list

void setup() {
  size(500, 500);
  smooth();
  //객체 초기화 - 각각 다른 크기와 색상의 Ball 오브젝트를 만들어 리스트에 집어 넣는다.
  for (int i = 0; i < balls.length; i++) {
    balls[i] = new Ball(random(150, width - 150), 
              random(10, height),
              random(2, 30),
              color(random(255), random(255), random(255)),
              i, balls);
  }
}

void draw() {
  background(0);
  //동작
  for (int i = 0;  i < balls.length; i++) {
    
    balls[i].update();
    balls[i].collide();
    balls[i].display();
    
  }
}



//클래스
class Ball {
  
  float x;
  float y;
  float w; //볼크기
  color c; 
  Ball[] others;
  float vx =  0.01;
  float vy = 0.01;
  int id;

  Ball(float _x, float _y, float _w, color _c, int idin, Ball[] oin) {
    x = _x;
    y = _y;
    w = _w;
    c = _c;
    id = idin;
    others = oin;
  }
  
  //충돌
  void collide() {
    for (int i = id + 1; i < numBalls; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].w/2 + w/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x);
        float ay = (targetY - others[i].y);
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }   
  }
  
  void update() {
    x += vx;
    y += vy;
    println(vx);
    if (x > width - w/2 || x < 0 + w/2) { 
      vx = vx * -1;
      if (vx > 5.0 || vx < -5.0){
        vx *= 0.001;
      }
    }
    
    if(y > height - w/2 || y < 0 + w/2) {
      vy = vy * -1;
      if (vy > 5.0 || vy < -5.0) {
        vy *= 0.001;
      }
    }
  }
  
  void display(){
    noStroke();
    fill(c);
    ellipse(x, y, w, w);  
  }
}
