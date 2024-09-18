#!/bin/bash
cd cnc_sounds;
declare -i VAR150=0;
declare -i VAR50=100;
for file in *
do
    #echo ${file%.*};
    VAR1=${file%.*};
    if [ $VAR1 -gt $VAR150 ];
    then
        VAR2=$(($VAR1 - $VAR50));
        mv $VAR1".WAV" $VAR2".WAV";
    fi
done