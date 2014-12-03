'''
Created on Nov 4, 2014

@author: connor walsh
'''
#!/usr/bin/python
import nltk
import codecs, sys, os, imp

def getWeightedFeature(feature, weightType, weight):
	#print feature
	#Decide weighting scheme
	if weightType == 'H':
		#Choose the Hamming Distance Scheme
		if feature > 0:
			F = weight
		else:
			F = 0
	elif weightType == 'WC':
		#Choose the Tanimoto Distance Scheme
		F = feature * weight
	return F

def bagOfWords(abstract, word, weightType, weight):
	#open abstract file
	abstract = open(abstract, 'r')
	wordCount = 0;
	for text in abstract:
		text = text.strip(' ').replace('\n', '')
		if text == word:
			wordCount+=1
	F = getWeightedFeature(wordCount, weightType, weight)
	#Return the computed feature
	return F

def transform(abstract):
	#Get extractFeature class
	extractFeatures = imp.load_source('libPramFetch', '../preprocessed/FeatureCalc/libPramFetch.py')
	
	#Load Selected Features File
	featuresFN = '../Preprocessed/selectedFeatures.txt'
	features = open(featuresFN, 'r')
	FList = '';
	
	#Loop over each feature
	for feature in features:
		#Split up line into fields:
		# [featureType]	[featureInstance] [weightType] [weight]
		feature = feature.split('\t')
		featureType = feature[0]
		featureInstance = feature[1]
		weightType = feature[2]
		weight = float(feature[3])
	
		#Decide how to extract feature
		if featureType == 'BoW':
			F = bagOfWords(abstract, featureInstance, weightType, weight)
		elif featureType == 'syntax':
			#Check which syntactical feature to extract
			if featureInstance == 'NN':
				F = extractFeatures.NNount(abstract)
				F = getWeightedFeature(F, weightType, weight)
			elif featureInstance == 'Complexity':
				F = extractFeatures.avgSentComplexity(abstract)
				F = getWeightedFeature(F, weightType, weight)
		#Store Feature value in list string
		FList+= str(F) + '\t'
	return FList + '\n'
	#Save features in a text file in specified directory
	#saveFile = open(saveDir + '/' + saveName, 'w+')
	#saveFile.write(FList)
	#saveFile.close()
