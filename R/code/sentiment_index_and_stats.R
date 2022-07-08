copom_filtered <- readr::read_rds("./data/copom_filtered.rds")

#words per minute
copom_text <- copom_filtered %>% 
  dplyr::select(date, meeting, page, text) %>%
  tidytext::unnest_tokens(word, text) %>% 
  dplyr::anti_join(custom_stop_words)

#tf-idf: words per minute
copom_text_tf_idf <- copom_text %>% 
  dplyr::mutate(word = gsub("[^A-Za-z ]", "", word)) %>%
  dplyr::filter(word != "") %>%
  dplyr::anti_join(custom_stop_words) %>%
  dplyr::group_by(meeting) %>% 
  dplyr::count(word, sort = TRUE) %>% 
  tidytext::bind_tf_idf(word, meeting, n) %>% 
  dplyr::arrange(desc(meeting), tf_idf)

#export .rds file
readr::write_rds(copom_text_tf_idf, "./data/copom_text_tf_idf.rds")

##descriptive statistics of the data

#words frequency per minute
copom_words <- copom_filtered %>%
  tidytext::unnest_tokens(word, text) %>%
  dplyr::anti_join(custom_stop_words) %>%
  dplyr::count(meeting, word, sort = TRUE) %>%
  dplyr::ungroup() %>%
  dplyr::arrange(desc(meeting), desc(n))

#total of words per minute
total_words <- copom_words %>% 
  dplyr::group_by(meeting) %>% 
  dplyr::summarize(total = sum(n))

#histogram
freq_words <- dplyr::left_join(copom_words, total_words) %>%
  dplyr::mutate(frequency = n/total)

#mean of total words for 3 different periods
mean_fperiod <- total_words %>%
  dplyr::filter(meeting <= 180) %>%
  dplyr::summarize(mean_fp = mean(total))

mean_speriod <- total_words %>%
  dplyr::filter(meeting > 180 & meeting <= 199) %>%
  dplyr::summarize(mean_sp = mean(total))

mean_tperiod <- total_words %>%
  dplyr::filter(meeting > 199) %>%
  dplyr::summarize(mean_tp = mean(total))

#copom_words wordcloud
copom_words_cloud <- copom_words %>%
  dplyr::group_by(word) %>%
  dplyr::summarize(n_words = sum(n)) %>%
  dplyr::filter(n_words > 150)

#correlation between 'inflation' and 'increased'
copom_words_inf <- copom_words %>%
  dplyr::filter(word == "inflation")

copom_words_incr <- copom_words %>%
  dplyr::filter(word == "increased")

copom_words_corr <- dplyr::inner_join(copom_words_inf,
                                      copom_words_incr,
                                      by = "meeting")

cor(copom_words_corr$n.x, copom_words_corr$n.y)

#Hu e Liu (2004) sentiment lexicon
hu_liu_lexicon <- tidytext::get_sentiments("bing")

#sentiment analysis index creation
copom_sentiment_index <- copom_text %>%
  dplyr::inner_join(hu_liu_lexicon) %>%
  dplyr::count(date, meeting, page, sentiment) %>%
  tidyr::pivot_wider(
    id_cols = c(date, meeting, page),
    names_from = sentiment, 
    values_from = n,
    values_fill = 0
  ) %>%
  dplyr::mutate(sentiment = positive - negative) %>% 
  dplyr::group_by(date, meeting) %>%
  dplyr::summarize(positive = sum(positive),
                   negative = sum(negative),
                   sentiment = sum(sentiment),
                   total = sum(positive, negative),
                   sentiment_index = round(positive / total, 4))

#export .rds file
readr::write_rds(copom_sentiment_index, "./data/copom_sentiment_index.rds")

#number of positive and negative minutes
pos_neg_periods <- copom_sentiment_all %>%
  dplyr::mutate(valor = ifelse(sentiment_index > 0.5, "pos", "neg")) %>% 
  dplyr::count(valor) %>%
  dplyr::group_by(valor) %>%
  dplyr::summarize(total = sum(n))