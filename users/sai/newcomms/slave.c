#include <pthread.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include "shared.h"

extern byte address;
extern int rfd, wfd;
extern void *timer(void *);
extern void *comms(void *);

void packetNotifyReceive(byte *data, byte length)
{
  int i;
  printf("slave %d received packet:", address);
  for(i = 0; i < length; i++)
    printf(" %02x", data[i]);
  printf("\n");

  reply();
  sendDataByte(0x51);
  endMessage();

  //releaseReceiveBuffer();
}

int main()
{
  pthread_t timer_thread;
  pthread_t comms_thread;
  pthread_attr_t pthread_custom_attr;

  address = 1;

  rfd = open("1", O_RDONLY);
  wfd = open("0", O_WRONLY);

  pthread_attr_init(&pthread_custom_attr);
  
  pthread_create(&timer_thread, &pthread_custom_attr, timer, NULL);
  pthread_create(&comms_thread, &pthread_custom_attr, comms, NULL);

  pthread_join(timer_thread, NULL);
  pthread_join(comms_thread, NULL);
  
  return 0;
}
