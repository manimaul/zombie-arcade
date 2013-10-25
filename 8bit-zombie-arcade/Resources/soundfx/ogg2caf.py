#!/usr/bin/env python

#requires ffmpeg and afconvert

import os

ogg_dir = "oggs"
wav_dir = "wavs"
caf_dir = "cafs"
ffmpeg_cmd = "ffmpeg -y -i %s %s"
afconvert_cmd = "afconvert -f caff -d LEI16@44100 -c 1 %s %s"

if not os.path.isdir(wav_dir):
	os.mkdir(wav_dir)

if not os.path.isdir(caf_dir):
	os.mkdir(caf_dir)

for eafile in os.listdir(ogg_dir):
	if eafile.endswith(".ogg"):
		wav_file = os.path.join(wav_dir, eafile[:-4]+".wav")
		ogg_file = os.path.join(ogg_dir, eafile)
		
		if not os.path.isfile(wav_file):
			cmd = ffmpeg_cmd %(ogg_file, wav_file)
			os.popen(cmd)
		
		caf_file = os.path.join(caf_dir, eafile[:-4]+".caf")
		if not os.path.isfile(caf_file):
			cmd = afconvert_cmd %(wav_file, caf_file)
			os.popen(cmd)
