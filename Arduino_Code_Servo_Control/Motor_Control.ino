// connect motor controller pins to Arduino digital pins
// motor one
int enA = 3;
int in1 = 4;
int in2 = 2;
// motor two
int enB = 5;
int in3 = 7;
int in4 = 6;
// motor three
int enC = 10;
int in5 = 9;
int in6 = 8;
void setup() {
 // set all the motor control pins to outputs
 pinMode(enA, OUTPUT);
 pinMode(enB, OUTPUT);
 pinMode(enC, OUTPUT);
 pinMode(in1, OUTPUT);
 pinMode(in2, OUTPUT);
 pinMode(in3, OUTPUT);
 pinMode(in4, OUTPUT);
 pinMode(in5, OUTPUT);
 pinMode(in6, OUTPUT); 
 }
void demoOne() {
 // this function will run the motors in both directions at a fixed speed
 // turn on motor A
 digitalWrite(in1, LOW);
 digitalWrite(in2, HIGH);
 // set speed to 200 out of possible range 0~255
 //analogWrite(enA, 0);
 analogWrite(enA, 28);
 // turn on motor B
 digitalWrite(in3, LOW);
 digitalWrite(in4, LOW);
 // set speed to 200 out of possible range 0~255
 //analogWrite(enB, 0);
 analogWrite(enB, 35);
  // turn on motor B
 digitalWrite(in5, LOW);
 digitalWrite(in6, HIGH);
 // set speed to 200 out of possible range 0~255
 analogWrite(enC, 31);
 //analogWrite(enC, 28);
 delay(100);
 digitalWrite(in1, LOW);
 digitalWrite(in2, LOW);
 digitalWrite(in3, LOW);
 digitalWrite(in4, LOW);
 digitalWrite(in5, LOW);
 digitalWrite(in6, LOW);
 delay(500);
 // now change motor directions
 digitalWrite(in1, HIGH);
 digitalWrite(in2, LOW);
 digitalWrite(in3, HIGH);
 digitalWrite(in4, LOW);
 digitalWrite(in5, LOW);
 digitalWrite(in6, LOW);
 delay(100);
 // now turn off motors
 digitalWrite(in1, LOW);
 digitalWrite(in2, LOW);
 digitalWrite(in3, LOW);
 digitalWrite(in4, LOW);
 digitalWrite(in5, LOW);
 digitalWrite(in6, LOW);
 delay(500);
  // now change motor directions
 digitalWrite(in1, LOW);
 digitalWrite(in2, LOW);
 digitalWrite(in3, LOW);
 digitalWrite(in4, HIGH);
 digitalWrite(in5, HIGH);
 digitalWrite(in6, LOW);
 delay(100);
 // now turn off motors
 digitalWrite(in1, LOW);
 digitalWrite(in2, LOW);
 digitalWrite(in3, LOW);
 digitalWrite(in4, LOW);
 digitalWrite(in5, LOW);
 digitalWrite(in6, LOW);
 delay(500);}

 void loop()
{
 demoOne();
}


