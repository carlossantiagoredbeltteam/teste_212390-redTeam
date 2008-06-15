# generates a Lookuptable for the following termistor
# KTY 84-130
# http://www.datasheetcatalog.org/datasheet/philips/KTY84_SERIES_5.pdf


resistorValues = [
460,
498,
538,
581,
626,
672,
722,
773,
826,
882,
940,
1000,
1062,
1127,
1194,
1262,
1334,
1407,
1482,
1560,
1640,
1722,
1807,
1893,
1982,
2073,
2166,
2261,
2357,
2452,
2542,
2624]

tempValues = range(-10, 301, 10)

if len(tempValues) != len(resistorValues):
	print "Length of temValues %d and resistorValues %d does not match" % (len(tempValues), len(resistorValues))
else:
	print "#define NUMTEMPS %d" % (len(tempValues))
	print "short temptable[NUMTEMPS][2] = {"
	for i in range(0, len(tempValues)):
		current = 5.0/(1777.0+resistorValues[i])
		voltage = current*resistorValues[i]
		adValue = round(voltage*1023.0/5.0)
		print "   {%d, %d}," % (adValue, tempValues[i])
	print "};"
