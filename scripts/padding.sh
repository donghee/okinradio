#!/bin/sh

# 720x480 pading
width=720
height=480

# ffmpeg -i $1 -vcodec libx264 -vprofile high -preset slower -b:v 1000k -vf "scale=720:406, pad=720:480:0:37:black" -acodec copy $2
ffmpeg -i $1 -vcodec libx264 -vprofile high -preset slower -b:v 1000k -vf "scale=iw*min($width/iw\,$height/ih):ih*min($width/iw\,$height/ih), pad=$width:$height:($width-iw*min($width/iw\,$height/ih))/2:($height-ih*min($width/iw\,$height/ih))/2" -acodec copy $2
