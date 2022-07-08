#importing sentiment index data
sentiment_index <- readxl::read_excel("./data/sentiment_index_monthly.xlsx") %>%
  dplyr::mutate(data = as.Date(data)) %>%
  dplyr::pull(sentiment_index) %>%
  stats::ts(start = c(2006, 1),
            end = c(2022, 5),
            freq = 12) %>%
  zoo::na.approx() #linear interpolation for missing months
sentiment_index <- hpfilter(sentiment_index, type = "lambda", freq = 129600)$cycle #HP filter, cycle element

#inflation 12m accumulated
ipca_acum_12m <- get_sidra(api = "/t/1737/n1/all/v/2266/p/all/d/v2266%2013") %>%
  dplyr::mutate(data = readr::parse_date(`Mês (Código)`, "%Y%m")) %>%
  dplyr::rename(ipca = "Valor") %>%
  dplyr::mutate(ipca_12m = ipca/lag(ipca, 12) - 1) %>%
  dplyr::filter(data >= "2006-01-01") %>%
  dplyr::select(data, ipca_12m)

#selic and ibc-br series
series_bcb <- c(selic = 4189, #Taxa de juros - Selic acumulada no mês anualizada base 252, como %a.a. (period: mensal)
                ibc_br = 24364) #Índice de Atividade Econômica do Banco Central (IBC-Br) - com ajuste sazonal (period: mensal)

get_series_bcb <- rbcb::get_series(series_bcb,
                                   start_date = "2005-01-01") %>%
  purrr::reduce(full_join)

#selic 12m accumulated
selic_acum_12m <- get_series_bcb %>%
  dplyr::mutate(selic = (1 + selic / 100)^(1/12) - 1, #from annual to monthly
                selic_factor = cumprod(1 + selic),
                selic_acum_12m = selic_factor/lag(selic_factor, 12) - 1) %>%
  dplyr::rename(data = date) %>%
  dplyr::filter(data >= "2006-01-01") %>%
  dplyr::select(data, selic_acum_12m)

#real selic 12m accumulated
selic_real_12m <- 
  dplyr::left_join(ipca_acum_12m,
                   selic_acum_12m,
                   by = "data") %>%
  dplyr::mutate(selic_real_12m = selic_acum_12m - ipca_12m) %>%
  dplyr::select(data, selic_real_12m) %>%
  dplyr::pull(selic_real_12m) %>%
  stats::ts(start = c(2006, 1),
            end = c(2022, 5),
            freq = 12)

#ibc-br
ibc_br <- get_series_bcb %>%
  dplyr::filter(date > "2006-01-01" & date < "2022-03-01") %>%
  dplyr::pull(ibc_br) %>%
  stats::ts(start = c(2006, 1),
            end = c(2022, 2),
            freq = 12)
ibc_br <- hpfilter(ibc_br, type = "lambda", freq = 129600)$cycle #HP filter, cycle element

#pim-pf seasonally adjusted (index, 2012 = 100), https://sidra.ibge.gov.br/tabela/8159
pim_sa <- sidrar::get_sidra(api = "/t/8159/n1/all/v/11600/p/all/c544/129314/d/v11600%205") %>% 
  dplyr::mutate(data = readr::parse_date(`Mês (Código)`, "%Y%m")) %>%
  dplyr::select(data, pim_pf_sa = "Valor") %>%
  dplyr::filter(data > "2006-01-01") %>%
  dplyr::pull(pim_pf_sa) %>%
  stats::ts(start = c(2006, 1),
            end = c(2022, 4),
            freq = 12)
pim_sa <- hpfilter(pim_sa, type = "lambda", freq = 129600)$cycle

#joining all data
all_data <- cbind(sentiment_index, selic_real_12m, ibc_br, pim_sa)[1:194, ] %>% #excluding dates from may/22-mar/22
  stats::ts(start = c(2006, 1),
            end = c(2022, 2),
            freq = 12)
colnames(all_data) <- c("Índice", "Juros Real", "IBC-Br", "PIM-PF")

plot(all_data, main = "", xlab = "Data")
#save with width = 700, height = 500
colnames(all_data) <- c("sentiment_index", "selic_real_12m", "ibc_br", "pim_pf")

###
selic_real_12m_diff <- diff(selic_real_12m)

all_data_diff <- cbind(sentiment_index, selic_real_12m_diff, ibc_br, pim_sa)[2:194, ] %>%
  stats::ts(start = c(2006, 2),
            end = c(2022, 2),
            freq = 12)
colnames(all_data_diff) <- c("Índice", "D(Juros Real)", "IBC-Br", "PIM-PF")

plot(all_data_diff, main = "", xlab = "Data")
#save with width = 700, height = 500
colnames(all_data_diff) <- c("sentiment_index", "selic_real_12m_diff", "ibc_br", "pim_pf")