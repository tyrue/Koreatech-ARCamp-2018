import processing.net.*;

Client myClient;

float scale = 2;

float a = 10 * scale;
float b = 80 * scale;
float c = 80 * scale;
float d = 55 * scale;

void setup()
{
  size(400, 300);
  
  myClient = new Client(this, "127.0.0.1", 12000); 
}

float A0 = radians(90);
float A1 = radians(120);
float A2 = radians(180);
  
void draw()
{
  if (myClient.available() > 0) { 
    String str = myClient.readStringUntil(']'); 
    myClient.write("RX:" + str);
    
    String[] list = splitTokens(str, "[, ]");
    
    A0 = radians(int(list[0]));
    A1 = radians(int(list[1]));
    A2 = radians(int(list[2]));
  } 
  
  drawArm(A1, A2);
}

void drawArm(float A1, float A2)
{
  background(100);
  strokeWeight(5 * scale);
  stroke(255, 255, 0, 100);
  fill(255, 255, 0);

  PVector p0 = new PVector(0.0, height-40*scale);
  PVector p1 = new PVector(a, 0.0);
  PVector p2 = new PVector(-b*cos(A1), -b*sin(A1));
  PVector p3 = new PVector(-c*cos(A2), +c*sin(A2));
  PVector p4 = new PVector(d, 0.0);
   
  p1.x += p0.x;  p1.y += p0.y;
  p2.x += p1.x;  p2.y += p1.y;
  p3.x += p2.x;  p3.y += p2.y;
  p4.x += p3.x;  p4.y += p3.y;
  
  line(p0.x, p0.y, p1.x, p1.y);
  line(p1.x, p1.y, p2.x, p2.y);
  line(p2.x, p2.y, p3.x, p3.y);
  line(p3.x, p3.y, p4.x, p4.y);
}