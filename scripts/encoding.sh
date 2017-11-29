
#ffmpeg -i $1 -vcodec libx264 -vprofile high -preset slower -b:v 1000k -vf scale=-1:480 -threads 0 -acodec libmp3lame -ab 196k output_480.mp4
ffmpeg -i $1 -vcodec libx264 -vprofile high -preset slower -b:v 1000k -vf scale=720:-1 -threads 0 -acodec copy $2
# ffmpeg -i $1 -vcodec libx264 -vprofile high -preset slower -b:v 1000k -vf scale=720:-1 -threads 0 -acodec libmp3lame -ab 196k $2
#ffmpeg version 0.10.6-6:0.10.6-0ubuntu0jon1~precise1 Copyright (c) 2000-2012 the FFmpeg developers

