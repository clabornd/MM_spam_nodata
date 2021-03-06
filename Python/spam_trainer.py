import pandas as pd
import pickle
import os
import sys
from sklearn.pipeline import make_pipeline
from sklearn.naive_bayes import MultinomialNB
from sklearn.feature_extraction.text import TfidfVectorizer

###LOAD DATA###
filename_spam = sys.argv[-1]
filename_ham = sys.argv[-2]

spam = pd.read_csv(os.path.dirname(__file__)+filename_spam, encoding = "ISO-8859-1")
ham = pd.read_csv(os.path.dirname(__file__)+filename_ham, encoding = "ISO-8859-1")

### SET TARGET VALUES ###
ham['target'] = 0
spam['target'] = 1

### MERGE HAM AND SPAM INTO SINGLE DATAFRAME ###
spam = spam[['message', 'target']]
ham = ham[['message', 'target']]

data = pd.concat([ham, spam])
data['message'] = data['message'].astype('str')

### PIPELINE WHICH CREATES FEATURE SET, REMOVES STOP WORDS, AND APPLIES MULTINOMIAL NAIVE BAYES CLASSIFIER ###
clf = make_pipeline(TfidfVectorizer(stop_words = 'english', token_pattern=r"\b[a-z]{2,}[a-z0-9_\-\.-]+[a-z]{2,}\b"), MultinomialNB(alpha=0.01))

## FIT AND PICKLE THE CLASSIFIER
clf.fit(data['message'], data['target'])

file_name = os.path.dirname(os.path.realpath(__file__))+'\classifier.p'

fileObject = open(file_name, 'wb')

pickle.dump(clf, fileObject)

fileObject.close()



