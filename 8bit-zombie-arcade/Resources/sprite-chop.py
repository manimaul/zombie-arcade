#!/usr/bin/env python

##### Notes: Jason and Christian
# If you want to run this on OSX, you will need the following:
# 1.) Non-system python... (python from homebrew)
# 2.) PIL (python image library)... $pip install PIL
#	  I believe pip comes with python when installing from homebrew
# 3.) Imagemagick... $brew install imagemagick
#
#

import Image
import os

#sprite width and height
tile_size = 128

def getBox(x = 0, y = 0):
	left = 128 * x
	upper = 128 * y
	right = left + 128
	lower = upper + 128
	return ( left, upper, right, lower )

def renderSequence(img, name, sequence, frames, x, y):
	out_dir = name + ".atlas"
	if not os.path.isdir(out_dir):
		os.mkdir(out_dir)

	for i in range(frames):
		box = getBox(x, y)
		sprite = img.crop(box)
		sprite.save(os.path.join(out_dir, "%s_%d.png" %(sequence, i)))
		x += 1

	cmd = "convert -delay 20 -loop 999 -dispose Background %s/%s_*.png annimated_gif_previews/%s.gif" %(out_dir, sequence, sequence)
	os.popen(cmd)

def renderSequenceSet(img, name, anim_angles, anim_sequences):
	for angle in anim_angles:
		y = anim_angles.index(angle) #row of sprite sheet
		x = 0
		for sequence, num_frames in anim_sequences: #stance, lurch, slam ... etc
			sequence_name = name + "_" + sequence + "_" + angle #woman_walk_west
			#num_frames = anim_sequences[sequence]
			print "rendering name:%s x:%d y:%d frames:%d" %(sequence_name, x, y, num_frames)
			renderSequence(img, name, sequence_name, num_frames, x, y)
			x = x + num_frames


#### zombie
#8 angles
name = "zombie"
sprite_sheet = "zombie.png"
img = Image.open(sprite_sheet)
anim_angles = [ "west", "northwest", "north", "northeast", "east", "southeast", "south", "southwest" ]
anim_sequences = [ ("stance",4), ("lurch",8), ("slam",4), ("bite",4), ("block",2), ("fall",6), ("die",8) ]
renderSequenceSet(img, name, anim_angles, anim_sequences)


#### woman
#8 angles
name = "woman"
sprite_sheet = "woman.png"
img = Image.open(sprite_sheet)
anim_angles = [ "west", "northwest", "north", "northeast", "east", "southeast", "south", "southwest" ]
anim_sequences = [ ("stance",4), ("walk",8), ("slam",4), ("bite",2), ("die",6), ("cast",4), ("shoot",4) ]
renderSequenceSet(img, name, anim_angles, anim_sequences)


