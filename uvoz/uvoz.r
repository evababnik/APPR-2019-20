# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
#uvozimo stevilo osebnih avtomobilov na 1000 prebivacev po regijah
uvozi.st_avtomobilov <- function(){
      st_avtomobilov <- read_delim("podatki/osebni_avtomobili_na_1000_preb.csv", 
                                               ";", escape_double = FALSE, trim_ws = TRUE, 
                                               skip = 1, col_names = TRUE)
st_avtomobilov$KAZALNIK <- NULL
st_avtomobilov$`2019` <- NULL
return(st_avtomobilov)
     
 }
  
  
  
sl <- locale("sl", decimal_mark=",", grouping_mark=".")


st_avtomobilov <- uvozi.st_avtomobilov()
View(st_avtomobilov)