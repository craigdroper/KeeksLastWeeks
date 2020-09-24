#!/usr/bin/env python3

import sys
import math
from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont

filename = sys.argv[1]
tilewidth = int(sys.argv[2])
tileheight = int(sys.argv[3])
basefile, ext = filename.split('.')

img = Image.open(filename)
imgW, imgH = img.size
draw = ImageDraw.Draw(img)
#font = ImageFont.truetype('sans-serif.ttf', 16)
# Ceiling to cover inconsistent padding on the last tiles
# For example, all tiles have padding, except for the last one
sheetWidth = math.ceil(imgW / tilewidth)
sheetHeight = math.ceil(imgH / tileheight)
for y in range(sheetHeight):
    for x in range(sheetWidth):
        #draw.text((x*tilewidth, y*tileheight), '%d' % (x + y*sheetWidth), (255, 0, 0), font=font)
        draw.text((x*tilewidth, y*tileheight), '%d' % (x + y*sheetWidth), (255, 0, 0))
img.save('%s_numbered.%s' % (basefile, ext))
