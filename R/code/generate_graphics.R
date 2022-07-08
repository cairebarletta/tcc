#https://www.color-hex.com/color-palettes/

###############################################################################

total_words %>%
  ggplot2::ggplot(aes(x = meeting)) +
  ggplot2::geom_line(aes(y = total), color = colors[1], size = 1.25) +
  ggplot2::geom_hline(aes(yintercept = mean_fperiod %>% dplyr::pull(mean_fp),
                 colour = "Média atas 116-180"),
                 linetype = "dashed",
                 size = 0.75) +
  ggplot2::geom_hline(aes(yintercept = mean_speriod %>% dplyr::pull(mean_sp),
                 colour = "Média atas 181-199"),
                 linetype = "dashed",
                 size = 0.75) +
  ggplot2::geom_hline(aes(yintercept = mean_tperiod %>% dplyr::pull(mean_tp),
                 colour = "Média atas 200-246"),
                 linetype = "dashed",
                 size = 0.75) +
  ggplot2::scale_y_continuous(breaks = seq(from = 800, to = 5000, by = 200),
                              labels = number_format(big.mark = ".",
                                                     decimal.mark = ",")) +
  ggplot2::scale_x_continuous(breaks = seq(from = head(total_words$meeting, 1),
                                       to = tail(total_words$meeting, 1),
                                       by = 5)) +
  ggplot2::scale_color_manual(values = c("Média atas 116-180" = colors[4],
                                         "Média atas 181-199" = colors[2],
                                         "Média atas 200-246" = colors[3])) +
  ggplot2::labs(x = "Nº Ata",
                y = "Palavras") +
  ggplot2::theme_light() +
  ggplot2::theme(plot.title = element_text(face = "bold"),
                 plot.subtitle = element_text(face = "italic", size = 10),
                 axis.text.x = element_text(angle = 90, vjust = 0.5),
                 legend.title = element_blank(),
                 legend.position = "bottom")
#width = 700, height = 400

###############################################################################

#copom_words wordcloud
wordcloud::wordcloud(words = copom_words_cloud$word,
                     freq = copom_words_cloud$n_words,
                     min.freq = 1,
                     max.words = 250,
                     random.order = F,
                     rot.per = 0.35,
                     colors = brewer.pal(8, "Dark2"))

###############################################################################

#most frequent words in copom minutes
copom_text %>% 
  dplyr::mutate(word = gsub("[^A-Za-z ]", "", word)) %>%
  dplyr::filter(word != "") %>%
  dplyr::group_by(meeting) %>%
  dplyr::count(word, sort = TRUE) %>% 
  dplyr::mutate(rank = dplyr::row_number()) %>%
  dplyr::ungroup() %>% 
  dplyr::arrange(rank, meeting) %>%
  dplyr::filter(rank < 8, meeting > 234) %>% 
  ggplot2::ggplot(ggplot2::aes(y = n, x = forcats::fct_reorder(word, n))) +
  ggplot2::geom_col(fill = colors[1]) +
  ggplot2::facet_wrap(~meeting, scales = "free", ncol = 3) +
  ggplot2::coord_flip() +
  ggplot2::labs(x = "Nº Ata",
                y = "Frequência absoluta") +
  ggplot2::theme_light()
#width = 700, height = 500

###############################################################################

#histogram
freq_words %>%
  dplyr::filter(meeting > 237) %>% 
  ggplot2::ggplot(aes(y = frequency, fill = meeting)) +
  ggplot2::geom_histogram(show.legend = F) +
  ggplot2::facet_wrap(~meeting, scales = "free", ncol = 3) +
  ggplot2::scale_y_continuous(labels = number_format(accuracy = 0.001,
                                                     decimal.mark = ",")) +
  ggplot2::coord_flip() +
  ggplot2::labs(
    x = "Contagem de palavras",
    y = "Frequência relativa"
  ) +
  ggplot2::theme_light()

###############################################################################

#tf-idf
copom_text_tf_idf %>%
  dplyr::arrange(desc(meeting), desc(tf_idf)) %>%
  dplyr::mutate(word = factor(word, levels = rev(unique(word)))) %>% 
  dplyr::group_by(meeting) %>%
  dplyr::mutate(id = dplyr::row_number()) %>%
  dplyr::ungroup() %>% 
  dplyr::filter(id < 8, meeting > 226) %>% 
  ggplot2::ggplot(ggplot2::aes(y = tf_idf, x = word)) +
  ggplot2::geom_col(fill = colors[5], show.legend = FALSE) +
  ggplot2::facet_wrap(~meeting, scales = "free", ncol = 4)  +
  ggplot2::scale_y_continuous(labels = number_format(accuracy = 0.001,
                                                    decimal.mark = ",")) +
  ggplot2::coord_flip() +
  ggplot2::labs(x = "Nº Ata",
                y = "Estatística tf-idf") +
  ggplot2::theme_light() +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1))
#width = 800, height = 800

###############################################################################

#sentiment index
copom_sentiment_index %>%
  dplyr::mutate(sentiment_color = ifelse(sentiment_index > 0.5, colors[1], colors[6])) %>%
  ggplot2::ggplot(aes(x = date,
                      y = sentiment_index,
                      color = sentiment_color,
                      group = 1)) +
  ggplot2::geom_line(size = 1.25) +
  ggplot2::scale_color_identity() +
  ggplot2::geom_hline(aes(yintercept = 0.5),
                      linetype = "dashed",
                      color = colors[3],
                      size = 1) +
  ggplot2::scale_x_date(breaks = "6 months",
               labels = date_format("%m/%Y")) +
  ggplot2::scale_y_continuous(breaks = seq(from = 0, to = 1, by = 0.05),
                              labels = number_format(accuracy = 0.05,
                                                     decimal.mark = ",")) +
  ggplot2::labs(x = "Data",
                y = "Índice") +
  ggplot2::theme_light() +
  ggplot2::theme(plot.title = element_text(face = "bold"),
                 axis.text.x = element_text(angle = 90, vjust = 0.5))
#width = 700, height = 400