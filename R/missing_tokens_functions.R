stop_titles <- c("mr. ",
                 "mrs. ",
                 "dr. ",
                 "md. ",
                 "ms ")
roate_text <- function(a) {
  theme(axis.text.x = element_text(angle = a, hjust = 1))
}


#get occurences of words within messages for unique email id's
get_counts_unique <- function(df, message_col, multinomial = FALSE, ngrams = FALSE){
  quo_col <- enquo(message_col)

  if(multinomial){
    frame <- df %>%
      select(!!quo_col) %>%
      unnest_tokens(token, message, token = "words") %>%
      anti_join(stop_words, by = c("token"="word")) %>%
      group_by(token) %>%
      mutate(n = n()) %>%
      distinct(token, n)

    if(ngrams){
      rbind(frame,
            df %>%
              select(!!quo_col) %>%
              unnest_tokens(token, message, token = "ngrams", n =2) %>%
              group_by(token) %>%
              mutate(n = n()) %>%
              distinct(token, n)
      )
    }

    frame

  }

  else{
    frame <- df %>%
      select(id_1, message) %>%
      unnest_tokens(token, message, token = "words") %>% select(id_1, token) %>%
      anti_join(stop_words, by = c("token"="word")) %>%
      group_by(id_1) %>%
      distinct(token) %>%
      group_by(token) %>%
      mutate(n = n()) %>%
      distinct(token, n)

    if(ngrams){
      rbind(frame,
            df %>%
              select(id_1, message) %>%
              unnest_tokens(token, message, token = "ngrams", n =2) %>%
              group_by(id_1) %>%
              distinct(token) %>%
              group_by(token) %>%
              mutate(n = n()) %>%
              distinct(token, n)
      )
    }

    frame

  }
}

get_prob_tables <- function(spam_train, ham_train, multinomial = FALSE, ngrams = FALSE){
  #word counts for both groups
  word_counts_spam <- get_counts_unique(spam_train, message, multinomial, ngrams)
  word_counts_ham <- get_counts_unique(ham_train, message, multinomial, ngrams)

  allterms <- data.frame(token = unique(c(word_counts_spam$token, word_counts_ham$token))) %>%
    mutate(token = as.character(token))

  ###Posterior probabilities for each term given the document is spam or ham###
  prob_table_spam <- allterms %>% left_join(word_counts_spam, by = "token") %>%
    mutate(n = replace(n, is.na(n), 0), n = n + 1)

  prob_table_ham <- allterms %>% left_join(word_counts_ham, by = "token") %>%
    mutate(n = replace(n, is.na(n), 0), n = n + 1)

  if(multinomial){
    prob_table_spam <- prob_table_spam %>% mutate(logprob = log(n/sum(n)))
    prob_table_ham <- prob_table_ham %>% mutate(logprob = log(n/sum(n)))
  }
  else{
    prob_table_spam <- prob_table_spam %>% mutate(logprob = log(n/nrow(spam_train)))
    prob_table_ham <- prob_table_ham %>% mutate(logprob = log(n/nrow(ham_train)))
  }

  list(prob_table_spam, prob_table_ham)

}

#test the model given a spam and ham table.
test_model <- function(test_emails, spam_table, ham_table, ngrams = FALSE, multinomial = FALSE, prior_ham = 0.5, prior_spam = 0.5){

  test_emails["pred"] <- 0

  for(i in 1:nrow(test_emails)){

    if(multinomial){
      ###multinomial code

      test_mail <- unnest_tokens(test_emails[i,], token, message) %>%
        select(token) %>%
        anti_join(stop_words, by = c("token"="word")) %>%
        ungroup()

      if(ngrams){
        test_mail <- rbind(test_mail,
                           unnest_tokens(test_emails[i,], token, message, token = "ngrams", n = 2) %>%
                             select(token) %>%
                             group_by(token) %>%
                             ungroup()
        )
      }
    }

    else{

      ###binary code
      test_mail <- unnest_tokens(test_emails[i,], token, message) %>%
        select(token) %>%
        unique() %>%
        anti_join(stop_words, by = c("token"="word")) %>%
      if(ngrams){

        test_mail <- rbind(test_mail,
                           unnest_tokens(test_emails[i,], token, message, token = "ngrams", n = 2) %>%
                             select(token) %>%
                             unique())
      }

    }



    ###should be same for both
    log_prob_ham <- log(prior_ham) +
      sum((test_mail %>%
             left_join(ham_table, by = "token") %>%
             mutate(logprob = replace(logprob, is.na(n), min(logprob))))$logprob)

    log_prob_spam <- log(prior_spam) +
      sum((test_mail %>%
             left_join(spam_table, by = "token") %>%
             mutate(logprob = replace(logprob, is.na(n), min(logprob))))$logprob)


    if(log_prob_spam > log_prob_ham){
      test_emails[i,]$pred <- 1
    }

  }

  test_emails

}
