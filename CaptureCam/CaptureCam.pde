import processing.net.*;
import processing.video.*;
Capture cam;

void setup()
{
  size(640, 480, P3D);
  
  String[] cameras = Capture.list();  
  for(String camName : cameras) println(camName);
  cam = new Capture(this, width, height, "HD 720P Webcam");
  cam.start();
}
void draw(){
  if (cam.available()) {     // Reads the new frame
    cam.read(); 
  } 
  image(cam, 0, 0); 
}