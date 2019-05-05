#/bin/#!/usr/bin/env bash

#testpointformat.sh

if [ $# -eq 1 ]
  then awk -F"[,;]" '
NR == 2 {
	printf "["
}
NR > 3{
printf ",\n"
}
NR > 2{
	printf "[\"%s\", \"%s\", [%s,%s,0], \"%s\", %s, \"%s\", \"%s\"]",$1,$2,substr($3, 1, length($3)-2),substr($4, 1, length($4)-2),$5,$6,$7,$8
}
END{
	printf "]\n"
}
' $1

  else echo "usage testpointformat.sh filename.csv"
fi
