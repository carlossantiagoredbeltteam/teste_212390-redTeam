// this is a generic logger that does checksum testing so the data written should be always good
// Assumes a sirf III chipset logger attached to pin 0 and 1

#include "AF_SDLog.h"
#include "util.h"
#include <avr/pgmspace.h>
#include <avr/sleep.h>
// this function will return the number of bytes currently free in RAM      
int freeRam(void)
{
  extern int  __bss_end; 
  extern int  *__brkval; 
  int free_memory; 
  if((int)__brkval == 0) {
    free_memory = ((int)&free_memory) - ((int)&__bss_end); 
  }
  else {
    free_memory = ((int)&free_memory) - ((int)__brkval); 
  }
  return free_memory; 
} 

// power saving modes
#define SLEEPDELAY 0         // how long to sleep before reading another NMEA sentence
#define TURNOFFGPS 0          // probably only want to do this if the sleep delay > 60 or so
#define LOG_RMC_FIXONLY 1  // log only when we get RMC's with fix?

AF_SDLog card;
File f;

#define led1Pin 4                // LED1 connected to digital pin 4
#define led2Pin 3                // LED2 connected to digital pin 3
#define powerPin 2               // GPS power control

// set the  RX_BUFFER_SIZE to 32!
#define BUFFSIZE 75         // we buffer one NMEA sentense at a time, 83 bytes is longer than the max length
char buffer[BUFFSIZE];      // this is the double buffer
uint8_t bufferidx = 0;

#define LOG_RMC  1      // essential location data
#define RMC_ON   "$PSRF103,4,0,1,1*21\r\n"  // the command we send to turn RMC on (1 hz rate)
//#define RMC_ON     "$PSRF103,4,0,10,1*11\r\n" // 1/30 hz
#define RMC_OFF  "$PSRF103,4,0,0,1*20\r\n"  // the command we send to turn RMC off

#define LOG_GGA  0      // contains fix, hdop & vdop data
#define GGA_ON   "$PSRF103,0,0,1,1*25\r\n"   // the command we send to turn GGA on (1 hz rate)
#define GGA_OFF  "$PSRF103,0,0,0,1*24\r\n"   // the command we send to turn GGA off

#define LOG_GSA 0      // satelite data
#define GSA_ON   "$PSRF103,2,0,1,1*27\r\n"   // the command we send to turn GSA on (1 hz rate)
#define GSA_OFF  "$PSRF103,2,0,0,1*26\r\n"   // the command we send to turn GSA off

#define LOG_GSV  0      // detailed satellite data
#define GSV_ON   "$PSRF103,3,0,1,1*26\r\n"  // the command we send to turn GSV on (1 hz rate)
#define GSV_OFF  "$PSRF103,3,0,0,1*27\r\n"  // the command we send to turn GSV off

#define LOG_GLL 0      // Loran-compatibility data
// this isnt output by default

#define USE_WAAS   1     // useful in US, but slower fix
#define WAAS_ON    "$PSRF151,1*3F\r\n"       // the command for turning on WAAS
#define WAAS_OFF   "$PSRF151,0*3E\r\n"       // the command for turning off WAAS


uint8_t fix = 0; // current fix data

// read a Hex value and return the decimal equivalent
uint8_t parseHex(char c) {
    if (c < '0')
      return 0;
    if (c <= '9')
      return c - '0';
    if (c < 'A')
       return 0;
    if (c <= 'F')
       return (c - 'A')+10;
}

uint8_t i;

// blink out an error code
void error(uint8_t errno) {
   while(1) {
     for (i=0; i<errno; i++) {    
       digitalWrite(led1Pin, HIGH);
       digitalWrite(led2Pin, HIGH);
       delay(100);
       digitalWrite(led1Pin, LOW);   
       digitalWrite(led2Pin, LOW);   
       delay(100);
     }
     for (; i<10; i++) {
       delay(200);
     }      
   } 
}

void setup()                    // run once, when the sketch starts
{
  WDTCSR |= (1 << WDCE) | (1 << WDE);
  WDTCSR = 0;
  
  
  Serial.begin(4800);
  putstring_nl("GPSlogger");
  Serial.println(freeRam());
  pinMode(led1Pin, OUTPUT);      // sets the digital pin as output
  pinMode(led2Pin, OUTPUT);      // sets the digital pin as output
  pinMode(powerPin, OUTPUT);
  digitalWrite(powerPin, LOW);
  
  if (!card.init_card()) {
    putstring_nl("Card init. failed!"); 
    error(1);
  }
  if (!card.open_partition()) {
    putstring_nl("No partition!"); 
    error(2);
  }
  if (!card.open_filesys()) {
    putstring_nl("Can't open filesys"); 
    error(3);
  }
  if (!card.open_dir("/")) {
    putstring_nl("Can't open /"); 
    error(4);
  }
  
  strcpy(buffer, "GPSLOG00.TXT");
  for (buffer[6] = '0'; buffer[6] <= '9'; buffer[6]++) {
      for (buffer[7] = '0'; buffer[7] <= '9'; buffer[7]++) {
         //putstring("\n\rtrying to open ");Serial.println(buffer);
         f = card.open_file(buffer);
         if (!f)
	   break;        // found a file!      
         card.close_file(f);
      }
      if (!f) 
         break;
  }

  if(!card.create_file(buffer)) {
    putstring("couldnt create "); Serial.println(buffer);
    error(5);
  }
  f = card.open_file(buffer);
  if (!f) {
    putstring("error opening "); Serial.println(buffer);
    card.close_file(f);
    error(6);
  }
  putstring("writing to "); Serial.println(buffer);
  putstring_nl("ready!");

delay(1000);

 putstring("\r\n");
#if USE_WAAS == 1 
   putstring(WAAS_ON); // turn on WAAS
#else
  putstring(WAAS_OFF; // turn on WAAS
#endif

#if LOG_RMC == 1
  putstring(RMC_ON); // turn on RMC
#else
  putstring(RMC_OFF); // turn off RMC
#endif

#if LOG_GSV == 1
  putstring(GSV_ON); // turn on GSV
#else
  putstring(GSV_OFF); // turn off GSV
#endif

#if LOG_GSA == 1
  putstring(GSA_ON); // turn on GSA
#else
  putstring(GSA_OFF); // turn off GSA
#endif

#if LOG_GGA == 1
 putstring(GGA_ON); // turn on GGA
#else
 putstring(GGA_OFF); // turn off GGA
#endif
}

void loop()                     // run over and over again
{
  //Serial.println(Serial.available(), DEC);
  char c;
  uint8_t sum;
  
  // read one 'line'
  if (Serial.available()) {
    c = Serial.read();
    //Serial.print(c, BYTE);
    if (bufferidx == 0) {
      while (c != '$')
        c = Serial.read(); // wait till we get a $
    }
    buffer[bufferidx] = c;

    //Serial.print(c, BYTE);
    if (c == '\n') {
      //putstring_nl("EOL");
      //Serial.print(buffer);
      buffer[bufferidx+1] = 0; // terminate it
     
      if (buffer[bufferidx-4] != '*') {
        // no checksum?
        Serial.print('*', BYTE);
        bufferidx = 0;
        return;
      }
      // get checksum
      sum = parseHex(buffer[bufferidx-3]) * 16;
      sum += parseHex(buffer[bufferidx-2]);
      
      // check checksum 
      for (i=1; i < (bufferidx-4); i++) {
        sum ^= buffer[i];
      }
      if (sum != 0) {
        //putstring_nl("Cxsum mismatch");
        Serial.print('~', BYTE);
        bufferidx = 0;
        return;
      }
      // got good data!

      if (strstr(buffer, "GPRMC")) {
        // find out if we got a fix
        char *p = buffer;
        p = strchr(p, ',')+1;
        p = strchr(p, ',')+1;       // skip to 3rd item
        
        if (p[0] == 'V') {
          digitalWrite(led1Pin, LOW);
          fix = 0;
        } else {
          digitalWrite(led1Pin, HIGH);
          fix = 1;
        }
      }
#if LOG_RMC_FIXONLY
      if (!fix) {
          Serial.print('_', BYTE);
          bufferidx = 0;
          return;
      } 
#endif
      // rad. lets log it!
      //Serial.print(buffer);
      Serial.print('#', BYTE);
      digitalWrite(led2Pin, HIGH);      // sets the digital pin as output
      // write both CR and LF (mod by Bill Greiman)
      bufferidx++;
      if(card.write_file(f, (uint8_t *) buffer, bufferidx) != bufferidx) {
         putstring_nl("can't write!");
	 return;
      }
      digitalWrite(led2Pin, LOW);

      bufferidx = 0;

      // turn off GPS module?
      if (TURNOFFGPS) {
        digitalWrite(powerPin, HIGH);
      }
      sleep_sec(SLEEPDELAY);
      digitalWrite(powerPin, LOW);
  
      return;
    }
    bufferidx++;
    if (bufferidx == BUFFSIZE-1) {
       Serial.print('!', BYTE);
       bufferidx = 0;
    }
  } else {

  }
  
}

void sleep_sec(uint8_t x) {
  while (x--) {
     // set the WDT to wake us up!
    WDTCSR |= (1 << WDCE) | (1 << WDE); // enable watchdog & enable changing it
    WDTCSR = (1<< WDE) | (1 <<WDP2) | (1 << WDP1);
    WDTCSR |= (1<< WDIE);
    set_sleep_mode(SLEEP_MODE_PWR_DOWN); 
    sleep_enable(); 
    sleep_mode();
    sleep_disable();
  }
}
  
SIGNAL(SIG_WATCHDOG_TIMEOUT) {
  WDTCSR |= (1 << WDCE) | (1 << WDE);
  WDTCSR = 0;
}
