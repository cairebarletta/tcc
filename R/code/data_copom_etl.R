#file: 'data/copom_filtered.rds'

#json BCB api with all minutes
all_minutes <- "https://www.bcb.gov.br/api/servico/sitebcb/copomminutes/ultimas?quantidade=2000&filtro="

#minutes raw data
copom <- jsonlite::fromJSON(all_minutes)[["conteudo"]] %>% 
  dplyr::as_tibble() %>% 
  dplyr::select(date = "DataReferencia", meeting = "Titulo", url = "Url") %>% 
  dplyr::mutate(url = paste0("https://www.bcb.gov.br", url)) %>% 
  dplyr::mutate(text = purrr::map(url, pdftools::pdf_text))

#minutes clean data and pre-processing
copom_filtered <- copom %>% 
  tidyr::unnest(text) %>%
  #removing non-related minute docs and minutes number 42 to 49
  dplyr::filter(!meeting == "Changes in Copom meetings") %>%
                #!stringr::str_detect(string = meeting, pattern = "^4[2-9]")) %>% 
  dplyr::group_by(meeting) %>%
  dplyr::mutate(page = dplyr::row_number(),
                
                text = strsplit(text, "\r") %>%
                  stringr::str_replace_all(
                    #removing unwanted ASCII codes and characters
                    pattern = "\n|\003|\017|\023|\024|\025|\026|\027|\028|\029|\030|\031|\032|\033|\034|\035",
                    replacement = ""
                  ) %>%
                  stringr::str_replace_all(
                    #replacing specific word: 'crises to crisis'
                    pattern = "crises",
                    replacement = "crisis"
                  ) %>%
                  tm::removePunctuation() %>%
                  tm::removeNumbers() %>%
                  stringr::str_to_lower(), #%>%
                  #words normalization: stemming
                  #tm::stemDocument(),
                
                meeting = stringr::str_sub(string = meeting, start = 1, end = 3) %>%
                  stringr::str_remove(pattern = "[:alpha:]") %>% 
                  as.numeric(),
                
                date = lubridate::as_date(.data$date)) %>%
  dplyr::ungroup() %>% 
  dplyr::arrange(meeting) %>%
  dplyr::filter(meeting > 115 & meeting < 247)

#export data to .rds file
readr::write_rds(copom_filtered, "./data/copom_filtered.rds")