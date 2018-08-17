#include <stdio.h>
#include <unistd.h>
#include <wiringPi.h>

/* Motor Ports: 25, 28, 29 */

/* Setting up the motor ports for output */
int setupMotor(int pinNumber);

int shiftBlocker(int pinNumber, int pinMode) {
    /* Initializing the count of cycles */
    int i;
        
    /* Creating the loop to keep the the blocker open */
    for (i=0; i < 20; i++ ) {
        digitalWrite(pinNumber, HIGH);
        usleep(700);
        digitalWrite(pinNumber, LOW);
        usleep(18*1000);

    }

    return 0;
}

