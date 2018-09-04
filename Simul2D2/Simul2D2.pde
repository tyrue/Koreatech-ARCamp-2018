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

int A0 = 90;
int A1 = 120;
int A2 = 180;
  
void draw()
{
  if (myClient.available() > 0) { 
    String str = myClient.readStringUntil(']');
    if(str == null) return;
    
    myClient.write("RX:" + str);
    
    String[] list = splitTokens(str, "[, ]");
    
    A0 = int(list[0]);
    A1 = int(list[1]);
    A2 = int(list[2]);
  } 
  
  drawArm(A1, A2);
}

void drawArm(int A1, int A2)
{
  background(100);
  strokeWeight(5 * scale);
  stroke(255, 255, 0, 100);
  fill(255, 255, 0);
  
  pushMatrix();
  translate(0, height-40*scale);
  line(0, 0, a, 0);
  translate(a, 0);
  rotate(radians(180+A1));
    line(0, 0, b, 0);
    pushMatrix();
    translate(b, 0);
    rotate(radians( - (A2 + A1)));
      line(0, 0, c, 0);
      pushMatrix();
      translate(c, 0);
      rotate(radians(180+A2));
        line(0, 0, d, 0);
      popMatrix();
    popMatrix();
  popMatrix();
}