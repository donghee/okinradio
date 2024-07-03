# -*- coding: utf-8 -*-
#!/usr/bin/python
#ffmpeg -i 1_230596_531002.flv -vpre libx264-ipod640  -vcodec libx264 -crf 22 -threads 0 output.mp4
head = """<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:itunes="http://www.itunes.com/DTDs/Podcast-1.0.dtd">
<channel>
<title>Okin Internet Radio Station Studio+82</title>
<link>http://okin.cc</link>
<description> 옥인 인터넷 라디오 스테이션 입니다. feed URL: http://okin.cc/radio/rss.xml</description>
<language>ko-KO</language>
<lastBuildDate>%s</lastBuildDate>
<itunes:owner>
<itunes:name>옥인</itunes:name>
<itunes:email></itunes:email>
</itunes:owner>
<itunes:image href="http://okin.cc/radio/okinflag.jpg" />
<itunes:author>옥인</itunes:author>
"""

#<enclosure url="http://s3.amazonaws.com/donghee_videos/okinradiostation/%s"  type="video/mp4" length="%s"/>
body = """
<item>
<title>%s</title>
<description>%s</description>
<pubDate>%s</pubDate>
<enclosure url="http://okin.cc/radio/okinradiostation/%s"  type="video/mp4" length="%s"/>
</item>
"""

tail = """
</channel>
</rss>
"""

import urllib
import glob
import datetime
import time
import os

def mtime(filename):
    return os.stat(filename).st_mtime


timeFormat = "%a, %d %b %Y %I:%M:%S +0900"
lastBuildDate = datetime.datetime.now().strftime(timeFormat)
print head % lastBuildDate

files = sorted(glob.glob("/home/hosting_users/okinradiostation/okinradiostation/*.mp4"), key=mtime)
files.reverse()

for filename in files:
	_filename = os.path.basename(filename)
	basename = _filename.split('.')[0]
        try:
            readme = open("/home/hosting_users/okinradiostation/okinradiostation/"+basename+".txt")
            try:
                title = readme.readline()
                description = readme.readline()
            finally:
                readme.close()
        except:
            title = basename
            description = basename

        pubdate = time.strftime(timeFormat,time.localtime(os.path.getmtime(filename)))
	urlencoded_filename = urllib.quote(_filename)
        size = os.path.getsize(filename)
	print body % (title, description, pubdate, urlencoded_filename,str(size) )

print tail
