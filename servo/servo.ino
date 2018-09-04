#include <Servo.h> 
#include <MsTimer2.h>

Servo axis;
struct {
  int now, dst;
  int spd;
} servo = {85, 90, 1};

void setup(){
  Serial.begin(57600);
  axis.attach(6);
  MsTimer2::set(25, ServoControl); 
  MsTimer2::start();
}

void loop(){
  if(Serial.available()) {
    char buf[64] = {0};
    int len = Serial.readBytesUntil(']', buf, 64);

    if(buf[0] == '[' && buf[1] == 'I') {
      int id, pos, spd;  
      char *p;
      
      p = strtok(&buf[1], ",");
      if(p && *p == 'I') id = atoi(p+1);
      p = strtok(NULL, ",");
      if(p && *p == 'P') pos = atoi(p+1);
      p = strtok(NULL, ",");
      if(p && *p == 'S') spd = atoi(p+1);

      servo.dst = pos;
      servo.spd = spd;
    }
  }
}

void ServoControl(void)
{
  if(servo.dst < servo.now){
    servo.now -= servo.spd;
    axis.write(servo.now);
  }
  else if(servo.dst > servo.now){
    servo.now += servo.spd;
    axis.write(servo.now);
  }
}

