#include <pthread.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include "shared.h"

int exitAfter = -1;
int receiveCount = 0;

byte address;
int rfd, wfd;

byte RCREG;

byte action = ACT_NONE;
byte action_value = 0;
int act_after = 0;

void *timer(void *arg)
{
  for(;;) {
    usleep(20000);
    timer_ping();
  }
  return NULL;
}

void *comms(void *arg)
{  
  ssize_t len;

  for(;;) {
    len = read(rfd, &RCREG, 1);
    receiveCount++;
    if (exitAfter != -1 && receiveCount >= exitAfter)
	break;
    if (receiveCount == act_after && action == ACT_FLIP)
      RCREG ^= action_value;
    if (len == 0) break;
    if (receiveCount != act_after || action != ACT_DROP)
      uartNotifyReceive();
    if (receiveCount == act_after && action == ACT_INSERT) {
      RCREG = action_value;
      uartNotifyReceive();
    }
  }
  exit(0);
  return NULL;
}

void uartTransmit(byte c)
{
  //if (address) printf("                  ");
  //printf("--> %d tx %02x\n", address, c);
  //fflush(stdout);
  usleep(10000);

  if (write(wfd, &c, 1) == -1) {
    printf("WRITE FAILURE!!\n");
    fflush(stdout);
  }
}
