## From Micromentor

### For Fraud
Compare known fraudulent messages to known good messages and look for patterns. Things to look for:
  
- user register_type
- punctuation: none, certain types, certain number of punctuation used
- email addresses: look for @ symbol in message body, specific providers
- URL: in message body, look for specific domain name extensions like .info or country specific extensions.
- home country of fraudulent user
- number of messages sent in a day
- number of messages sent within an hour of creating an account
- Is there a photo?
- special characters: $
- keywords in message field: cash, lottery, micromentor
- message length
- Does message have a greeting? if so, does name in greeting match name of recipient?
- Does message have a sign off? If so, does name in sign off match name of sender?s


## Our own thoughts

### Naive Bayesian Classification

Since we have a corpus of legitimate(hopefully) messages and a corpus of fraud messages I think it'd be handy to do set up a bayesian classifier of good vs bad messages. We can use that along with other indicators to recommend a good way to screen for spam. 


## Todos:

- Set up a classifier
  - Research R methods
  - What could we export to a PHP based system? Is that even possible?
- Analyze based on # of messages sent over a period of time
 - Are the messages identical? Or close to it?
 - How close together are the messages being sent?
 - How do these factors compare to fraudulent vs legitimate messages
