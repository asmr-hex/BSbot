'''
Created on Nov 4, 2014

@author: connor walsh
'''
#!/usr/bin/python
import codecs, sys, os, imp
import abstracts2features

#Training & Test Data Directory
trainDir = '../raw/Train'
testDir = '../raw/Test'

#Get list of all Train & Test file names
train = os.listdir(trainDir)
test = os.listdir(testDir)

#Total Number of Files to transform
N = len(train) + len(test)
n = 0

#Generate transformed features for each raw data file
for fn in train:
	cmd = 'python abstracts2features.py '
	if fn.endswith('.txt'):
		if fn == 'labels.txt':
			cp = 'cp ' + trainDir + '/' + fn 
			cp+= ' ../data/Train/' + fn
			os.system(cp)
		else:
			#cmd += trainDir + '/' + fn + ' ../data/Train ' + fn 
			#os.system(cmd)
			rawFile = trainDir + '/' + fn
			saveDir = '../data/Train'
			saveName = fn
			abstracts2features.transform(rawFile,saveDir,saveName)
	n+=1
	print "Transforming raw data: " + str(int(float(n)/float(N) * 100)+1), "%           \r",
for fn in test:
	cmd = 'python abstracts2features.py '
	if fn.endswith('.txt'):
			#cmd += testDir + '/' + fn + ' ../data/Test ' + fn 
			#os.system(cmd)	
			rawFile = testDir + '/' + fn
			saveDir = '../data/Test'
			saveName = fn
			abstracts2features.transform(rawFile,saveDir,saveName)		
	n+=1
	print "Transforming raw data: " + str(int(float(n)/float(N) * 100)+1), "%           \r",
print "Success!\n"		


