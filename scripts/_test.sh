#!/bin/sh

ffmpeg -i $1 -vcodec libx264 -vprofile high -preset slower -b:v 1000k -vf "scale=720:406, pad=720:480:0:37:black" -acodec copy $2
MP4Box -hint $2
