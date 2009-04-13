#ifndef WProgram_h
#define WProgram_h

#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdint.h>

typedef uint8_t byte;

#ifdef __cplusplus
class SerialAgent
{
public:
	bool available();
	uint8_t read();
	void write(uint8_t);
	void print(char);
	void print(const char[]);
	void print(uint8_t);
	void print(int);
	void print(unsigned int);
	void print(long);
	void print(unsigned long);
	void print(long, int);
	void print(double);
	void println(void);
	void println(char);
	void println(const char[]);
	void println(uint8_t);
	void println(int);
	void println(unsigned int);
	void println(long);
	void println(unsigned long);
	void println(long, int);
	void println(double);
};

extern SerialAgent Serial;


uint16_t makeWord(uint16_t w);
uint16_t makeWord(byte h, byte l);
void incrementMillis();
uint16_t  millis();

#define DEC 10
#define HEX 16
#define OCT 8
#define BIN 2
#define BYTE 0

#define OUTPUT 1
#define INPUT 0
#define LOW 0
#define HIGH 1

void pinMode(int pin, int i);
void analogWrite(int pin, uint16_t val);
uint32_t analogRead(int pin);
int digitalRead(int pin);
void digitalWrite(int pin, int value);
void delayMicroseconds(int num);
void delay(int s);




#define word(...) makeWord(__VA_ARGS__)

#endif

#endif

