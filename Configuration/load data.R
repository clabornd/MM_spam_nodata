load_fraud_messages <- function(path  = "Data/fraud-messages-master.csv") {

  data <- read_csv(path)

  data %>%
    mutate(created = mdy_hm(created),
           modified = mdy_hm(modified),
           last_login_date = mdy_hm(last_login_date),
           contains_email = grepl(".+@.+\\..+ ",message),
           created1 = mdy_hm(created_1)) %>%
    rename(msg_created_date = created_1) %>%
    filter(!is.na(message))
}


load_regular_messages <- function(path = "Data/combined-good-messages-012016-072017.csv") {

  data <- read_csv(path)

  data %>%
    mutate(created = mdy_hm(created),
           modified = mdy_hm(modified),
           last_login_date = mdy_hm(last_login_date),
           contains_email = grepl(".+@.+\\..+ ",message),
           created1 = mdy_hm(created_1)) %>%
    rename(msg_created_date = created_1) %>%
    filter(!is.na(message))
}
