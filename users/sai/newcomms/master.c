#include <pthread.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include "shared.h"

extern byte address;
extern int rfd, wfd;
extern void *timer(void *);
extern void *comms(void *);

extern int exitAfter;

void packetNotifyReceive(byte *data, byte length)
{
  int i;
  printTime();
  printf("master %d received packet:", address);
  for(i = 0; i < length; i++)
    printf(" %02x", data[i]);
  printf("\n");
  fflush(stdout);

  if (!strncmp(data, "A", length)) {
    reply();
    sendDataByte('B');
    endMessage();
  } else 
    releaseReceiveBuffer();
}

void comms_main()
{
  sendMessage(1);
  sendDataByte('G');
  sendDataByte('O');
  endMessage();

  uartTransmit(0x54);
  uartTransmit(0xff);
}


int main(int argc, char **argv)
{
  pthread_t timer_thread;
  pthread_t comms_thread;
  pthread_attr_t pthread_custom_attr;
  char buf[1024];
  FILE *f;
  int c;

  extern byte action;
  extern byte action_value;
  extern int act_after;

  if (argc == 1) {
    action = ACT_NONE;
    exitAfter = 10;
  } else if (argc == 5) {
    act_after = atoi(argv[1]);
    action = atoi(argv[2]);
    action_value = atoi(argv[3]);
    exitAfter = atoi(argv[4]);
  } else {
    fprintf(stderr, "Usage: ./master action_after action action_val exit\n");
    exit(1);
  }

  switch(fork()) {
  case -1:
    perror("Fork failed");
    exit(1);
  case 0:
    f = popen("./slave", "r");
    while(fgets(buf, 1024, f)) {
      printf(buf);
      fflush(stdout);
    }
    pclose(f);
    exit(1);
  }

  printf("Starting master\n");
  fflush(stdout);

  alarm(10);

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
