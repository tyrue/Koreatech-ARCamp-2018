import processing.video.*;
import jp.nyatla.nyar4psg.*;
Capture cam;
MultiMarker nyAR;

void setup(){
  size(640, 480, P3D);
  cam = new Capture(this, width, height, "HD 720P Webcam");
  nyAR = new MultiMarker(this, width, height, 
        "data/camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nyAR.addARMarker("data/patt.hiro", 80);
  cam.start();
}

void draw(){
  if (cam.available() == false) return;
  cam.read();
  
  nyAR.detect(cam);
  background(0);
  nyAR.drawBackground(cam);
    
  if(nyAR.isExist(0)) {
    nyAR.beginTransform(0);
    drawSphere();
    nyAR.endTransform();
  }
}

void drawSphere() {
  stroke(0, 255, 0, 150);
  strokeWeight(2);
  
  pushMatrix();
  translate(0, 0, 150);
  rotateX(mouseY * 0.05);
  rotateY(mouseX * 0.05);
  
  noFill();
  sphereDetail(20, 20);
  sphere(50);
  popMatrix();
}