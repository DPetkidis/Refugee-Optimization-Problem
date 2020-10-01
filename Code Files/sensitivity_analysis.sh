#!/bin/sh

# cleanup from previous run
rm -rf ./run* z.txt uSmall.txt uLarge.txt ./run*

for i in $(seq 500000 500000 20000000)
do
	x=$(( i / 500000 ))
	echo "Looping ... number "  $(( i / 500000 ))
	gams project_final.gms --B=$i -o=run$x.lst
done


# z
for i in $(seq 500000 500000 20000000)
do
	x=$(( i / 500000 ))
	grep -n "\-\-\-\-    248 VARIABLE ttt.L " run$x.lst >> z.txt
done

# small
for i in $(seq 500000 500000 20000000)
do
	x=$(( i / 500000 ))
	grep -A 2 "\-\-\-\-    248 VARIABLE uSmall.L" run$x.lst | grep -o "1.000" | wc -l >> uSmall.txt
done

#large
for i in $(seq 500000 500000 20000000)
do
	x=$(( i / 500000 ))
	# grep -n "\-\-\-\-    248 VARIABLE z.L " run$x.lst
	grep -A 2 "\-\-\-\-    248 VARIABLE uLarge.L" run$x.lst | grep -o "1.000" | wc -l >> uLarge.txt
done