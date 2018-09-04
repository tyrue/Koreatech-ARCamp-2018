#include <Servo.h> 
#include <MsTimer2.h>

Servo axis[4];

struct {
  int now;
  int dst;
} servo[4] = {{85, 90},{85, 90},{130, 135},{130, 135},};

int intv = 0;
bool bSend = false;

void ServoControl(void)
{
  for(int i=0; i<4; i++) {
    if(servo[i].dst < servo[i].now)
      axis[i].write(--servo[i].now);
    else if(servo[i].dst > servo[i].now)
      axis[i].write(++servo[i].now);
  }

  if(++intv == 4) {
    bSend = true;
    intv = 0;
  }
}

void setup() 
{
  Serial.begin(57600);
  
  axis[0].attach(6);
  axis[1].attach(10);
  axis[2].attach(9);
  axis[3].attach(12);

  Serial.write("ROBOT ARM F/W ver. 0.1\n\n");

  MsTimer2::set(25, ServoControl); 
  MsTimer2::start();
}



void loop() 
{
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

      servo[id].dst = pos;
    }
  }

  if(bSend == true) {
     char buf[20] = {0};
     sprintf(buf, "[%d,%d,%d]", servo[0].now, servo[1].now, servo[2].now);
     Serial.write(buf);
     bSend = false;
  }
}



