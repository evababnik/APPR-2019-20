# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
library(tidyverse)
#uvozimo stevilo osebnih avtomobilov na 1000 prebivacev po regijah
uvozi.st_avtomobilov <- function(){
      st_avtomobilov <- read_delim("APPR ANALIZA TRANSPORTA/podatki/osebni_avtomobili_na_1000_preb.csv", 
                                               ";", escape_double = FALSE, trim_ws = TRUE, 
                                               skip = 1, col_names = TRUE, 
                                   locale=locale(encoding = 'Windows-1250'))
st_avtomobilov$KAZALNIK <- NULL
st_avtomobilov$`2019` <- NULL
#row.names(st_avtomobilov) <- st_avtomobilov$`STATISTIÈNA REGIJA`
#st_avtomobilov[1] <- NULL
return(st_avtomobilov)
     
 }
  
uvozi.st_umrlih <- function(){
  stevilo_umrlih <- read_delim("APPR ANALIZA TRANSPORTA/podatki/stevilo_umrlih_v_cest_nesrecah_na_10000_preb.csv", 
                                                             ";", escape_double = FALSE, trim_ws = TRUE, 
                                                             skip = 1,  col_names = TRUE, 
                                                             locale=locale(encoding = 'Windows-1250')) 
  stevilo_umrlih$KAZALNIK <- NULL
  stevilo_umrlih$`2019` <- NULL
  return(stevilo_umrlih)
}
  
uvozi.starost_avtomobilov <- function(){
  starost_avtomobilov <- read_delim("APPR ANALIZA TRANSPORTA/podatki/povprecna_starost_avtomobilov.csv", 
                                              ";", escape_double = FALSE, trim_ws = TRUE, 
                                              skip = 1,  col_names = TRUE, 
                                    locale=locale(encoding = 'Windows-1250'))
  starost_avtomobilov$KAZALNIK <- NULL
  starost_avtomobilov$`2019` <- NULL
  return(starost_avtomobilov)
}
uvozi.migracije <- function(){
  delez_delovnih_migrantov <- read_delim("APPR ANALIZA TRANSPORTA/podatki/delez_delovnih_migrantov_glede_na_delovno_akt_preb.csv", 
                                                                   ";", escape_double = FALSE, trim_ws = TRUE, 
                                                                   skip = 1, col_names = TRUE, 
                                         locale=locale(encoding = 'Windows-1250'))
  names(delez_delovnih_migrantov)[2] <- 2009
  names(delez_delovnih_migrantov)[3] <- 2010
  names(delez_delovnih_migrantov)[4] <- 2011
  names(delez_delovnih_migrantov)[5] <- 2012
  names(delez_delovnih_migrantov)[6] <- 2013
  names(delez_delovnih_migrantov)[7] <- 2014
  names(delez_delovnih_migrantov)[8] <- 2015
  names(delez_delovnih_migrantov)[9] <- 2016
  names(delez_delovnih_migrantov)[10] <- 2017
  names(delez_delovnih_migrantov)[11] <- 2018
  delez_delovnih_migrantov$`2019 Delovni migranti [brez kmetov], ki delajo zunaj regije prebivališèa` <- NULL
  return(delez_delovnih_migrantov)
}

delez_delovnih_migrantov <- uvozi.migracije()
#View(delez_delovnih_migrantov)
starost_avtomobilov <- uvozi.starost_avtomobilov()
#View(starost_avtomobilov)
stevilo_umrlih <- uvozi.st_umrlih()
#View(stevilo_umrlih)
st_avtomobilov <- uvozi.st_avtomobilov()
#View(st_avtomobilov)