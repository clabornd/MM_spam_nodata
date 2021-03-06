import pandas as pd
import pickle
import os
import sys

### LOAD EMAIL OR BATCH OF EMAILS HERE ###
### MUST BE IN THE FORMAT OF A CSV WITH 'message' and 'email' column  ###
filename_emails = sys.argv[-1] 


emails = pd.read_csv(os.path.dirname(__file__)+filename_emails, encoding = "ISO-8859-1")

## Load pickled classifier ##
fileObject = open('classifier.p','rb')  
clf = pickle.load(fileObject)  


## Get predictions and append column of predicted values to dataframe
emails_pred = clf.predict(emails['message'])
emails['pred'] = emails_pred

## Dataframe with predicted values and email addresses.
out = emails[['pred', 'email']]

## Write to file location ##
out.to_csv(os.path.dirname(os.path.realpath(__file__))+"/predicted_emails.csv")

 
