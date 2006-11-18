#include <pthread.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include "shared.h"

byte address;
int rfd, wfd;

byte RCREG;

void *timer(void *arg)
{
  for(;;) {
    sleep(1);
    timer_ping();
  }
  return NULL;
}

void *comms(void *arg)
{  
  ssize_t len;
  for(;;) {
    len = read(rfd, &RCREG, 1);
    if (len == 0) break;
    uartNotifyReceive();
  }
  exit(0);
  return NULL;
}

void uartTransmit(byte c)
{
  if (address) printf("                  ");
  printf("--> %d tx %02x\n", address, c);
  usleep(100000);
  write(wfd, &c, 1);
}
