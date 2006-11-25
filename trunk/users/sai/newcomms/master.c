#include <pthread.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include "shared.h"

extern byte address;
extern int rfd, wfd;
extern void *timer(void *);
extern void *comms(void *);

extern int exitAfter;

void packetNotifyReceive(byte *data, byte length)
{
  int i;
  printf("master %d received packet:", address);
  for(i = 0; i < length; i++)
    printf(" %02x", data[i]);
  printf("\n");

  releaseReceiveBuffer();
}

void comms_main()
{
  sendMessage(1);
  sendDataByte(65);
  sendDataByte(66);
  endMessage();

  uartTransmit(0x54);
  uartTransmit(0xff);
}


int main()
{
  pthread_t timer_thread;
  pthread_t comms_thread;
  pthread_attr_t pthread_custom_attr;

  switch(fork()) {
  case -1:
    perror("Fork failed");
    exit(1);
  case 0:
    system("./slave &");
    //execl("slave", "slave");
    exit(1);
  }

  exitAfter = 50;

  printf("Starting master\n");

  address = 0;

  rfd = open("0", O_RDONLY);
  wfd = open("1", O_WRONLY);

  pthread_attr_init(&pthread_custom_attr);
  
  pthread_create(&timer_thread, &pthread_custom_attr, timer, NULL);
  pthread_create(&comms_thread, &pthread_custom_attr, comms, NULL);

  comms_main();

  pthread_join(timer_thread, NULL);
  pthread_join(comms_thread, NULL);
  
  return 0;
}
