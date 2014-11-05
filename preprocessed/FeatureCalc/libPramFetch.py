'''
Created on Nov 4, 2014

@author: deaxman
'''
#!/usr/bin/python
import nltk
def wordCount(filename):
   file=open(filename,"r+")
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
def NNCount(filename):
   file=open(filename,"r+")
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
def avgSentComplexity(filename):
   file=open(filename,"r+")
   print(file)
   print(filename)
   groucho_grammar = nltk.CFG.fromstring("VP^<TOP> -> VBP NP^<VP-TOP>")
   parser = nltk.ChartParser(groucho_grammar)
   sentence=[]
   count=0
   numSentences=0
   numofNN=0;
   for line in file:  #?????
      line = line.replace("\n", "")
      sentence.append(line)
      if(line.strip() != ''):
         if(line[-1]=='.'):
            print(line)
            count=count+(parser.parse(sentence)).count(')')+(parser.parse(sentence)).count('(')
            sentence=[]
            numSentences=numSentences+1
      
   averageComplexity=count/numSentences
   return averageComplexity
   
def getFeatures(numFiles):
    allwordstogetherList=[]
    wordCountDictList=[]
    complexityList=[]
    labelList=[]
    NNList=[]
    for i in range(0,numFiles):
        #complexityList.append(avgSentComplexity('snarXiv/%d.txt' % i)) 
        NNList.append(NNCount('snarXiv/%d.txt' % i)) 
        temp=wordCount('snarXiv/%d.txt' % i)
        labelList.append("-1")
        allwordstogetherList=allwordstogetherList+temp.keys()
        wordCountDictList.append(temp)
        #complexityList.append(avgSentComplexity('arXiv/%d.txt' % i)) 
        NNList.append(NNCount('arXiv/%d.txt' % i)) 
        temp=wordCount('arXiv/%d.txt' % i)
        labelList.append("1")
        allwordstogetherList=allwordstogetherList+temp.keys()
        wordCountDictList.append(temp)
    uniqueWordList=list(set(allwordstogetherList))
    file = open("uniqueWordList.txt", "w")
    for item in uniqueWordList:
        file.write(item+"\n")
    file.close()
    labels=open("labels.txt", "w")  #create label?
    labels.close()
    with open("labels.txt", "a") as f:
        for i2 in range(0,numFiles):
            f.write(labelList[2*i2]+"\n")
            f.write(labelList[2*i2+1]+"\n")
    feat=open("features.txt", "w")  #create features.txt?
    feat.close()
    with open("features.txt", "a") as f2:
        for i3 in range(0,numFiles):
            #f2.write('%(Complexity)d %(NN)d ' %{"Complexity": complexityList(2*i3), "NN": NNList(2*i3)})
            f2.write('%(NN)d ' %{"NN": NNList[2*i3]})
            for word in uniqueWordList:
                tempDict=wordCountDictList[2*i3]
                if tempDict.has_key(word):
                    f2.write('%d ' % tempDict[word])
                else:
                    f2.write('0 ')
                
            f2.write('\n')
            #f2.write('%(Complexity)d %(NN)d ' %{"Complexity": complexityList(2*i3+1), "NN": NNList(2*i3+1)})
            f2.write('%(NN)d ' %{"NN": NNList[2*i3+1]})
            for word in uniqueWordList:
                tempDict=wordCountDictList[2*i3+1]
                if tempDict.has_key(word):
                    f2.write('%d ' % tempDict[word])
                else:
                    f2.write('0 ')
                
            f2.write('\n')
    
    
    
    
             