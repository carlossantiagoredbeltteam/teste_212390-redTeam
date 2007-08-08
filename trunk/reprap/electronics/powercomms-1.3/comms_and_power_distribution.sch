EESchema Schematic File Version 1
LIBS:power,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,microchip,analog_switches,motorola,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,.\comms_and_power_distribution.cache
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 1
Title ""
Date "7 aug 2007"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Kmarq B 4450 5050 "Warning Pin input Unconnected" F=1
Kmarq B 4250 5050 "Warning Pin input Unconnected" F=1
Kmarq B 4950 5050 "Warning Pin input Unconnected" F=1
Kmarq B 4750 5050 "Warning Pin input Unconnected" F=1
Kmarq B 4850 4950 "Warning Pin passive Unconnected" F=1
Kmarq B 4350 4950 "Warning Pin passive Unconnected" F=1
Kmarq B 5450 4950 "Warning Pin power_in not driven (Net 2)" F=1
Kmarq B 2900 950  "Warning Pin power_in not driven (Net 1)" F=1
Wire Wire Line
	5350 1150 5350 1250
Connection ~ 2900 950 
Wire Wire Line
	2900 950  2750 950 
Wire Wire Line
	4600 6150 4600 6000
Wire Wire Line
	4350 5700 4350 6000
Connection ~ 4850 4150
Wire Wire Line
	5450 4150 3750 4150
Wire Wire Line
	4850 4450 4850 4150
Wire Wire Line
	4350 4950 4350 5000
Wire Wire Line
	7250 1750 8050 1750
Connection ~ 7450 1750
Connection ~ 7350 1750
Connection ~ 7650 1750
Wire Wire Line
	8050 1750 8050 1700
Connection ~ 1550 2600
Wire Wire Line
	1400 2600 1700 2600
Wire Wire Line
	1700 3100 1700 3250
Connection ~ 1700 4350
Wire Wire Line
	1700 3650 1700 4350
Wire Wire Line
	1850 3850 1400 3850
Connection ~ 2700 1500
Wire Wire Line
	2700 1650 2700 1150
Wire Wire Line
	2900 950  2900 1100
Wire Wire Line
	2700 1150 2500 1150
Connection ~ 6950 1750
Wire Wire Line
	6650 1750 7150 1750
Connection ~ 6750 1750
Wire Wire Line
	3850 1100 4050 1100
Wire Wire Line
	4050 1500 2700 1500
Connection ~ 2900 1500
Wire Wire Line
	3450 1400 3450 1500
Connection ~ 3450 1500
Wire Wire Line
	4050 1100 4050 950 
Wire Wire Line
	3900 3450 3750 3450
Wire Wire Line
	3750 3950 4050 3950
Wire Wire Line
	3750 3650 3900 3650
Wire Wire Line
	3900 3650 3900 3550
Wire Wire Line
	2050 3550 2150 3550
Wire Wire Line
	2050 3950 2150 3950
Wire Wire Line
	5450 4050 5300 4050
Wire Wire Line
	5300 4050 5300 4550
Wire Wire Line
	5300 4550 5450 4550
Wire Wire Line
	5450 4250 5350 4250
Wire Wire Line
	5350 4250 5350 4450
Wire Wire Line
	5350 4450 5450 4450
Wire Wire Line
	4400 3700 4400 3550
Wire Wire Line
	4400 3550 3900 3550
Connection ~ 4050 3550
Wire Wire Line
	1400 4050 1400 4200
Wire Wire Line
	1400 4550 1400 4700
Wire Wire Line
	5450 4950 5450 4650
Connection ~ 5450 4750
Wire Wire Line
	2150 4150 1850 4150
Wire Wire Line
	1850 4150 1850 3850
Wire Wire Line
	3750 2950 3750 3050
Wire Wire Line
	3750 3050 3900 3050
Wire Wire Line
	2150 3050 2050 3050
Wire Wire Line
	2150 3450 2050 3450
Wire Wire Line
	5350 1750 5350 1800
Connection ~ 6850 1750
Connection ~ 7050 1750
Wire Wire Line
	5350 2200 5350 2350
Wire Wire Line
	2500 1250 2700 1250
Connection ~ 2700 1250
Wire Wire Line
	2900 1100 3050 1100
Wire Wire Line
	2500 1050 2750 1050
Wire Wire Line
	2750 1050 2750 950 
Wire Wire Line
	1400 4350 2150 4350
Wire Wire Line
	1400 3850 1400 3650
Wire Wire Line
	1400 3100 1400 3250
Wire Wire Line
	1550 2500 1550 2600
Wire Wire Line
	6900 1750 6900 1950
Connection ~ 6900 1750
Connection ~ 7750 1750
Connection ~ 7550 1750
Wire Wire Line
	4350 4450 4350 4350
Wire Wire Line
	4850 4950 4850 5000
Wire Wire Line
	5450 4350 3750 4350
Connection ~ 4350 4350
Wire Wire Line
	4850 5700 4850 6000
Wire Wire Line
	4850 6000 4350 6000
Connection ~ 4600 6000
$Comp
L +12V #PWR01
U 1 1 46B87CA5
P 5350 1150
F 0 "#PWR01" H 5350 1100 20  0001 C C
F 1 "+12V" H 5350 1250 30  0000 C C
	1    5350 1150
	1    0    0    -1  
$EndComp
NoConn ~ 5450 3950
NoConn ~ 2150 4450
NoConn ~ 2150 4250
NoConn ~ 3750 4450
NoConn ~ 3750 4250
$Comp
L R R5
U 1 1 46B771FB
P 4850 4700
F 0 "R5" V 4930 4700 50  0000 C C
F 1 "5K6" V 4850 4700 50  0000 C C
	1    4850 4700
	1    0    0    -1  
$EndComp
$Comp
L R R4
U 1 1 46B771DA
P 4350 4700
F 0 "R4" V 4430 4700 50  0000 C C
F 1 "5K6" V 4350 4700 50  0000 C C
	1    4350 4700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 46B77059
P 4600 6150
F 0 "#PWR02" H 4600 6150 30  0001 C C
F 1 "GND" H 4600 6080 30  0001 C C
	1    4600 6150
	1    0    0    -1  
$EndComp
$Comp
L BI_LED D5
U 1 1 46B7702B
P 4850 5350
F 0 "D5" H 5150 5450 50  0000 C C
F 1 "BI_LED" H 5200 5250 50  0000 C C
	1    4850 5350
	0    1    1    0   
$EndComp
$Comp
L BI_LED D4
U 1 1 46B77018
P 4350 5350
F 0 "D4" H 4650 5450 50  0000 C C
F 1 "BI_LED" H 4700 5250 50  0000 C C
	1    4350 5350
	0    1    1    0   
$EndComp
$Comp
L +5V #PWR03
U 1 1 46B75D84
P 1550 2500
F 0 "#PWR03" H 1550 2590 20  0001 C C
F 1 "+5V" H 1550 2590 30  0000 C C
	1    1550 2500
	1    0    0    -1  
$EndComp
$Comp
L R R3
U 1 1 46B75D76
P 1700 2850
F 0 "R3" V 1780 2850 50  0000 C C
F 1 "1K8" V 1700 2850 50  0000 C C
	1    1700 2850
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 46B75D60
P 1400 2850
F 0 "R2" V 1480 2850 50  0000 C C
F 1 "1K8" V 1400 2850 50  0000 C C
	1    1400 2850
	1    0    0    -1  
$EndComp
$Comp
L LED D3
U 1 1 46B75D1E
P 1700 3450
F 0 "D3" H 1700 3550 50  0000 C C
F 1 "LED" H 1700 3350 50  0000 C C
	1    1700 3450
	0    1    1    0   
$EndComp
$Comp
L LED D2
U 1 1 46B75CB9
P 1400 3450
F 0 "D2" H 1400 3550 50  0000 C C
F 1 "LED" H 1400 3350 50  0000 C C
	1    1400 3450
	0    1    1    0   
$EndComp
$Comp
L +12V #PWR04
U 1 1 463A9FF1
P 2900 950
F 0 "#PWR04" H 2900 900 20  0001 C C
F 1 "+12V" H 2900 1050 30  0000 C C
	1    2900 950 
	1    0    0    -1  
$EndComp
$Comp
L MOLEX_4PIN M02
U 1 1 463A9D69
P 1900 1200
F 0 "M02" H 1950 950 60  0000 C C
F 1 "MOLEX_4PIN" H 2200 1500 60  0000 C C
	1    1900 1200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR05
U 1 1 46319B6C
P 6900 1950
F 0 "#PWR05" H 6900 1950 30  0001 C C
F 1 "GND" H 6900 1880 30  0001 C C
	1    6900 1950
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR06
U 1 1 46319B62
P 8050 1700
F 0 "#PWR06" H 8050 1650 20  0001 C C
F 1 "+12V" H 8050 1800 30  0000 C C
	1    8050 1700
	1    0    0    -1  
$EndComp
$Comp
L AMP P05
U 1 1 463198A7
P 7200 1800
F 0 "P05" H 7200 1800 60  0000 C C
F 1 "AMP" H 7200 1800 60  0000 C C
	1    7200 1800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR07
U 1 1 45A40DA1
P 5350 2350
F 0 "#PWR07" H 5350 2350 30  0001 C C
F 1 "GND" H 5350 2280 30  0001 C C
	1    5350 2350
	1    0    0    -1  
$EndComp
$Comp
L LED D1
U 1 1 45A40D97
P 5350 2000
F 0 "D1" H 5350 2100 50  0000 C C
F 1 "LED" H 5350 1900 50  0000 C C
	1    5350 2000
	0    1    1    0   
$EndComp
$Comp
L R R1
U 1 1 45A40D8A
P 5350 1500
F 0 "R1" V 5430 1500 50  0000 C C
F 1 "560R" V 5350 1500 50  0000 C C
	1    5350 1500
	1    0    0    -1  
$EndComp
$Comp
L CP C5
U 1 1 45A40CF5
P 2050 3250
F 0 "C5" H 2100 3350 50  0000 L C
F 1 "1uF" H 2100 3150 50  0000 L C
	1    2050 3250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR08
U 1 1 45A40C07
P 4400 3700
F 0 "#PWR08" H 4400 3700 30  0001 C C
F 1 "GND" H 4400 3630 30  0001 C C
	1    4400 3700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR09
U 1 1 45A40C01
P 1400 4700
F 0 "#PWR09" H 1400 4700 30  0001 C C
F 1 "GND" H 1400 4630 30  0001 C C
	1    1400 4700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR010
U 1 1 45A40BFC
P 1400 4200
F 0 "#PWR010" H 1400 4200 30  0001 C C
F 1 "GND" H 1400 4130 30  0001 C C
	1    1400 4200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR011
U 1 1 45A40BF0
P 5450 4950
F 0 "#PWR011" H 5450 4950 30  0001 C C
F 1 "GND" H 5450 4880 30  0001 C C
	1    5450 4950
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P3
U 1 1 45A40B82
P 1050 3950
F 0 "P3" V 1000 3950 40  0000 C C
F 1 "CONN_2" V 1100 3950 40  0000 C C
	1    1050 3950
	-1   0    0    1   
$EndComp
$Comp
L CONN_2 P2
U 1 1 45A40B73
P 1050 4450
F 0 "P2" V 1000 4450 40  0000 C C
F 1 "CONN_2" V 1100 4450 40  0000 C C
	1    1050 4450
	-1   0    0    1   
$EndComp
$Comp
L DB9 J1
U 1 1 45A40B59
P 5900 4350
F 0 "J1" H 5900 4900 70  0000 C C
F 1 "DB9" H 5900 3800 70  0000 C C
	1    5900 4350
	1    0    0    1   
$EndComp
$Comp
L +5V #PWR012
U 1 1 45A40B48
P 3750 2950
F 0 "#PWR012" H 3750 3040 20  0001 C C
F 1 "+5V" H 3750 3040 30  0000 C C
	1    3750 2950
	1    0    0    -1  
$EndComp
$Comp
L CP C4
U 1 1 45A40B38
P 4050 3750
F 0 "C4" H 4100 3850 50  0000 L C
F 1 "1uF" H 4100 3650 50  0000 L C
	1    4050 3750
	1    0    0    -1  
$EndComp
$Comp
L CP C3
U 1 1 45A40B2E
P 3900 3250
F 0 "C3" H 3950 3350 50  0000 L C
F 1 "1uF" H 3950 3150 50  0000 L C
	1    3900 3250
	-1   0    0    1   
$EndComp
$Comp
L CP C2
U 1 1 45A40B29
P 2050 3750
F 0 "C2" H 2100 3850 50  0000 L C
F 1 "1uF" H 2100 3650 50  0000 L C
	1    2050 3750
	1    0    0    -1  
$EndComp
$Comp
L MAX232 U2
U 1 1 45A40B1C
P 2950 3750
F 0 "U2" H 2950 4600 70  0000 C C
F 1 "MAX232" H 2950 2900 70  0000 C C
	1    2950 3750
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR013
U 1 1 45A40A81
P 2700 1650
F 0 "#PWR013" H 2700 1650 30  0001 C C
F 1 "GND" H 2700 1580 30  0001 C C
	1    2700 1650
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR014
U 1 1 45A40A6C
P 4050 950
F 0 "#PWR014" H 4050 1040 20  0001 C C
F 1 "+5V" H 4050 1040 30  0000 C C
	1    4050 950 
	1    0    0    -1  
$EndComp
$Comp
L CP C1
U 1 1 45A40A1C
P 4050 1300
F 0 "C1" H 4100 1400 50  0000 L C
F 1 "100uF" H 4100 1200 50  0000 L C
	1    4050 1300
	1    0    0    -1  
$EndComp
$Comp
L CP C6
U 1 1 45A40A15
P 2900 1300
F 0 "C6" H 2950 1400 50  0000 L C
F 1 "4700uF" H 2950 1200 50  0000 L C
	1    2900 1300
	1    0    0    -1  
$EndComp
$Comp
L 78L05 U1
U 1 1 45A409E1
P 3450 1150
F 0 "U1" H 3600 954 60  0000 C C
F 1 "78L05" H 3450 1350 60  0000 C C
	1    3450 1150
	1    0    0    -1  
$EndComp
Text Notes 4450 1800 0    60   ~
Power-on LED
Text Notes 1500 4850 0    60   ~
RS232 to TTL converter
Text Notes 2100 650  0    60   ~
Power in and voltage regulator
Text Notes 6500 2200 0    60   ~
Power output connectors
Text Notes 5450 5150 0    60   ~
RS232 socket
$EndSCHEMATC
