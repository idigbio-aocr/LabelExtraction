#!/usr/bin/env bash

SERVER="aocr1.acis.ufl.edu:8000"

usage()
{
cat << EOF
usage: $0 options

This script run the test1 or test2 over a machine.

OPTIONS:
   -h      Show this message
   -f      Filename
   -i      UUID or Filename (Optional if filename is <UUID>.type or <NAME>.type)
   -n      Your Name
   -s      A name for your software
   -t      Submission Type (one of: ocr, silver-parse, gold-parse)
EOF
}

FILE=
NAME=
SOFTWARE=
TYPE=
ID=
while getopts “hf:i:n:s:t:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         f)
             FILE=$OPTARG
             ;;
         n)
             NAME=$OPTARG
             ;;
         i)
             ID=$OPTARG
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

if [[ -z $FILE ]] || [[ -z $NAME ]] || [[ -z $SOFTWARE ]] || [[ -z $TYPE ]]
then
     usage
     exit 1
fi

if [[ -z $ID ]]
then
    ID=`basename $FILE | cut -d. -f1`
fi

curl -F "user=$NAME" -F "software=$SOFTWARE" -"F file=@$FILE" http://$SERVER/scoring/$TYPE/$ID?json=1
