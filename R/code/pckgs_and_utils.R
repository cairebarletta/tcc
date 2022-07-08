#references in some code parts includes Julia Silge, David Robinson and Fernando Silva
#carregar pacotes e dependências
if(!require("pacman")) install.packages("pacman")
pacman::p_load(devtools, tidyverse, pdftools, tidytext,
               stopwords, scales, wordcloud, sidrar, xts,
               mFilter, vars)

#devtools::install_github("leripio/tstools")
library(tstools)

#custom stopwords
custom_stop_words <- dplyr::bind_rows(
  dplyr::tibble(
    word = c(
      tolower(month.abb), 
      tolower(month.name),
      "one","two","three","four","five","six","seven","eight","nine","ten",
      "eleven","twelve", "wkh", "ri", "lq", "month", "wr", "dqg",
      "hdu", "jurzwk", "zlwk", "zlwk", "hfhpehu", "dqxdu", "kh", "sulfh", "dv",
      "kh", "prqwk", "hdu", "shulrg", "dv", "jurzwk", "wkdw", "zdv", "iru", "dw",
      "wkdw", "jrrgv", "xqh", "eloolrq", "eloolrq", "iluvw", "dq", "frqvxphu", 
      "prqwk", "udwh", "sulo", "rq", "txduwhu", "vhfwru", 
      "dffxpxodwhg", "hg", "kdyh", "sdqghg", "sulfhv", "rq", "sdqvlrq", 
      "percent", "forvhg", "frpsduhg", "lqgh", "ryhpehu", "wklv", "kdv", "prqwkv",
      "bcbgovbr", "banco", "head", "nhfkdqjhsrolfdfwlrqvxhvwlrqvdqgfrpphqwvwrjfledfhqefejryeu",
      "nqirupdwlrqiruxquhvwulfwhgglvforvxuhwlvqrwlqwhqghgwrelqgdqfrhqwudogrudvlolqlwvprqhwduruiruhljq",
      "gerinbcbgovbr", "gcibacenbcbgovbr", "hswhpehu", "nxppdu", "ndoohgwrrughu", "ngmrxuqhg", "nqdwwhqgdqfh",
      "nhpehuvriwkhrdug", "ryhuqru", "chsduwphqwhdgv", "naggregate", "nexternal", "nprices", "nprospective", "nmoney",
      "nmonetary", "nexecutive", "nstarting", "ndepartment", "nthe", "de", "months", "monthonmonth", "monthly", "yearoveryear",
      "npandemic", "cbanco", "nseptember", "nbaseline", "npotential", "crd", "cth", "cnd", "cst",
      "nbelowtarget", "nbolster", "nends", "brasil", "nhorizon", "nconcluded", "naround", "nsurvey", "nalthough",
      "nconjectured", "nconstituting", "ndisintermediation", "noccurring", "nunderlying", "nadministered", "nstimulus", "ndecline",
      "nricardo", "aloisio", "jean", "calendaryear", "mello", "guardado", "rumenos", "diogo", "dias", "guillen", "brito", "renato",
      "feitosa", "deputy", "kanczuk", "nechio", "caccavo", "miguel", "nprovided", "nbeginning", "nstimulative", "nslightly", "nupward",
      "copom", "copoms", "meeting", "committee", "billion", "pp", "basis", "period", "quarter", "pa", "pm", "nin", "due", "daily",
      "constant", "larger", "henceforth", "baseline", "usdbrl", "usd", "abry", "assumption", "probabilities", "morning"
      ), 
    lexicon = c("custom")
  ),
  tidytext::stop_words
)

#graph colors
colors <- c(
  "#3d85c6", #lightblue
  "#324a6d", #darkblue
  "#808080", #gray
  "#134f4a", #green
  "#4c6189", #grayblue
  "#ff4c4c"  #red
)
