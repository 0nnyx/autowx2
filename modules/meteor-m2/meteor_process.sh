#!/bin/bash
# Meteor M2-3 

processedFile="${recdir}/${1}"
imageFile="${imgdir}/${1}"
normalisedAudioFile="${processedFile}.wav"
demodulatedAudioFile="${processedFile}.qpsk"

# Demodulate the audio file
echo "Demodulation in progress (QPSK)"
meteor_demod -B -m oqpsk -o $demodulatedAudioFile $normalisedAudioFile

# Decode th demoodulated file
echo "Decoding in progress (QPSK to BMP)"
# medet_arm $demodulatedAudioFile $processedFile -cd -diff -q
meteor_decode -B -d -q -o "${imageFile}" $demodulatedAudioFile

# Get the image file extension
#if [ "$imageExtension" == "" ]; then
  imageExtension="jpg"
#fi

# Should we resize the image?
if [ "$resizeimageto" != "" ]; then
  echo "Resizing image to $resizeimageto px"
  resizeSwitch="-resize ${resizeimageto}x${resizeimageto}>"
fi

convert -quality 95 "${imageFile}.bmp" "${imageFile}.jpg"
rectify-jpg "${imageFile}.jpg"
mv "${imageFile}-rectified.jpg" "${imageFile}.jpg"

# Decide the file and make image.
#if [ -f $decodedAudioFile ]; then
#    echo "I got a successful ${3}.dec file. Creating false color image"

#    if [ $(date +%H) -lt 17 ]; then
#      ./meteor_decoder/medet $decodedAudioFile "${imageFile}" -d
#       ./meteor_decoder/medet $decodedAudioFile "${imageFile}" -r 65 -g 65 -b 64 -d #Winter Setting
#      ./meteor_decoder/medet $decodedAudioFile "${imageFile}" -r 64 -g 65 -b 65 -d #Winter Setting
#      ./meteor_decoder/medet $decodedAudioFile "${imageFile}" -r 64 -g 65 -b 66 -d #Winter Setting
#      convert -quality 90 "${imageFile}.bmp" "${imageFile}.jpg"
#      /home/pi/medet/rectify-jpg "${imageFile}.jpg"
#      mv "${imageFile}-rectified.jpg" "${imageFile}.jpg"
#    else
#      ./medet/medet_arm $decodedAudioFile "${imageFile}" -d
#      ./meteor_decoder/medet $decodedAudioFile "${imageFile}" -r 68 -g 68 -b 68 -d #Winter Setting
#      ./meteor_decoder/medet $decodedAudioFile "${imageFile}" -r 65 -g 65 -b 64 -d #Winter Setting
#      convert "${imageFile}" -rotate 180 "${imageFile}"
#      convert -quality 90 "${imageFile}.bmp" "${imageFile}.jpg"
#      /home/pi/medet/rectify-jpg "${imageFile}.jpg"
#      mv "${imageFile}-rectified.jpg" "${imageFile}.jpg"
#      convert -rotate 180 "${imageFile}.jpg" "${imageFile}.jpg"
#fi
    if [ -f "${imageFile}.jpg" ]; then
      rm "${imageFile}.bmp"
    fi
else
    echo "[DEBUG] Meteor Decoding failed, either a bad pass/low SNR or a software problem"
fi

#if [ "${removeFiles}" -ne "" ]; then
rm $normalisedAudioFile
rm $demodulatedAudioFile
#fi

# Remove old data
#removeOldData -t $keepDataForDays -d $rootMeteorImgDir
removeOldData -t 1 -d $rootMeteorRecDir
