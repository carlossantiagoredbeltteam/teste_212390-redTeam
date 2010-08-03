#ifndef HOSTCOM_H
#define HOSTCOM_H
/*
 * Class to handle sending messages from and back to the host.
 * NOWHERE ELSE in this program should anything send to Serial.print()
 * or get anything from Serial.read().
 */

// Can't get lower than absolute zero...

#define NO_TEMP -300

extern void shutdown();

class hostcom
{
public:
  hostcom();
  char* string();
  void setETemp(int et);
  void setBTemp(int bt);
  void setCoords(const FloatPoint& where);
  void capabilities();
  void setResend(long ln);
  void setFatal();
  void sendMessage(bool doMessage);
  void start();
  
// Wrappers for the comms interface

  void putInit();
  void put(char* s);
  void put(const float& f);
  void put(const long& l);
  void put(int i);
  void put(double i);
  void put(); // to allow putting an undefined constant as "n/a"
  void putEnd();
  byte gotData();
  char get();
  
private:
  void reset();
  void sendtext(bool noText);
  char message[RESPONSE_SIZE];
  int etemp;
  int btemp;
  float x;
  float y;
  float z;
  float e;
  long resend;
  bool fatal;
  bool sendCoordinates;  
  bool sendCapabilities;
};

inline hostcom::hostcom()
{
  fatal = false;
  reset();
}

// Wrappers for the comms interface
#if DATA_SOURCE == DATA_SOURCE_USB_SERIAL
inline void hostcom::putInit() {  Serial.begin(HOST_BAUD); }
inline void hostcom::put(char* s) { Serial.print(s); }
inline void hostcom::put(const float& f) { Serial.print(f); }
inline void hostcom::put(const long& l) { Serial.print(l); }
inline void hostcom::put(int i) { Serial.print(i); }
inline void hostcom::put(double i) { Serial.print(i); }
inline void hostcom::put() { Serial.print("n/a"); }
inline void hostcom::putEnd() { Serial.println(); }
inline byte hostcom::gotData() { return Serial.available(); }
inline char hostcom::get() { return Serial.read(); }
#endif // DATA_SOURCE_USB_SERIAL

#if DATA_SOURCE == DATA_SOURCE_SDCARD
//TODO how to read data from a SD card using SPI? 
#error Oops! Reading from a SD Card is not yet implemented! 
#endif  //DATA_SOURCE_SDCARD

#if DATA_SOURCE == DATA_SOURCE_EPROM
//TODO how to read data from an EEPROM using I2C normally
#error Oops! Reading from an EPROM is not yet implemented! 
#endif  //DATA_SOURCE_EPROM

inline void hostcom::reset()
{
  etemp = NO_TEMP;
  btemp = NO_TEMP;
  message[0] = 0;
  resend = -1;
  sendCoordinates = false;
  sendCapabilities = false;
  // Don't reset fatal.
}

inline void hostcom::start()
{
  putInit();
  put("start");
  putEnd();  
}

inline char* hostcom::string()
{
  return message;
}

inline void hostcom::setETemp(int et)
{
  etemp = et;
}

inline void hostcom::setBTemp(int bt)
{
  btemp = bt;
}

inline void hostcom::setCoords(const FloatPoint& where)
{
  x = where.x;
  y = where.y;
  z = where.z;
  e = where.e;
  sendCoordinates = true;
}

inline void hostcom::capabilities()
{
  sendCapabilities = true;
}

inline void hostcom::setResend(long ln)
{
  resend = ln;
}

inline void hostcom::setFatal()
{
  fatal = true;
}

inline void hostcom::sendtext(bool doMessage)
{
  if(!doMessage)
    return;
  if(!message[0])
    return;
  put(" ");
  put(message);
}

inline void hostcom::sendMessage(bool doMessage)
{
  if(fatal)
  {
    put("!!");
    sendtext(true);
    putEnd();
    shutdown();
    return; // Technically redundant - shutdown never returns.
  }
  
  if(resend < 0)
    put("ok");
  else
  {
    put("rs ");
    put(resend);
  }
    
  if(etemp > NO_TEMP)
  {
    put(" T:");
    put(etemp);
  }
  
  if(btemp > NO_TEMP)
  {
    put(" B:");
    put(btemp);
  }
  
  if(sendCoordinates)
  {				
    put(" C: X:");
    put(x);
    put(" Y:");
    put(y);
    put(" Z:");
    put(z);
    put(" E:");
    put(e);
  }
  
  if(sendCapabilities) 
  {
    put("REVISION:"); put(REVISION); putEnd();
    put("CPUTYPE:"); put(CPUTYPE); putEnd();
    put("DEFAULTS:"); put(DEFAULTS); putEnd();
    put("MOVEMENT_TYPE:"); put(MOVEMENT_TYPE); putEnd();
    put("ENDSTOP_OPTO_TYPE:"); put(ENDSTOP_OPTO_TYPE); putEnd();
    put("ENABLE_PIN_STATE:"); put(ENABLE_PIN_STATE); putEnd();
    put("TEMP_SENSOR:"); put(TEMP_SENSOR); putEnd();
    put("EXTRUDER_CONTROLLER:"); put(EXTRUDER_CONTROLLER); putEnd();
    put("DATA_SOURCE:"); put(DATA_SOURCE); putEnd();
    put("ACCELERATION:"); put(ACCELERATION); putEnd();
    put("HEATED_BED:"); put(HEATED_BED); putEnd();
    put("INVERT_X_DIR:"); put(INVERT_X_DIR); putEnd();
    put("INVERT_Y_DIR:"); put(INVERT_Y_DIR); putEnd();
    put("INVERT_Z_DIR:"); put(INVERT_Z_DIR); putEnd();
    put("ENDSTOPS_MIN_ENABLED:"); put(ENDSTOPS_MIN_ENABLED); putEnd();
    put("ENDSTOPS_MAX_ENABLED:"); put(ENDSTOPS_MAX_ENABLED); putEnd();
    put("DISABLE_X:"); put(DISABLE_X); putEnd();
    put("DISABLE_Y:"); put(DISABLE_Y); putEnd();
    put("DISABLE_Z:"); put(DISABLE_Z); putEnd();
    put("DISABLE_E:"); put(DISABLE_E); putEnd();
    put("FAST_XY_FEEDRATE:"); put(FAST_XY_FEEDRATE); putEnd();
    put("FAST_Z_FEEDRATE:"); put(FAST_Z_FEEDRATE); putEnd();
    put("X_STEPS_PER_MM:"); put(X_STEPS_PER_MM); putEnd();
    put("Y_STEPS_PER_MM:"); put(Y_STEPS_PER_MM); putEnd();
    put("Z_STEPS_PER_MM:"); put(Z_STEPS_PER_MM); putEnd();
    put("E0_STEPS_PER_MM:"); put(E0_STEPS_PER_MM); putEnd();
    put("E1_STEPS_PER_MM:"); put(E1_STEPS_PER_MM); putEnd();

    // terminate capabilities list with a blank line:
    putEnd();
  }
  
  sendtext(doMessage);
  
  putEnd();
  
  reset(); 
}


#endif
