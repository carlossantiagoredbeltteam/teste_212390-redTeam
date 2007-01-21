
all:	slave.exe master.exe

slave.exe:	slave.c comms.c procsim.c
	gcc -o slave.exe slave.c comms.c procsim.c

master.exe:	master.c comms.c procsim.c
	gcc -o master.exe master.c procsim.c comms.c

test:
	perl test.pl
