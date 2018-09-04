void setup()
{
   size(400, 400);
   ellipseMode(RADIUS);
   background(0);
   stroke(255);
   frameRate(5);
}

void draw()
{
    fill(random(255), random(255), random(255), 50);
    
    for(int i=0; i<12; i++) {
      float theta = radians(i*30);
      ellipse(cos(theta)*100+200, sin(theta)*100+200, 100, 100);
    }
}