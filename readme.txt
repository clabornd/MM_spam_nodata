#### Bayesian spam filtering Methods in R and Python ####

This project contains implementations of bayesian spam classifiers in both R and Python.

The R code located in the R\ folder is an implementation of a naive bayes classifier from scratch, following methodology presented 
here :  http://www.cs.ubbcluj.ro/~gabis/DocDiplome/Bayesian/000539771r.pdf  It is primarily for learning purposes and not for implementation.

The Python code located in the Python\ folder contains scripts which test various methods, and others which implement the selected best method.

The file spam_filter.py is intended to be run in an interactive console and is used to select the best (in terms of accuracy) method.

spam_trainer.py trains the model based on a batch of emails.  It is intended to be run from command line with appropriate packages installed.
The syntax should be:  python spam_trainer.py ham.csv spam.csv.  The first argument after the script must be a csv file of legitimate(ham) messages
and the second a csv file of spam messages, both with a "message" column with each row containing, as a string, the email body. 

spam_trainer.py will produce a fitted classifier object which is stored in the same directory as the script.  

predict_email.py takes input as a batch of new emails in csv format and uses the stored classifier to make predictions.  The syntax from the command 
line is:  python spam_trainer.py new_emails.csv where new_emails is some csv file with a "message" column and an "email" column containing the email
addresses of each message.  

the output will be a csv file containing two columns:  the predicted values(1 = predict spam, 0 = predict ham) and the corresponding email address of that prediction.

