import processing.net.*;
import processing.video.*;
import jp.nyatla.nyar4psg.*;

Client sock;
Capture cam;
MultiMarker nyAR;

PFont font;
PVector [] tr;
int trNow = 0;

MARK toolA;
RBUTTON button1;

float scale = 12.0/12.0;

int currWidth, currHeight;
boolean windowSized = false;

void pre() {
  if (currWidth != width || currHeight != height) {
    button1.setPos(20, height-100+20);
    currWidth = width;
    currHeight = height;
  }
}

void setup()
{
  size(640, 480, P3D);
  frame.setResizable(true);
  registerMethod("pre", this);
 
  sock = new Client(this, "127.0.0.1", 12000); 
  font = createFont("FFScala", 24);
  
  String[] cameras = Capture.list();  
  for(String camName : cameras) println(camName);
  
  cam = new Capture(this, width, height, "HD 720P Webcam");
  nyAR = new MultiMarker(this, width, height, "data/camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nyAR.addARMarker("data/patt.hiro", 80);
  
  cam.start();
  
  tr = new PVector[100];
  for(int i=0; i<tr.length; i++)  tr[i] = new PVector(999, 999, 999);
  
  toolA = new MARK(150, -50, 70, 80, 100, 50, "create");
  
  toolA.setScale(scale);
  
  button1 = new RBUTTON(20, height-100+20, 120, 30, "create");
  
  if(sock != null) {
    button1.SetEvent(sock, "mission:1"); // 소켓에 미션1을 보냄
  }
  
  frameRate(60);
}

int move_x = 0, move_y = 0, move_z = 30;
boolean ro = false;
Wall w = new Wall(0, 0, 0);

void draw()
{
  if (sock.available() > 0) {
    String str = sock.readStringUntil(']'); 
   
    if(str != null) {
      if(str.indexOf('[') == 0 && str.indexOf(']') > 0) {
        String[] list = splitTokens(str, "[, ]");
      
        A0 = int(list[0])+5;
        A1 = int(list[1])+5;
        A2 = int(list[2])+5;
      }
    }
  }
  
  if (cam.available() == false) return; // 카메라를 사용 못하면 끝
  
  cam.read();
  
  nyAR.detect(cam);
  background(0);
  nyAR.drawBackground(cam);
    
  if(nyAR.isExist(0)) // 여기서 모든 것을 그림, 한 프레임마다
  {
    nyAR.beginTransform(0);
    
    drawCoordinate(); // xyz 좌표
    drawRobot(A0, A1, A2); // 로봇팔
    toolA.show();  // 마크 1

    w.drawWall();
    if(ro == false)
    {
      int tx = -250, ty = -230, tz = 80;
      w.trans(move_x, move_y, 30);
      move_x -= 2; move_y -= 2;
      if(move_x > 300 || move_x < -300)
      {
        move_x = 0;
      }
      if(move_y > 300 || move_y < -300)
      {
        move_y = 0;
        ro = true;
      }
      drawHouse(tx, ty, tz); // 집 그림
    }
    else
    {
      int tx = -250, ty = -230, tz = 80;
      w.trans(-300, -300, move_z);
      
      if(move_z > 300) 
      {
        move_z = 30;
        ro = false;
      }
      drawHouse(tx, ty, tz + move_z); // 집 그림
      drawFlower(400, 200, move_z - 30);
      move_z += 10;
    }
    nyAR.endTransform();
  }
  
  button1.drawButton(mouseX, mouseY, mousePressed);
}

void drawCoordinate() // xyz 좌표 만드는 함수
{
  noFill();
  stroke(100,0,0);
  rect(-40,-40,80,80);
  
  stroke(0, 0, 255);
  strokeWeight(2);
  fill(255, 0, 0);
  line(0,0,0,100,0,0);
  textFont(font,20.0); text("X",100,0,0);
  line(0,0,0,0,100,0);
  textFont(font,20.0); text("Y",0,100,0);
  line(0,0,0,0,0,100);
  textFont(font,20.0); text("Z",0,0,100);
 
}

float a = 10 * scale;
float b = 80 * scale;
float c = 80 * scale;
float d = 55 * scale;

float A0 = 90;
float A1 = 120;
float A2 = 180;

float xoff = 120, yoff = 120, zoff = 55;

int m = 0;

void drawRobot(float A0, float A1, float A2) // 로봇팔
{
  PVector p1 = new PVector(xoff*scale, yoff*scale, 0);
  PVector p2 = new PVector(0, 0, zoff*scale);

  float a0 = radians(A0);
  float a1 = radians(A1);
  float a2 = radians(A2);

  PVector p3 = new PVector(a*cos(-a0), a*sin(-a0), 0); 
  PVector p4 = new PVector(-b*cos(a1)*cos(-a0), b*cos(a1)*sin(a0), b*sin(a1));
  PVector p5 = new PVector(-c*cos(a2)*cos(-a0), c*cos(a2)*sin(a0), -c*sin(a2)); 
  PVector p6 = new PVector(d*cos(-a0), d*sin(-a0), 0);
  
  p2.x += p1.x;  p2.y += p1.y;  p2.z += p1.z;
  p3.x += p2.x;  p3.y += p2.y;  p3.z += p2.z;
  p4.x += p3.x;  p4.y += p3.y;  p4.z += p3.z;
  p5.x += p4.x;  p5.y += p4.y;  p5.z += p4.z;
  p6.x += p5.x;  p6.y += p5.y;  p6.z += p5.z;

  stroke(255);
  strokeWeight(1);

  pushMatrix();
  translate(xoff*scale, yoff*scale, 0);
  rotateZ(radians(-A0));
  fill(255, 0, 0, 70);
  rect(-25, -25, 50, 50);  //  base rect
  //line(0, 0, a, 0);
  translate(0, 0, zoff*scale);
  
  pushMatrix();  // for 1st box
  translate(0, 0, -20*scale);
  fill(0, 0, 255, 50);
  box(50*scale, 50*scale, 40*scale);
  popMatrix();
  
    pushMatrix();
    translate(a, 0, 0);
    rotateY(radians(180+A1));
    //line(0, 0, b, 0);
        
    pushMatrix();  // 2nd bor box
    translate(b/2, 0, 0);
    fill(255, 255, 0, 50);
    box(b, 20, 10);
    popMatrix();
    
      pushMatrix();
      translate(b, 0, 0);
      rotateY(radians(-(A2+A1)));
      //line(0, 0, c, 0);
        
      pushMatrix();  // 3rd box
      translate(c/2, 0, 0);
      fill(255, 0, 0, 50);
      box(c, 20, 10);
      popMatrix();  
      
        pushMatrix();
        translate(c, 0, 0);
        rotateY(radians(180+A2));
        
          pushMatrix();  // 4th box
          translate(d/2, 0, 0);
          fill(255, 0, 255, 50);
          box(d, 20, 10);
          popMatrix();
          //line(0, 0, d, 0);
        popMatrix();
        
      popMatrix();
    
    popMatrix();
    
  popMatrix();
  
  stroke(0, 255, 0);
  line(0, 0, 0, p1.x, p1.y, p1.z);
  line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  line(p2.x, p2.y, p2.z, p3.x, p3.y, p3.z);
  line(p3.x, p3.y, p3.z, p4.x, p4.y, p4.z);
  line(p4.x, p4.y, p4.z, p5.x, p5.y, p5.z);
  line(p5.x, p5.y, p5.z, p6.x, p6.y, p6.z);
  
  tr[trNow] = p6;
  
  for(int i=0; i<(tr.length-1); i++) {
    stroke(200, 0, 200);
    PVector t1 = tr[(tr.length + trNow - i) % tr.length];
    PVector t2 = tr[(tr.length + trNow - (i + 1)) % tr.length];
    
    if(t2.x != 999) line(t1.x, t1.y, t1.z, t2.x, t2.y, t2.z);
  }  
  
  trNow = (trNow + 1) % tr.length;
}

void drawHouse(int x, int y, int z)
{
  pushMatrix();
  float a = radians(155);
  rotateZ(a);
  translate(x - 50, y, z);
  fill(0, 0, 255, 50);
  box(40, 120, 100);
  popMatrix();
    
  pushMatrix();
  rotateZ(a);
  translate(x, y + 40, z);
  fill(0, 0, 255, 50);
  box(60, 40, 100);
  popMatrix();
  
  pushMatrix();
  rotateZ(a);
  translate(x, y - 40, z);
  fill(0, 0, 255, 50);
  box(60, 40, 100);
  popMatrix();
  
  pushMatrix();
  rotateZ(a);
  translate(x, y, z + 60);
  fill(255, 0, 0, 50);
  box(100, 100, 20);
  popMatrix();
  
  pushMatrix();
  rotateZ(a);
  translate(x + 20, y + 20, z + 80);
  fill(0, 255, 0, 50);
  box(20, 20, 30);
  popMatrix();
  
  pushMatrix();
  drawSphere(- x + 20,  - y + 20, z + 100 + move_z);
  popMatrix();
}

void drawSphere(int x, int y, int z) // 공만드는 함수
{
  stroke(0, 255, 0, 150);
  strokeWeight(2);
  
  pushMatrix();
  translate(x, y, z);
  rotateX(mouseY * 0.05);
  rotateY(mouseX * 0.05);
  
  noFill();
  sphereDetail(20, 20);
  sphere(10);
  popMatrix();
}

class Wall
{
  int x;
  int y;
  int z;
  Wall(int _x, int _y, int _z)
  {
    x = _x;
    y = _y;
    z = _z;
  }
  void trans(int _x, int _y, int _z)
  {
    x = _x;
    y = _y;
    z = _z;
    if(x > 300 || x < -300) x = 0;
    if(y > 300 || y < -300) y = 0;
    if(z > 300|| z < -300) z = 0;
  }
  
  void drawWall()
  {
    pushMatrix();
    rotateZ(radians(135));
    translate(x + 150, y - 50, z + 70);
    fill(0, 0, 255, 50);
    box(40, 120, 100);
    popMatrix();
  }
}

void drawFlower(int x, int y, int z)
{
  fill(random(255), random(255), random(255), 50);
  pushMatrix();
  translate(x, y, z);
  
  for(int i = 0; i < 12; i++) {
    float theta = radians(i*30);
    pushMatrix();
      rotate(theta);
      translate(40, 0);
      ellipse(0, 0, 40, 40); // x, y, w, h
    popMatrix();
  }
  popMatrix();
}
