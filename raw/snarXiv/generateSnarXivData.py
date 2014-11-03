#!/usr/bin/python
# This script runs the snarXiv title/abstract generator 
# (Author: David Simmons-Duffin) and concatenates/stores 
# the output into seperate .txt files where each line is 
# an individual word.
# The naming scheme for generated .txt files is numeric
# (e.g. 0.txt, 1.txt, ...), though the cardinality is
# independent of content (or lack thereof in this case).
#
# Author: Connor Walsh

import os, sys, subprocess

#Get arguments (number of abstract to generate)
args = sys.argv
args.pop(0)
n = int(args[0])
print "Generating " + str(n) + " snarXiv abstracts..."

#Generate n abstracts
for i in range(n):
	#Call OCaml script to generate results
	jobList = subprocess.Popen("ocaml snarxiv.ml", stdout=subprocess.PIPE, shell=True)
	out, err = jobList.communicate()
	#Split into: Title \\ Authors \\ Comments \\ Subjects \\ Abstract
	out = out.split("\\\\")
	#Print title
	print "(" + str(i) + ")\t" + out[0]
	#Concatenate Title and Abstract
	Title = out[0].replace(' ', '\n')
	Abstract = out[4].replace(' ', '\n')
	out = "\n" + Title + "\\\\" + Abstract
	#Open result file
	fname = "results/" + str(i) + ".txt"
	result = open(fname, "w")
	#Write results to file
	result.write(out)
	result.close()



