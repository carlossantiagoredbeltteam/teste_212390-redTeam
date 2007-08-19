EESchema Schematic File Version 1
LIBS:power,device,conn,linear,regul,reprap,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,microchip,analog_switches,motorola,intel,audio,interface,digital-audio,philips,display,cypress,siliconi
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 1
Title ""
Date "19 aug 2007"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Notes 5700 1900 0    60   ~
Rx/Tx Debug LEDs
Connection ~ 5650 3850
Wire Wire Line
	5400 3850 5650 3850
Connection ~ 6000 4050
Wire Wire Line
	6000 3200 6000 4050
Wire Wire Line
	5400 4050 6650 4050
Wire Wire Line
	6650 4050 6650 3850
Wire Wire Line
	6650 3850 6850 3850
Connection ~ 9300 5500
Wire Wire Line
	9550 5500 9050 5500
Wire Wire Line
	9550 5500 9550 5150
Wire Wire Line
	9050 4450 9050 4550
Wire Wire Line
	3100 5000 3100 5100
Connection ~ 2750 2200
Wire Wire Line
	2750 2200 2600 2200
Connection ~ 9550 3650
Wire Wire Line
	8450 3650 10150 3650
Wire Wire Line
	9550 3950 9550 3650
Wire Wire Line
	2650 4050 3450 4050
Connection ~ 2850 4050
Connection ~ 2750 4050
Connection ~ 3050 4050
Wire Wire Line
	3450 4050 3450 4000
Connection ~ 6150 2150
Wire Wire Line
	6300 2150 6000 2150
Wire Wire Line
	6300 2650 6300 2800
Connection ~ 2550 2750
Wire Wire Line
	2550 2900 2550 2400
Wire Wire Line
	2750 2200 2750 2350
Wire Wire Line
	2550 2400 2350 2400
Connection ~ 2350 4050
Wire Wire Line
	2550 4050 2050 4050
Connection ~ 2150 4050
Wire Wire Line
	3700 2350 3900 2350
Wire Wire Line
	2550 2750 3900 2750
Connection ~ 2750 2750
Wire Wire Line
	3300 2650 3300 2750
Connection ~ 3300 2750
Wire Wire Line
	3900 2350 3900 2200
Wire Wire Line
	8600 2950 8450 2950
Wire Wire Line
	8450 3450 8750 3450
Wire Wire Line
	8450 3150 8600 3150
Wire Wire Line
	8600 3150 8600 3050
Wire Wire Line
	6750 3050 6850 3050
Wire Wire Line
	6750 3450 6850 3450
Wire Wire Line
	10150 3550 10000 3550
Wire Wire Line
	10000 3550 10000 4050
Wire Wire Line
	10000 4050 10150 4050
Wire Wire Line
	10150 3750 10050 3750
Wire Wire Line
	10050 3750 10050 3950
Wire Wire Line
	10050 3950 10150 3950
Wire Wire Line
	9100 3200 9100 3050
Wire Wire Line
	9100 3050 8600 3050
Connection ~ 8750 3050
Wire Wire Line
	10150 4150 10150 4450
Connection ~ 10150 4250
Wire Wire Line
	8450 2450 8450 2550
Wire Wire Line
	8450 2550 8600 2550
Wire Wire Line
	6850 2550 6750 2550
Wire Wire Line
	6850 2950 6750 2950
Wire Wire Line
	3100 5600 3100 5650
Connection ~ 2250 4050
Connection ~ 2450 4050
Wire Wire Line
	3100 6050 3100 6200
Wire Wire Line
	2350 2500 2550 2500
Connection ~ 2550 2500
Wire Wire Line
	2750 2350 2900 2350
Wire Wire Line
	2350 2300 2600 2300
Wire Wire Line
	2600 2300 2600 2200
Wire Wire Line
	6000 2650 6000 2800
Wire Wire Line
	6150 2050 6150 2150
Wire Wire Line
	2300 4050 2300 4250
Connection ~ 2300 4050
Connection ~ 3150 4050
Connection ~ 2950 4050
Wire Wire Line
	9050 3950 9050 3850
Wire Wire Line
	8450 3850 10150 3850
Connection ~ 9050 3850
Wire Wire Line
	9550 4450 9550 4550
Wire Wire Line
	9050 5500 9050 5150
Wire Wire Line
	9300 5650 9300 5500
Wire Wire Line
	6850 3650 5400 3650
Wire Wire Line
	6300 3200 6300 3650
Connection ~ 6300 3650
Wire Wire Line
	5400 3450 5650 3450
Wire Wire Line
	5650 3450 5650 4600
$Comp
L GND #PWR?
U 1 1 46C891D6
P 5650 4600
F 0 "#PWR?" H 5650 4600 30  0001 C C
F 1 "GND" H 5650 4530 30  0001 C C
	1    5650 4600
	1    0    0    -1  
$EndComp
Text Notes 8850 5850 0    60   ~
RS232 Debug LEDs
$Comp
L BILED D5
U 1 1 46C88FD5
P 9550 4900
F 0 "D5" H 9850 5000 50  0000 C C
F 1 "BILED" H 9900 4800 50  0000 C C
	1    9550 4900
	0    1    1    0   
$EndComp
$Comp
L BILED D4
U 1 1 46C88FAD
P 9050 4900
F 0 "D4" H 9350 5000 50  0000 C C
F 1 "BILED" H 9400 4800 50  0000 C C
	1    9050 4900
	0    1    1    0   
$EndComp
Text Notes 4700 3550 0    60   ~
Tx
Text Notes 4750 4000 0    60   ~
Rx
$Comp
L +12V #PWR6
U 1 1 46B87CA5
P 3100 5000
F 0 "#PWR6" H 3100 4950 20  0001 C C
F 1 "+12V" H 3100 5100 30  0000 C C
	1    3100 5000
	1    0    0    -1  
$EndComp
NoConn ~ 10150 3450
NoConn ~ 6850 3950
NoConn ~ 6850 3750
NoConn ~ 8450 3950
NoConn ~ 8450 3750
$Comp
L R R5
U 1 1 46B771FB
P 9550 4200
F 0 "R5" V 9630 4200 50  0000 C C
F 1 "5K6" V 9550 4200 50  0000 C C
	1    9550 4200
	1    0    0    -1  
$EndComp
$Comp
L R R4
U 1 1 46B771DA
P 9050 4200
F 0 "R4" V 9130 4200 50  0000 C C
F 1 "5K6" V 9050 4200 50  0000 C C
	1    9050 4200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR11
U 1 1 46B77059
P 9300 5650
F 0 "#PWR11" H 9300 5650 30  0001 C C
F 1 "GND" H 9300 5580 30  0001 C C
	1    9300 5650
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR5
U 1 1 46B75D84
P 6150 2050
F 0 "#PWR5" H 6150 2140 20  0001 C C
F 1 "+5V" H 6150 2140 30  0000 C C
	1    6150 2050
	1    0    0    -1  
$EndComp
$Comp
L R R3
U 1 1 46B75D76
P 6300 2400
F 0 "R3" V 6380 2400 50  0000 C C
F 1 "1K8" V 6300 2400 50  0000 C C
	1    6300 2400
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 46B75D60
P 6000 2400
F 0 "R2" V 6080 2400 50  0000 C C
F 1 "1K8" V 6000 2400 50  0000 C C
	1    6000 2400
	1    0    0    -1  
$EndComp
$Comp
L LED D3
U 1 1 46B75D1E
P 6300 3000
F 0 "D3" H 6300 3100 50  0000 C C
F 1 "LED" H 6300 2900 50  0000 C C
	1    6300 3000
	0    1    1    0   
$EndComp
$Comp
L LED D2
U 1 1 46B75CB9
P 6000 3000
F 0 "D2" H 6000 3100 50  0000 C C
F 1 "LED" H 6000 2900 50  0000 C C
	1    6000 3000
	0    1    1    0   
$EndComp
$Comp
L +12V #PWR2
U 1 1 463A9FF1
P 2750 2200
F 0 "#PWR2" H 2750 2150 20  0001 C C
F 1 "+12V" H 2750 2300 30  0000 C C
	1    2750 2200
	1    0    0    -1  
$EndComp
$Comp
L MOLEX_4PIN M2
U 1 1 463A9D69
P 1750 2450
F 0 "M2" H 1800 2200 60  0000 C C
F 1 "MOLEX_4PIN" H 2050 2750 60  0000 C C
	1    1750 2450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR9
U 1 1 46319B6C
P 2300 4250
F 0 "#PWR9" H 2300 4250 30  0001 C C
F 1 "GND" H 2300 4180 30  0001 C C
	1    2300 4250
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR13
U 1 1 46319B62
P 3450 4000
F 0 "#PWR13" H 3450 3950 20  0001 C C
F 1 "+12V" H 3450 4100 30  0000 C C
	1    3450 4000
	1    0    0    -1  
$EndComp
$Comp
L AMP P5
U 1 1 463198A7
P 2600 4100
F 0 "P5" H 2600 4100 60  0000 C C
F 1 "AMP" H 2600 4100 60  0000 C C
	1    2600 4100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR7
U 1 1 45A40DA1
P 3100 6200
F 0 "#PWR7" H 3100 6200 30  0001 C C
F 1 "GND" H 3100 6130 30  0001 C C
	1    3100 6200
	1    0    0    -1  
$EndComp
$Comp
L LED D1
U 1 1 45A40D97
P 3100 5850
F 0 "D1" H 3100 5950 50  0000 C C
F 1 "LED" H 3100 5750 50  0000 C C
	1    3100 5850
	0    1    1    0   
$EndComp
$Comp
L R R1
U 1 1 45A40D8A
P 3100 5350
F 0 "R1" V 3180 5350 50  0000 C C
F 1 "560R" V 3100 5350 50  0000 C C
	1    3100 5350
	1    0    0    -1  
$EndComp
$Comp
L CP C5
U 1 1 45A40CF5
P 6750 2750
F 0 "C5" H 6800 2850 50  0000 L C
F 1 "1uF" H 6800 2650 50  0000 L C
	1    6750 2750
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR10
U 1 1 45A40C07
P 9100 3200
F 0 "#PWR10" H 9100 3200 30  0001 C C
F 1 "GND" H 9100 3130 30  0001 C C
	1    9100 3200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR12
U 1 1 45A40BF0
P 10150 4450
F 0 "#PWR12" H 10150 4450 30  0001 C C
F 1 "GND" H 10150 4380 30  0001 C C
	1    10150 4450
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P3
U 1 1 45A40B82
P 5050 3550
F 0 "P3" V 5000 3550 40  0000 C C
F 1 "CONN_2" V 5100 3550 40  0000 C C
	1    5050 3550
	-1   0    0    1   
$EndComp
$Comp
L CONN_2 P2
U 1 1 45A40B73
P 5050 3950
F 0 "P2" V 5000 3950 40  0000 C C
F 1 "CONN_2" V 5100 3950 40  0000 C C
	1    5050 3950
	-1   0    0    1   
$EndComp
$Comp
L DB9 J1
U 1 1 45A40B59
P 10600 3850
F 0 "J1" H 10600 4400 70  0000 C C
F 1 "DB9" H 10600 3300 70  0000 C C
	1    10600 3850
	1    0    0    1   
$EndComp
$Comp
L +5V #PWR8
U 1 1 45A40B48
P 8450 2450
F 0 "#PWR8" H 8450 2540 20  0001 C C
F 1 "+5V" H 8450 2540 30  0000 C C
	1    8450 2450
	1    0    0    -1  
$EndComp
$Comp
L CP C4
U 1 1 45A40B38
P 8750 3250
F 0 "C4" H 8800 3350 50  0000 L C
F 1 "1uF" H 8800 3150 50  0000 L C
	1    8750 3250
	1    0    0    -1  
$EndComp
$Comp
L CP C3
U 1 1 45A40B2E
P 8600 2750
F 0 "C3" H 8650 2850 50  0000 L C
F 1 "1uF" H 8650 2650 50  0000 L C
	1    8600 2750
	-1   0    0    1   
$EndComp
$Comp
L CP C2
U 1 1 45A40B29
P 6750 3250
F 0 "C2" H 6800 3350 50  0000 L C
F 1 "1uF" H 6800 3150 50  0000 L C
	1    6750 3250
	1    0    0    -1  
$EndComp
$Comp
L MAX232 U2
U 1 1 45A40B1C
P 7650 3250
F 0 "U2" H 7650 4100 70  0000 C C
F 1 "MAX232" H 7650 2400 70  0000 C C
	1    7650 3250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR1
U 1 1 45A40A81
P 2550 2900
F 0 "#PWR1" H 2550 2900 30  0001 C C
F 1 "GND" H 2550 2830 30  0001 C C
	1    2550 2900
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR4
U 1 1 45A40A6C
P 3900 2200
F 0 "#PWR4" H 3900 2290 20  0001 C C
F 1 "+5V" H 3900 2290 30  0000 C C
	1    3900 2200
	1    0    0    -1  
$EndComp
$Comp
L CP C1
U 1 1 45A40A1C
P 3900 2550
F 0 "C1" H 3950 2650 50  0000 L C
F 1 "100uF" H 3950 2450 50  0000 L C
	1    3900 2550
	1    0    0    -1  
$EndComp
$Comp
L CP C6
U 1 1 45A40A15
P 2750 2550
F 0 "C6" H 2800 2650 50  0000 L C
F 1 "4700uF" H 2800 2450 50  0000 L C
	1    2750 2550
	1    0    0    -1  
$EndComp
$Comp
L 78L05 U1
U 1 1 45A409E1
P 3300 2400
F 0 "U1" H 3450 2204 60  0000 C C
F 1 "78L05" H 3300 2600 60  0000 C C
	1    3300 2400
	1    0    0    -1  
$EndComp
Text Notes 2200 5650 0    60   ~
Power-on LED
Text Notes 6950 4350 0    60   ~
RS232 to TTL converter
Text Notes 1950 1900 0    60   ~
Power in and voltage regulator
Text Notes 1900 4500 0    60   ~
Power output connectors
Text Notes 10150 4650 0    60   ~
RS232 socket
$EndSCHEMATC
