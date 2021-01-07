# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
library(tidyverse)

uvozi <- function(ime_datoteke){
  ime <- paste0("podatki/", ime_datoteke, ".csv")
  tabela <- read_delim(ime, ";", escape_double = FALSE, trim_ws = TRUE, 
                       skip = 1,  col_names = TRUE, locale=locale(encoding = 'Windows-1250')) 
  tabela <- tabela[,2:12]
  colnames(tabela)[1] <- "statisticna_regija"
  tabela <- tabela %>% pivot_longer(-statisticna_regija, names_to = "leto",values_to = "vrednost", names_transform=list(leto=parse_number))
  return(tabela)
}

starost_avtomobilov <- uvozi("povprecna_starost_avtomobilov")
colnames(starost_avtomobilov)[3] <- "starost_avtomobila"
stevilo_umrlih <- uvozi("stevilo_umrlih_v_cest_nesrecah_na_10000_preb")
colnames(stevilo_umrlih)[3] <- "stevilo_umrlih"
st_avtomobilov <- uvozi("osebni_avtomobili_na_1000_preb")
colnames(st_avtomobilov)[3] <- "st_avtomobilov"


uvozi.migracije <- function(){
  delez_delovnih_migrantov <- read_delim("podatki/delez_delovnih_migrantov_glede_na_delovno_akt_preb.csv", 
                                         ";", escape_double = FALSE, trim_ws = TRUE, 
                                         skip = 1, col_names = TRUE, 
                                         locale=locale(encoding = 'Windows-1250'))
  colnames(delez_delovnih_migrantov) <- c("statisticna_regija",2009:2019)
  delez_delovnih_migrantov$`2019` <- NULL
  delez_delovnih_migrantov <- delez_delovnih_migrantov %>% pivot_longer(-statisticna_regija, names_to = "leto",values_to = "delez", names_transform=list(leto=parse_number))
  return(delez_delovnih_migrantov)
}

delez_delovnih_migrantov <- uvozi.migracije()

stevilo_starost <- starost_avtomobilov %>% full_join(st_avtomobilov) %>% full_join(stevilo_umrlih)
View(stevilo_starost)