#!/bin/bash
#
# Extract the corrected interaction energy from a sequence of Gaussian
# log files
#
#     ./extract.sh 1 31
#
#   or
#
#     ./extract 31
#
# where the starting index of 1 is implied in the second case.
#

if [ $# -gt 1 ]; then
    x0=${1}
    shift
else
    x0=1
fi
xn=${1}

X_file="$(mktemp)"
cat job-mapping | sed -r 's/^.*parameters": \{"r":([0-9.]+).*$/\1/' > "$X_file"

E_file="$(mktemp)"
for x in $(seq $x0 $xn); do grep 'complexation energy.*corrected' ./jobs/$x/N2-N2.log; done | awk '{print $4;}' > "$E_file"

paste -d, "$X_file" "$E_file"
rm -f "$X_file" "$E_file"

