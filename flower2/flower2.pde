void setup()
{
  size(400, 400);
  ellipseMode(RADIUS);
  background(0);
  stroke(255);
  frameRate(5);
}

int i = 0;
void draw()
{
  fill(random(255), random(255), random(255), 50);
  pushMatrix();
  translate(200, 200);
  
  for(int i=0; i<12; i++) {
    float theta = radians(i*30);
    pushMatrix();
      rotate(theta);
      translate(100, 0);
      ellipse(0, 0, 100, 100);
    popMatrix();
  }
  popMatrix();
}