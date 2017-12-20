#!/bin/bash
# --------------------------------------------------------------------
# This is a free shell script under GNU GPL version 2.0 or above
# Copyright (C) 2017 Thomas Goelles.

header=${1:-sico_specs.h} # header file, default is sico_specs.h
fileoutput=${2:-~/Desktop} # the path for the csv file output, default is the desktop 

if [ ! -f $header  ]; then
    echo "file not found!" 
fi

# Checking for commands
hash nocomment.sh 2>/dev/null || { echo >&2 "datagen requires nocomment.sh but it's not installed.  Aborting."; exit 1; }
hash md5 2>/dev/null || { echo >&2 "datagen requires md5 but it's not installed.  Please install md5."; exit 1; }
hash mktemp 2>/dev/null || { echo >&2 "datagen requires mktemp but it's not installed.  Aborting."; exit 1; }

# Variables
datamd5=`md5 $header | awk '{print $4}'`
mytempdir=`mktemp -d -t datagen.XXXXXX`

# Generating a CSV file from the header file.

# Remove comments.
cat "$header" | nocomment.sh  > /tmp/tmp1
# Remove all lines which start with !
sed '/^\!/d'  /tmp/tmp1 | 
# Remove all empty lines.
sed '/^$/d' | 
# Replace #define GRL and so on with DOMAIN
sed 's/#define\ GRL/DOMAIN GRL/g' |
sed 's/#define\ EMTP2SGE/DOMAIN EMTP2SGE/g' |
sed 's/#define\ ANT/DOMAIN ANT/g' |
sed 's/#define\ NHEM/DOMAIN NHEM/g' |
sed 's/#define\ SCAND/DOMAIN SCAND/g' |
sed 's/#define\ TIBET/DOMAIN TIBET/g' |
sed 's/#define\ NMARS/DOMAIN NMARS/g' |
sed 's/#define\ SMARS/DOMAIN SMARS/g' |
sed 's/#define\ XYZ/DOMAIN XYZ/g' |

# Remove #define and space.
sed 's/#define\ //g' >  $mytempdir/total
# only first word
cat $mytempdir/total  | awk '{print $1}' >  $mytempdir/variablenames

 # Replacing linepreaks with ; and add some more ;;; at the end.
tr '\n' ' ' <  $mytempdir/variablenames | sed 's/\ /;/g' | eval "sed 's/$/header;datamd5;;;/'" >  $mytempdir/csvheader

# Now the second part with the data.
cat $mytempdir/total  | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' > $mytempdir/values

# Replacing linepreaks with ; and add some more ;;; at the end
tr '\n' ';' <  $mytempdir/values | eval "sed 's/$/$header;$datamd5;;;/'" > $mytempdir/csvvalues

# Append two files
cat  $mytempdir/csvheader  $mytempdir/csvvalues > $fileoutput/SICOPOLIS_database_$datamd5.csv

# removing temp files
rm -r  $mytempdir/ 2> /dev/null

echo 'done'