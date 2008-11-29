#include <WProgram.h>
#include "Collections.h"
#include "EventLoop.h"
#include "Observable.h"


const int GOOD_PIN = 12;
const int BAD_PIN = 13;

int main (int argc, char * const argv[]) 
{
    Serial.begin(9600);
    pinMode(GOOD_PIN, OUTPUT);
    pinMode(BAD_PIN, OUTPUT);

    digitalWrite(BAD_PIN, HIGH);
    if (testObservable() && testCollections())
    //eventLoopTest())
    {
        digitalWrite(GOOD_PIN, HIGH);
        digitalWrite(BAD_PIN, LOW);
    }
    
    return 0;
}


