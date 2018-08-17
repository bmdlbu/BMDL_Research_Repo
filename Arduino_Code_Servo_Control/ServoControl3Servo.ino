#include <Servo.h>  //servo header

Servo servo1;
Servo servo2;
Servo servo3;
const int buttonPin1 = 3;     // the number of the pushbutton pin
int servo1_Pin = 9; //sets the servo to pin 9
int servo2_Pin = 8; //sets the servo to pin 9
int servo3_Pin = 7; //sets the servo to pin 9
int buttonState = 0;   
int initial_position = 0;
 

 
void setup()
{
  pinMode(buttonPin1, INPUT);
  pinMode(servo1_Pin, OUTPUT);
  pinMode(servo2_Pin, OUTPUT);
  pinMode(servo3_Pin, OUTPUT);
  Serial.begin(9600);  
  servo1.attach(servo1_Pin);
  servo1.write(initial_position); //starts the servo at 90 to start off with
  servo2.attach(servo2_Pin);
  servo2.write(initial_position); //starts the servo at 90 to start off with
  servo3.attach(servo3_Pin);
  servo3.write(initial_position); //starts the servo at 90 to start off with
}
 
 
void loop()
{
  buttonState = digitalRead(buttonPin1);
  if (buttonState == HIGH) 
  {
    servo1.write(45);
    servo2.write(0);
    servo3.write(0);
    delay(1000);
  }
  buttonState = digitalRead(buttonPin1);
  if (buttonState == HIGH) 
  {
    servo1.write(0);
    servo2.write(45);
    servo3.write(0);
    delay(1000);
  }
  buttonState = digitalRead(buttonPin1);
  if (buttonState == HIGH) 
  {
    servo1.write(0);
    servo2.write(0);
    servo3.write(45);
    delay(1000);
  }
}
