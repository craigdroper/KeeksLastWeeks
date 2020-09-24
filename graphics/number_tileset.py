#!/usr/bin/env python3

import sys
from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont

filename = sys.argv[1]
tilesize = int(sys.argv[2])
basefile, ext = filename.split('.')

img = Image.open(filename)
draw = ImageDraw.Draw(img)
#font = ImageFont.truetype('sans-serif.ttf', 16)
for y in range(30):
    for x in range(37):
        #draw.text((x * tilesize, y*tilesize), '%d' % (x + y*tilesize), (255, 0, 0), font=font)
        draw.text((x * tilesize, y*tilesize), '%d' % (x + y*tilesize), (255, 0, 0))
img.save('%s_numbered.%s' % (basefile, ext))
