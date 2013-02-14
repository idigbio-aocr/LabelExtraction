#!/usr/bin/env bash

usage()
{
cat << EOF
usage: $0 options

This script run the test1 or test2 over a machine.

OPTIONS:
   -h      Show this message
   -d      Directory of Files (Filenames must be <UUID>.type or <NAME>.type)
   -n      Your Name
   -s      A name for your software
   -t      Submission Type (one of: ocr, silver-parse, gold-parse)
EOF
}

DIR=
NAME=
SOFTWARE=
TYPE=
ID=
while getopts “hd:n:s:t:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         d)
             DIR=$OPTARG
             ;;
         n)
             NAME=$OPTARG
             ;;                      
         s)
             SOFTWARE=$OPTARG
             ;;
         t)
             TYPE=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $DIR ]] || [[ -z $NAME ]] || [[ -z $SOFTWARE ]] || [[ -z $TYPE ]]
then
     usage
     exit 1
fi

for f in `ls $DIR`; do
    echo "Submitting File $f"
    ./submit-file.sh -n "$NAME" -s "$SOFTWARE" -t "$TYPE" -f "$DIR/$f"
    echo
done
    
