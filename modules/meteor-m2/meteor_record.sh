#!/bin/bash

### WARNING: all dates and times must be in the UTC!

#startT=$(date +%H%M -d "$DATE + 1 min" -u)
#stopT=$(date +%H%M -d "$DATE + $duration sec" -u)
#durationMin=$(bc <<< "$duration/60 +2")

#
# recording
#
#echo "$startT-$stopT, duration: $durationMin min"
#mlrpt -c M2-1-72k.cfg -s $startT-$stopT -t $durationMin

startT=$(date +%H%M -d "$DATE + 1 min" -u)
stopT=$(date +%H%M -d "$DATE + $duration sec" -u)
durationMin=$(bc <<< "$duration/60 +2")

#
# recording
#
echo "$startT-$stopT, duration: $durationMin min"

# TODO: read Meteor configuration file for configuration data to pass on.
# mlrpt -s $startT-$stopT -t $durationMin -c M2-1-SA7BNT.cfg


# $1 = Satellite Name
# $2 = Frequency
# $3 = FileName base
# $4 = TLE File
# $5 = EPOC start time
# $6 = Time to capture
# $7 = Satellite max elevation

echo "Satellite Name=$1"
echo "Frequency=$2"
echo "FileName base=$3"
echo "TLE File=$4"
echo "EPOC start time=$5"
echo "Time to capture=$6"
echo "Satellite max elevation=$7"

rawDirectory="${recdir}/raw"
rawAudioFile="${rawDirectory}/${3}.wav"
processedFile="${recdir}/${3}"
normalisedAudioFile="${processedFile}.wav"
demodulatedAudioFile="${processedFile}.qpsk"

# Create folders if they don't exist
mkdir -p $rawDirectory

echo "Starting rtl_fm record"
timeout ${6} rtl_fm -f ${2} -M raw -s 288k -g 49.6 -d 1 -A fast -F 9 -E deemp -E dc -E offset -p -2.2 | sox -t raw -r 288k -c 2 -b 16 -e s - -t wav $rawAudioFile rate 96k

echo "Normalization in progress"
sox $rawAudioFile $normalisedAudioFile gain -n

# Remove the raw audio file. We don't need it anymore, as we can just
# use the normalised audio file.
rm "${recdir}/raw/${3}.wav"
