void setup() {
  size(300, 300, P3D); 
}

void draw() {
  background(0);
  
  stroke(0, 255, 0, 150);
  strokeWeight(2);
  
  translate(150, 150, 0);
  rotateX(mouseY * 0.05);
  rotateY(mouseX * 0.05);
  
  noFill();
  sphereDetail(20, 20);
  sphere(100);
}