#!/usr/bin/python
#sortTrainAndTest
#This script takes all raw data from arXiv and snarXiv and
#sorts 75% into training and 25% into test datasets

import os, shutil, random

negPath = './snarXiv/results/'
posPath = './arXiv/results/'

#Get list of file names
negFileNames = os.listdir(negPath)
posFileNames = os.listdir(posPath)

#Get the total number of data points, N
nNeg = len(negFileNames)
nPos = len(posFileNames)
N = nPos + nNeg
#Get number of training data points to use, trainN
trainN = int(0.75 * N)
#Get number of test data points to use, testN
testN = N - trainN
print "Total: %d\n" % N + "Train: %d\n" % trainN + "Test: %d\n" %testN

#Make train and test directories if they don't exist
if not os.path.exists('./Train/'):
	os.makedirs('./Train')
if not os.path.exists('./Test/'):
	os.makedirs('./Test')
	
#Get trainNpos and trainNneg
trainNpos = trainN / 2
trainNneg = trainN - trainNpos
#Get testNpos and testNneg
testNpos = nPos - trainNpos
testNneg = nNeg - trainNneg

#initialize list of labels
trainLabelsList = [0] * trainN
testLabelsList = [0] * testN

trainCount = 0
testCount = 0
#Copy data to training and testing directories
trainFileNumbers = range(0, trainN)
testFileNumbers = range(0, testN)

#Copy negative samples into training and testing directories
for k in range(0, nNeg):
	if k < trainNneg:
		#Get random index
		ind = random.randint(0,len(trainFileNumbers)-1)
		trainLabelsList[trainFileNumbers[ind]] = -1
		os.system("cp " + negPath + negFileNames[k] + " ./Train/%d.txt" % trainFileNumbers[ind])
		del trainFileNumbers[ind]
	else:
		#Get random index
		ind = random.randint(0,len(testFileNumbers)-1)
		testLabelsList[testFileNumbers[ind]] = -1
		os.system("cp " + negPath + negFileNames[k] + " ./Test/%d.txt" % testFileNumbers[ind])
		del testFileNumbers[ind]
	print "Transferring Negative Data: " + str(int(float(k)/float(nNeg) * 100)+1), "%           \r",
print "\nSuccess!"

#Copy positive samples into training and testing directories
for k in range(0, nPos):
	if k < trainNpos:
		#Get random index
		ind = random.randint(0,len(trainFileNumbers)-1)
		trainLabelsList[trainFileNumbers[ind]] = 1
		os.system("cp " + posPath + posFileNames[k] + " ./Train/%d.txt" % trainFileNumbers[ind])
		del trainFileNumbers[ind]
	else:
		#Get random index
		ind = random.randint(0,len(testFileNumbers)-1)
		testLabelsList[testFileNumbers[ind]] = 1
		os.system("cp " + posPath + posFileNames[k] + " ./Test/%d.txt" % testFileNumbers[ind])
		del testFileNumbers[ind]
	print "Transferring Positive Data: " + str(int(float(k)/float(nPos) * 100)+1), "%           \r",
print "\nSuccess!"

#Create labels.txt for training and testing data
trainLabels = open('./Train/labels.txt', "w")
trainLabels.close()
testLabels = open('./Test/labels.txt', "w")
testLabels.close()
trainLabels = open('./Train/labels.txt', "a")
testLabels = open('./Test/labels.txt', "a")
#Write Labels file
for k in range(0, trainN-1):
	trainLabels.write(str(trainLabelsList[k]) + "\n")
for k in range(0, testN-1):
	testLabels.write(str(testLabelsList[k]) + "\n")	
trainLabels.close()
testLabels.close()
		
		