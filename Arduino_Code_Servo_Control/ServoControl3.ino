#include <Servo.h>  //servo header

const int buttonPin = 2;     // the number of the pushbutton pin
int servoPin = 9; //sets the servo to pin 9
int buttonState = 0;   
Servo servo;  
 

 
void setup()
{
  pinMode(buttonPin, INPUT);
  pinMode(servoPin, OUTPUT);
  Serial.begin(9600);  
  servo.attach(servoPin);
  servo.write(90); //starts the servo at 90 to start off with
}
 
 
void loop()
{
  buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH) 
  {
    servo.write(0);
    delay(1000);
  }
  buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH) 
  {
    servo.write(90);
    delay(1000);
  }
  buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH) 
  {
    servo.write(180);
    delay(1000);
  }
}
