source("R/requirements.R")
library(tidytext)
library(stringr)

fraud_messages <- load_fraud_messages()
ham_messages <- load_regular_messages()
data("stop_words")

#priors
p_spam <- nrow(fraud_messages)/(nrow(fraud_messages)+nrow(ham_messages))
p_ham <- 1-p_spam

#remove duplicate messages to prevent overfitting
fraud_messages <- fraud_messages %>% distinct(message, .keep_all = TRUE)

#get training and test sets
train_indices_fraud <- sample(seq(nrow(fraud_messages)), floor(0.8*nrow(fraud_messages)))
train_indices_ham <- sample(seq(nrow(ham_messages)), floor(0.8*nrow(ham_messages)))

fraud_train <- fraud_messages[train_indices_fraud,]
fraud_test <- fraud_messages[-train_indices_fraud,]

ham_train <- ham_messages[train_indices_ham,]
ham_test <- ham_messages[-train_indices_ham,]

prob_tables <- get_prob_tables(fraud_train, ham_train, multinomial = TRUE)

test_emails <- rbind(fraud_test %>% select(message), ham_test %>% select(message)) %>%
  mutate(type = c(rep(1, nrow(fraud_test)), rep(0, nrow(ham_test))))

df <- test_model(test_emails, prob_tables[[1]], prob_tables[[2]], multinomial = TRUE, prior_ham = p_ham, prior_spam = p_spam)

#evaluate performance, check false positives
table(test_emails[test_indices,]$type, test_emails[test_indices,]$pred)
table(df$type, df$pred)

df[df$type == 0 & df$pred == 1,]$message

#junjin
emails_junjin <- fraud_train %>% filter(grepl("junjin", email) == TRUE)
counts_junjin <- get_counts_unique(emails_junjin, message)

write_csv(prob_tables[[2]], "Data/prob_table_ham.csv")
write_csv(prob_tables[[1]], "Data/prob_table_spam.csv")
write_csv(df, "Data/test_mail_predictions.csv")
write_csv(counts_junjin, "Data/junjin_words.csv")











