#!/bin/sh

#./encoding.sh $1 output720x.mp4
#./padding.sh output720x.mp4 output720x480.mp4
#rm output720x.mp4
#MP4Box -hint output720x480.mp4

width=720
height=480

ffmpeg -i $1 -vcodec libx264 -vprofile high -preset slower -b:v 1000k -vf "scale=iw*min($width/iw\,$height/ih):ih*min($width/iw\,$height/ih), pad=$width:$height:($width-iw*min($width/iw\,$height/ih))/2:($height-ih*min($width/iw\,$height/ih))/2" -acodec copy $2
MP4Box -hint $2
