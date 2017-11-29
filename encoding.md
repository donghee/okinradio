1. hinting
MP4Box

2. encoding

3. padding and resize

resize
 - http://sonnati.wordpress.com/2012/10/19/ffmpeg-the-swiss-army-knife-of-internet-streaming-part-vi/

resize image

ffmpeg -i static/archives/Jarip_002_funfunfunfun_0605.jpg -vf "scale=720:406, pad=720:480:0:37:black" Jarip_002_funfunfunfun_0605.jpg
