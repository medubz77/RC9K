#include <Servo.h>

Servo rll;   //rear left lower      Leg 0
Servo rlm;   //rear left middle
Servo rlu;   //rear left upper

Servo rrl;    //right right        Leg 1
Servo rrm;
Servo rru;

Servo mll;  //middle left         Leg 2
Servo mlm;
Servo mlu;

Servo mrl;  //middle right        Leg 3
Servo mrm;
Servo mru;

Servo fll;   //front left          Leg 4
Servo flm;
Servo flu;

Servo frl;   //front right        Leg 5
Servo frm;
Servo fru;

void setup()
{
 
rll.attach(22);
rlm.attach(24);
rlu.attach(26);

rrl.attach(46);
rrm.attach(48);
rru.attach(50);

mll.attach(34);
mlm.attach(36);
mlu.attach(38);

mrl.attach(40);
mrm.attach(42);
mru.attach(44);

fll.attach(28);
flm.attach(30);
flu.attach(32);

frl.attach(52);
frm.attach(2);
fru.attach(3);
  
  
  
  
 Serial.begin( 115200);
 while(!Serial)
 {
 }
 //Leg(x,xxx,xxx,xxx)Leg(leg number, upper, middle, lower)
 //123456789012345678 
}
void loop()
{
String serin="";
if (Serial.available())
{
  serin=Serial.readStringUntil(')') ;
}

if(serin.indexOf("Leg")==0)
{
  String LegNumber=serin.substring(4,5);
  String LegUpper=serin.substring(6,9);
  String LegMiddle=serin.substring(10,13);
  String LegLower=serin.substring(14,17);  //thanks waldo!
  
  //Serial.println(serin);
  int leg=LegNumber.toInt();
  int upper=LegUpper.toInt();
  int middle=LegMiddle.toInt();
  int lower=LegLower.toInt();
 // Serial.println("I am getting Leg " + String(leg) + " Upper " + String(upper) + " Middle " + String(middle) + " Lower " + String(lower));
  WriteToLeg(leg, upper, middle, lower);  
  
}




}

  
void WriteToLeg(int leg, int upper, int middle, int lower)
{
  
switch (leg)
  {
 case 0:  
     rll.writeMicroseconds((lower*10));
     rlm.writeMicroseconds((middle*10));
     rlu.writeMicroseconds((upper*10));
  break;

 case 1:  
     rrl.writeMicroseconds((lower*10));
     rrm.writeMicroseconds((middle*10));
     rru.writeMicroseconds((upper*10));
  break;

 case 2:  
     mll.writeMicroseconds((lower*10));
     mlm.writeMicroseconds((middle*10));
     mlu.writeMicroseconds((upper*10));
  break;

 case 3:  
     mrl.writeMicroseconds((lower*10));
     mrm.writeMicroseconds((middle*10));
     mru.writeMicroseconds((upper*10));
  break;

 case 4:  
     fll.writeMicroseconds((lower*10));
     flm.writeMicroseconds((middle*10));
     flu.writeMicroseconds((upper*10));
  break;

 case 5:  
     frl.writeMicroseconds((lower*10));
     frm.writeMicroseconds((middle*10));
     fru.writeMicroseconds((upper*10));
  break;

  }
 // Serial.println("Wrote to "+String(leg)+ ","+String(upper*10)+","+String(middle*10)+","+String(lower*10));

}




  
  
  
  
  
  

