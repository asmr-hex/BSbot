'''
Created on Nov 4, 2014

@author: deaxman
'''
#!/usr/bin/python
import nltk
import codecs, os
from nltk.chunk import *
from nltk.chunk.util import *
from nltk.chunk.regexp import *
from nltk import Tree
#Get the overall wordcount of a data point
def wordCount(filename):
    file=codecs.open(filename,"r+", "utf-8")
    wordcount={};
    for word in file.read().split():
        word = word.replace("\n", "")
        word = word.replace(".", "")
        word = word.replace(";", "")
        word = word.replace(",", "")
        word = word.replace(".", "")
        word = word.replace("!", "")
        word = word.replace("?", "")
        if word not in wordcount:
            wordcount[word] = 1;
        else:
            wordcount[word] += 1;

    return wordcount;

#!/usr/bin/python
#Get the NN count ofa data point
def NNCount(filename):
    file=codecs.open(filename,"r+", "utf-8")
    sentence=[];
    parsedList=[];
    sentenceList=[];
    numofNN=0;
    for line in file:  #?????
        line = line.replace("\n", "")
        sentence.append(line)
        if(line.strip() != ''):
            if(line[-1]=='.'):
                sentenceList.append(''.join(sentence))
                tokens = nltk.word_tokenize(''.join(sentence))
                tagged = nltk.pos_tag(tokens)
                parsedList.append(tagged)
                sentence=[];
    for taggedSentence in parsedList:
        for tag in taggedSentence:
            if(tag[1]=='NN'):
                numofNN=numofNN+1

    file.close()
    return numofNN




#!/usr/bin/python
#Get the Average Sentence complexity of a data point
def avgSentComplexity(filename):
    file=open(filename,"r+")
    parser = RegexpParser('''
        NP: {<DT>? <JJ>* <NN>*} # NP
        P: {<IN>}           # Preposition
        V: {<V.*>}          # Verb
        PP: {<P> <NP>}      # PP -> P NP
        VP: {<V> <NP|PP>*}  # VP -> V (NP|PP)*
        ''')
    sentence=[]
    count=0
    numSentences=0
    numofNN=0;
    for line in file:  #?????
        line = line.replace("\n", "")
        sentence.append(line)
        if(line.strip() != ''):
            if(line[-1]=='.'):
                sentence="".join(sentence)
                tokens = nltk.word_tokenize(sentence)
                tagged = nltk.pos_tag(tokens)
                count=count+(parser.parse(tagged)).count(')')+(parser.parse(tagged)).count('(')
                sentence=[]
                numSentences=numSentences+1

    averageComplexity=count/numSentences
    return averageComplexity

#This function is used to generate features used for featureSelection from Training Data
def getFeatures(numFiles):
    #============ DIRECTORIES & FILES ===================#
    labelsTXT = '../labels.txt'
    featuresTXT = '../features.txt'
    features_infoTXT = '../features_info.txt'
    dictionaryTXT = 'dictionary.txt'
    trainDir = '../../raw/train/'

    allwordstogetherList=[]
    wordCountDictList=[]
    complexityList=[]
    NNList=[]

    #Getting Dictionary
    print "Getting Dictionary..."
    for i in range(0,numFiles):
        print '%d.txt' % i;
        ComplexityList.append(avgSentComplexity(trainDir + '%d.txt' % iC))
        NNList.append(NNCount(trainDir + '%d.txt' % i))
        temp=wordCount(trainDir + '%d.txt' % i)
        allwordstogetherList=allwordstogetherList+temp.keys()
        wordCountDictList.append(temp)
    uniqueWordList=list(set(allwordstogetherList))
    #Ensure there are no empty strings
    uniqueWordList = filter(None, uniqueWordList)
    file = codecs.open("dictionary.txt", "w", "utf-8")
    for item in uniqueWordList:
        file.write(item+"\n")
    file.close()

    #Getting Labels Output
    labels = codecs.open(labelsTXT, "w", "utf-8")
    labels.close()
    with codecs.open(labelsTXT, "a", "utf-8") as writeLabels:
        with codecs.open(trainDir + "labels.txt", "r" ,"utf-8") as readLabels:
            for k in range(0, numFiles):
                writeLabels.write(readLabels.readline())

    #Getting Features Information [featureType \t featureName]
    feat_info = codecs.open(features_infoTXT, "w", "utf-8")
    feat_info.close()
    with codecs.open(features_infoTXT, "a", "utf-8") as feat_info:
        feat_info.write("syntax\t" + "Complexity\n")
        feat_info.write("syntax\t" + "NN\n")
        for word in uniqueWordList:
            feat_info.write("BoW\t" + word +"\n")

    #Getting Features
    print "Getting Features..."
    feat=codecs.open(featuresTXT, "w","utf-8")  #create features.txt?
    feat.close()
    with codecs.open(featuresTXT, "a","utf-8") as f2:
        for i3 in range(0,numFiles):
            f2.write('%(Complexity)d' %{"Complexity": ComplexityList[i3]})
            f2.write('%(NN)d ' %{"NN": NNList[i3]})
            for word in uniqueWordList:
                tempDict=wordCountDictList[i3]
                if tempDict.has_key(word):
                    f2.write('%d ' % tempDict[word])
                else:
                    f2.write('0 ')

            f2.write('\n')
