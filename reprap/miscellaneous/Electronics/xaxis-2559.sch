v 20040111 1
C 37900 66900 1 0 0 pic16F628-1.sym
{
T 38200 70000 5 8 1 1 0 0 1
refdes=U1
T 39200 70000 5 10 1 1 0 0 1
device=PIC16F628A
T 37900 66900 5 10 0 0 0 0 1
footprint=dip18
}
C 41000 71900 1 0 0 5V-plus-1.sym
T 38600 66600 9 10 1 0 0 0 1
X Axis Controller
N 41200 71900 41200 68400 4
N 41200 68400 40600 68400 4
C 37300 68700 1 0 0 gnd-1.sym
C 36900 72600 1 270 0 resistor-1.sym
{
T 37200 72400 5 10 1 1 270 0 1
refdes=R1
T 36700 72400 5 10 1 1 270 0 1
value=4.7k
}
N 37000 71700 37000 69600 4
N 37000 69600 37900 69600 4
C 36800 73700 1 0 0 5V-plus-1.sym
N 37000 73700 37000 72600 4
T 34000 70600 9 10 1 0 90 0 1
Sync bus connector
C 33200 67700 1 0 0 resistor-1.sym
{
T 33400 68000 5 10 1 1 0 0 1
refdes=R2
T 33500 67500 5 10 1 1 0 0 1
value=1k
}
C 33200 64000 1 0 0 resistor-1.sym
{
T 33400 64300 5 10 1 1 0 0 1
refdes=R3
T 33500 63800 5 10 1 1 0 0 1
value=1k
}
C 33900 64100 1 0 0 5V-plus-1.sym
C 33900 67800 1 0 0 5V-plus-1.sym
N 37400 69000 37900 69000 4
N 40700 69600 40700 68700 4
N 40700 68700 40600 68700 4
N 40600 69000 40700 69000 4
N 40600 69300 40700 69300 4
C 40900 69200 1 0 0 gnd-1.sym
N 40600 69600 41000 69600 4
N 41000 69600 41000 69500 4
C 36300 64600 1 0 0 12V-plus-1.sym
T 31200 67300 9 10 1 0 0 0 1
Minimum detector
T 32100 63400 9 10 1 0 0 0 1
Maximum detector
N 37900 68400 37400 68400 4
N 37900 68700 34600 68700 4
N 34600 64400 33200 64400 4
C 36100 72600 1 270 0 resistor-1.sym
{
T 36400 72400 5 10 1 1 270 0 1
refdes=R4
T 35900 72400 5 10 1 1 270 0 1
value=4.7k
}
N 36200 73700 36200 72600 4
C 36000 73700 1 0 0 5V-plus-1.sym
N 36200 69300 37900 69300 4
N 36200 69300 36200 71700 4
C 34200 70900 1 0 0 EMBEDDEDconnector2-1.sym
[
P 35600 71100 35900 71100 1 0 1
{
T 34550 71050 5 8 1 1 0 0 1
pinnumber=2
T 34550 71050 5 8 0 0 0 0 1
pinseq=2
}
P 35600 71400 35900 71400 1 0 1
{
T 34550 71350 5 8 1 1 0 0 1
pinnumber=1
T 34550 71350 5 8 0 0 0 0 1
pinseq=1
}
L 35600 71400 34700 71400 3 0 0 0 -1 -1
L 35600 71100 34700 71100 3 0 0 0 -1 -1
T 34400 71900 5 10 0 0 0 0 1
device=CONNECTOR_2
B 34200 70900 500 700 3 0 0 0 -1 -1 0 -1 -1 -1 -1 -1
T 34400 72100 5 10 0 0 0 0 1
pins=2
T 34400 72300 5 10 0 0 0 0 1
class=IO
]
{
T 34200 71700 5 10 1 1 0 0 1
refdes=J1
}
N 35900 71400 37000 71400 4
N 35900 71100 36200 71100 4
C 35700 62900 1 270 0 EMBEDDEDconnector4-1.sym
[
P 36200 64300 36200 64600 1 0 1
{
T 36150 63150 5 8 1 1 90 2 1
pinnumber=3
T 36150 63150 5 8 0 0 90 2 1
pinseq=3
}
P 36500 64300 36500 64600 1 0 1
{
T 36450 63150 5 8 1 1 90 2 1
pinnumber=2
T 36450 63150 5 8 0 0 90 2 1
pinseq=2
}
P 35900 64300 35900 64600 1 0 1
{
T 35850 63150 5 8 1 1 90 2 1
pinnumber=4
T 35850 63150 5 8 0 0 90 2 1
pinseq=4
}
L 36500 64300 36500 63400 3 0 0 0 -1 -1
L 36200 64300 36200 63400 3 0 0 0 -1 -1
L 35900 64300 35900 63400 3 0 0 0 -1 -1
T 36600 64700 5 10 0 0 90 2 1
device=CONNECTOR_4
P 36800 64300 36800 64600 1 0 1
{
T 36750 63150 5 8 1 1 90 2 1
pinnumber=1
T 36750 63150 5 8 0 0 90 2 1
pinseq=1
}
L 36800 64300 36800 63400 3 0 0 0 -1 -1
B 35700 62900 1300 500 3 0 0 0 -1 -1 0 -1 -1 -1 -1 -1
T 36800 64700 5 10 0 0 90 2 1
class=IO
T 37000 64700 5 10 0 0 90 2 1
pins=4
]
{
T 37100 62900 5 10 1 1 90 2 1
refdes=J1
}
C 39100 62900 1 270 0 EMBEDDEDconnector4-1.sym
[
P 39600 64300 39600 64600 1 0 1
{
T 39550 63150 5 8 1 1 90 2 1
pinnumber=3
T 39550 63150 5 8 0 0 90 2 1
pinseq=3
}
P 39900 64300 39900 64600 1 0 1
{
T 39850 63150 5 8 1 1 90 2 1
pinnumber=2
T 39850 63150 5 8 0 0 90 2 1
pinseq=2
}
P 39300 64300 39300 64600 1 0 1
{
T 39250 63150 5 8 1 1 90 2 1
pinnumber=4
T 39250 63150 5 8 0 0 90 2 1
pinseq=4
}
L 39900 64300 39900 63400 3 0 0 0 -1 -1
L 39600 64300 39600 63400 3 0 0 0 -1 -1
L 39300 64300 39300 63400 3 0 0 0 -1 -1
T 40000 64700 5 10 0 0 90 2 1
device=CONNECTOR_4
P 40200 64300 40200 64600 1 0 1
{
T 40150 63150 5 8 1 1 90 2 1
pinnumber=1
T 40150 63150 5 8 0 0 90 2 1
pinseq=1
}
L 40200 64300 40200 63400 3 0 0 0 -1 -1
B 39100 62900 1300 500 3 0 0 0 -1 -1 0 -1 -1 -1 -1 -1
T 40200 64700 5 10 0 0 90 2 1
class=IO
T 40400 64700 5 10 0 0 90 2 1
pins=4
]
{
T 40500 62900 5 10 1 1 90 2 1
refdes=J2
}
C 39700 64600 1 0 0 12V-plus-1.sym
C 38500 64600 1 0 0 5V-plus-1.sym
N 39300 64600 38700 64600 4
C 39100 65000 1 0 0 gnd-1.sym
N 39600 64600 39600 65300 4
N 37900 67500 37700 67500 4
N 37900 67800 36800 67800 4
N 36800 67800 36800 64600 4
N 37700 67500 37700 65900 4
N 40200 65900 37700 65900 4
N 40200 64600 40200 65900 4
T 39200 62500 9 10 1 0 0 0 1
To Y Controller
T 35800 62500 9 10 1 0 0 0 1
To Comms module
C 31000 67600 1 0 0 connector3-1.sym
{
T 31000 68700 5 10 1 1 0 0 1
refdes=J4
}
C 31500 63900 1 0 0 connector3-1.sym
{
T 31500 65000 5 10 1 1 0 0 1
refdes=J3
}
N 32700 68100 37900 68100 4
N 33200 67800 32700 67800 4
C 32600 68100 1 0 0 gnd-1.sym
C 33100 64400 1 0 0 gnd-1.sym
N 48300 68100 48300 61900 4
N 48300 61900 46500 61900 4
N 40600 68100 48300 68100 4
N 40600 67800 48000 67800 4
N 48000 67800 48000 62300 4
N 48000 62300 46500 62300 4
N 40600 67500 46900 67500 4
N 40600 67200 46500 67200 4
N 46500 67200 46500 64700 4
C 43900 62800 1 0 0 gnd-1.sym
N 44000 63500 44000 63100 4
C 44500 61400 1 0 0 UDN2559.sym
{
T 46200 65200 5 10 1 1 0 6 1
refdes=U2
}
N 46900 67500 46900 64300 4
N 46900 64300 46500 64300 4
N 44000 63500 44500 63500 4
N 44500 63100 44000 63100 4
C 46700 62800 1 0 0 gnd-1.sym
N 46800 63500 46800 63100 4
N 46800 63500 46500 63500 4
N 46500 63100 46800 63100 4
C 47200 62800 1 0 0 5V-plus-1.sym
N 47400 62800 47400 62700 4
N 47400 62700 46500 62700 4
C 43900 64300 1 0 0 12V-plus-1.sym
C 43900 62300 1 0 0 12V-plus-1.sym
N 44100 64300 44500 64300 4
N 44100 62300 44500 62300 4
C 41500 65500 1 180 1 connector6-1.sym
{
T 41600 63500 5 10 1 1 0 2 1
refdes=J5
}
C 43600 64800 1 90 0 nc-bottom-1.sym
C 43200 65800 1 0 0 12V-plus-1.sym
N 43200 65300 43400 65300 4
N 43400 65300 43400 65800 4
T 41300 64000 9 10 1 0 90 0 1
X Axis Motor
N 43200 64700 44500 64700 4
N 43200 64400 43700 64400 4
N 43700 64400 43700 63900 4
N 43700 63900 44500 63900 4
N 43200 64100 43500 64100 4
N 43500 64100 43500 62700 4
N 43500 62700 44500 62700 4
N 43200 63800 43200 61900 4
N 43200 61900 44500 61900 4
C 37300 68100 1 0 0 gnd-1.sym
N 37900 67200 37900 66400 4
N 37900 66400 47500 66400 4
N 47500 66400 47500 63900 4
N 47500 63900 46500 63900 4
C 34500 69800 1 270 0 resistor-1.sym
{
T 34800 69600 5 10 1 1 270 0 1
refdes=R5
T 34300 69600 5 10 1 1 270 0 1
value=10k
}
C 34400 70000 1 0 0 5V-plus-1.sym
N 34600 70000 34600 69800 4
N 34600 64400 34600 68900 4
N 39200 65300 39600 65300 4
C 35100 64600 1 0 0 5V-plus-1.sym
N 35900 64600 35300 64600 4
C 35700 65000 1 0 0 gnd-1.sym
N 36200 64600 36200 65300 4
N 35800 65300 36200 65300 4