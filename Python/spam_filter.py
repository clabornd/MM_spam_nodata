##############

# this script tests various machine learning algorithms to inform which one to use in spam_trainer.py # 
# written for use in an interactive console only

import numpy as np
import pandas as pd
import csv
import matplotlib.pyplot as plt
import scipy as sp
from sklearn import datasets, model_selection, neighbors, svm, preprocessing, metrics, feature_extraction
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import SGDClassifier
from sklearn.model_selection import cross_val_score, KFold, ShuffleSplit
from sklearn.pipeline import make_pipeline
from scipy.stats import sem
from sklearn.naive_bayes import MultinomialNB, BernoulliNB
from sklearn.feature_extraction.text import TfidfVectorizer, HashingVectorizer, CountVectorizer
from sklearn import metrics

spam = pd.read_csv("C:\\Users\\interns\\Documents\\MM-GIT\Data\\fraud-messages-master.csv", encoding = "ISO-8859-1")
ham = pd.read_csv("C:\\Users\\interns\\Documents\\MM-GIT\Data\\combined-good-messages-012016-072017.csv", encoding = "ISO-8859-1")

ham['target'] = 0
spam['target'] = 1

spam = spam[['message', 'target']]
ham = ham[['message', 'target']]

data = pd.concat([ham, spam])
data['message'] = data['message'].astype('str')

X_train, X_test, y_train, y_test = model_selection.train_test_split(data['message'], data['target'], test_size = 0.15, random_state = 42)

with open("C:\\Users\\interns\\Documents\\MM-GIT\Python\\test_emails.csv", 'w') as csvfile:
    writer = csv.writer(csvfile)
    for i in range(0, len(X_test.index)):
        writer.writerow(X_test.iloc[i])
        

clf_1 = make_pipeline(CountVectorizer(), MultinomialNB())
clf_2 = make_pipeline(HashingVectorizer(alternate_sign = False), MultinomialNB())
clf_3 = make_pipeline(TfidfVectorizer(), MultinomialNB())
clf_4 = make_pipeline(TfidfVectorizer(token_pattern=r"\b[a-z0-9_\-\.]+[a-z][a-z0-9_\-\.]\b"), MultinomialNB())
clf_5 = make_pipeline(TfidfVectorizer(stop_words = 'english', token_pattern=r"\b[a-z]{2,}[a-z0-9_\-\.-]+[a-z]{2,}\b"), MultinomialNB(alpha=0.01))
clf_6 = make_pipeline(CountVectorizer(stop_words = 'english', token_pattern=r"\b[a-z]{2,}[a-z0-9_\-\.-]+[a-z]{2,}\b"), MultinomialNB(alpha=0.01))
clf_bernoulli = make_pipeline(TfidfVectorizer(token_pattern=r"\b[a-z0-9_\-\.]+[a-z][a-z0-9_\-\.]\b"), BernoulliNB())

clf_5.fit(X_train,y_train)

emails = pd.read_csv("C:\\Users\\interns\\Documents\\MM-GIT\Python\\fraud-messages-master.csv", encoding = "ISO-8859-1")
clf_5.predict(emails['message'])


mods = [clf_5, clf_6]

cv = ShuffleSplit(5, 0.2, random_state = 42)

def print_cv_results(mods):
    for i,mod in enumerate(mods):
        modscore = cross_val_score(mod, X_train, y_train, cv=cv)
        print("average score of model {}: {:.5f}".format(i,np.mean(modscore)))


print_cv_results(mods)
clf_1.fit(X_train, y_train)
y_pred = clf_1.predict(X_test)
metrics.accuracy_score(y_test, y_pred)

scores = cross_val_score(clf_1, X_train, y_train, cv=cv)
print(scores)

scores = cross_val_score(clf_3, data['message'], data['target'], cv=cv)
print(scores)

scores = cross_val_score(clf_4, data['message'], data['target'], cv=cv)
print(scores)

scores = cross_val_score(clf_5, data['message'], data['target'], cv=cv)
print(scores)

scores = cross_val_score(clf_bernoulli, data['message'], data['target'], cv = cv)
print(scores)