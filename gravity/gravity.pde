int num = 25; //볼의 갯수
//선언
Ball[] balls = new Ball[num];

void setup() {
  size(500, 500);
  background(0);
  //객체 생성 - 갯수만큼 반복된다.
  for (int i = 0; i < balls.length; i++) {
    balls[i] = new Ball();
  }
}

void draw() {
  background(0);
  //객체 동작 - 갯수만큼 반복한다.
  for (int i = 0; i < balls.length; i++) {
    balls[i].update();
    balls[i].display();
  }
}


//클래스
class Ball {
  float x;
  float y;
  float w;
  float g;
  float speedx;
  float speedy;
  color c;
  
  //생성자
  Ball(){
    x = random(width); //x축 아무데서나 시작
    y = random(20, 300);
    w = random(5, 35);
    g = random(0.1, 0.2);
    speedx = random(-2, 2);
    speedy = 0;
    c = color(random(255), random(255), random(255));
  }
  void update() {
    x = x + speedx;
    y = y + speedy;
    
    speedy = speedy + g; //중력을 더해 준다.
    
    if (x > width - w/2 || x < w/2) {
      speedx = speedx * -1; //반전
    }
    if (y > height - w/2 ) {
      speedy = speedy * -0.95; //볼의 에너지를 감소 시킨다.
    }
  }
  
  
  void display() {
    noStroke();
    fill(c, 180); //투명도를 줌
    ellipse(x, y, w, w);
    
    //infomation
    textAlign(CENTER);
    textSize(9);
    fill(0, 255, 0, 200);
    //text("y : " + y, x, y);
    text(speedy, x, y - w);
  }
}
