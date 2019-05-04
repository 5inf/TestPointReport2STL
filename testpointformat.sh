#/bin/#!/usr/bin/env bash

#testpointformat.sh

awk -F"," 'NR > 1 {printf "[\"%s\", \"%s\", [%s,%s,0], \"%s\", %s, \"%s\", \"%s\"],\n",$1,$2,substr($3, 1, length($3)-2),substr($4, 1, length($4)-2),$5,$6,$7,$8}' testpointdata.csv
