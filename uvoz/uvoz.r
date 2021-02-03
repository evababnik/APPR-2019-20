# 2. faza: Uvoz podatkov
library(readr)
library(dplyr)
library(tidyverse)
library(data.table)

uvozi <- function(ime_datoteke){
  ime <- paste0("podatki/", ime_datoteke, ".csv")
  tabela <- read_delim(ime, ";", escape_double = FALSE, trim_ws = TRUE, 
                       skip = 1,  col_names = TRUE, locale=locale(encoding = 'Windows-1250')) 
  tabela <- tabela[,2:12]
  colnames(tabela)[1] <- "Regija"
  tabela <- tabela %>% pivot_longer(-Regija, names_to = "leto",values_to = "vrednost", names_transform=list(leto=parse_number))
  return(tabela)
}



starost_avtomobilov <- uvozi("povprecna_starost_avtomobilov")
colnames(starost_avtomobilov)[3] <- "starost_avtomobila"
stevilo_umrlih <- uvozi("stevilo_umrlih_v_cest_nesrecah_na_10000_preb")
colnames(stevilo_umrlih)[3] <- "stevilo_umrlih"
st_avtomobilov <- uvozi("osebni_avtomobili_na_1000_preb")
colnames(st_avtomobilov)[3] <- "st_avtomobilov"
st_avtomobilov[3] <- st_avtomobilov[3] * 10

uvozi.migracije <- function(){
  delez_delovnih_migrantov <- read_delim("podatki/delez_delovnih_migrantov_glede_na_delovno_akt_preb.csv", 
                                         ";", escape_double = FALSE, trim_ws = TRUE, 
                                         skip = 1, col_names = TRUE, 
                                         locale=locale(encoding = 'Windows-1250'))

  colnames(delez_delovnih_migrantov) <- c("Regija",2009:2019)
  delez_delovnih_migrantov$`2019` <- NULL
  delez_delovnih_migrantov <- delez_delovnih_migrantov %>% pivot_longer(-Regija, names_to = "leto",values_to = "migranti", names_transform=list(leto=parse_number))
  return(delez_delovnih_migrantov)
}

delez_delovnih_migrantov <- uvozi.migracije()

uvozi.povprecne_place <- function(){
  povprecne_place <- read_delim("podatki/povprecne_mesecne_place.csv", 
                                         ";", escape_double = FALSE, trim_ws = TRUE, 
                                         skip = 1, col_names = TRUE, 
                                         locale=locale(encoding = 'Windows-1250'))

  colnames(povprecne_place) <- c("Regija",2009:2019)
  povprecne_place$`2019` <- NULL
  povprecne_place <- povprecne_place[-c(1, 10),]
  povprecne_place <- povprecne_place %>% pivot_longer(-Regija, names_to = "leto",values_to = "place", names_transform=list(leto=parse_number))
  return(povprecne_place)
}
povprecne_place <- uvozi.povprecne_place()
stevilo_starost_smrti_migrantje <- starost_avtomobilov %>% full_join(st_avtomobilov)  %>% full_join(stevilo_umrlih) 


uvozi.vrste_vozil <- function(){
  vrste_vozil <- read_delim("podatki/vrste_vozil.csv", 
                                           ";", escape_double = FALSE, trim_ws = TRUE,
                                           col_names = TRUE, 
                                      locale=locale(encoding = 'Windows-1250'))
  colnames(vrste_vozil)[1] <- "vrsta"
   vrste_vozil[2] <- NULL
  vrste_vozil[1] <- c("kolesa z motorjem", "motorna kolesa", "osebni avtomobili", "avtobusi", "tovorna motorna vozila", "traktorji")
  vrste_vozil <- vrste_vozil  %>% pivot_longer(-`vrsta`, names_to = "leto",values_to = "stevilo_vozil", names_transform=list(leto=parse_number))
  return(vrste_vozil)
}
vrste_vozil <- uvozi.vrste_vozil()

uvozi_podatke_za_slovenijo <- function(){
  podatki_za_slovenijo <- read_delim("podatki/podatki_za_slovenijo.csv", 
                                     ";", escape_double = FALSE, trim_ws = TRUE, 
                                     skip = 1, col_names = TRUE, 
                                     locale=locale(encoding = 'Windows-1250') )
  podatki_za_slovenijo[2] <- NULL
  colnames(podatki_za_slovenijo)[1] <- "kazalnik"
  podatki_za_slovenijo <- podatki_za_slovenijo  %>% pivot_longer(-`kazalnik`, names_to = "leto",values_to = "stevilo", names_transform=list(leto=parse_number))
 return(podatki_za_slovenijo) 
}
  
podatki_za_slovenijo <- uvozi_podatke_za_slovenijo()

uvozi_podatke_umrlih_v_evropi <- function(){
  umrli_evropa <-  read_csv("podatki/umrli_evropa.csv", col_names = TRUE, 
                            locale=locale(encoding = 'Windows-1250'))
  umrli_evropa$UNIT <- NULL
  umrli_evropa$SEX <- NULL
  umrli_evropa$`Flag and Footnotes`<- NULL
  umrli_evropa <- umrli_evropa[-c(1:2, 35:317, 350),]
  umrli_evropa$GEO <- c('Belgija','Bolgarija', 'Češka','Danska', 'Nemčija','Estonija','Irska','Grčija',
                        'Španija','Francija','Hrvaška','Italija','Ciper','Latvija','Litva',
                        'Luksemburg','Madžarska','Malta', 'Nizozemska', 'Avstrija','Poljska','Portugalska',
                        'Romunija','Slovenija','Slovaška','Finska','Švedska','Velika Britanija','Islandija',  
                         'Lihtenštajn','Norveška', 'Švica', 'Belgija','Bolgarija', 'Češka','Danska', 'Nemčija','Estonija','Irska','Grčija',
                        'Španija','Francija','Hrvaška','Italija','Ciper','Latvija','Litva',
                        'Luksemburg','Madžarska','Malta', 'Nizozemska', 'Avstrija','Poljska','Portugalska',
                        'Romunija','Slovenija','Slovaška','Finska','Švedska','Velika Britanija','Islandija',  
                        'Lihtenštajn','Norveška', 'Švica')
  View(umrli_evropa)
  return(umrli_evropa)
}
umrli_evropa <- uvozi_podatke_umrlih_v_evropi()

izracunaj_rast_smrt <- function(stevilo_smrti){
  rast <- c()
  for (i in 1: 32){
    rast[i] <- ((as.numeric(gsub(",", "", stevilo_smrti[32 + i]))) / (as.numeric(gsub(",", "", stevilo_smrti[i]))) - 1) * 100
  }
  return(rast)
}
rast <- izracunaj_rast_smrt(umrli_evropa$Value)
rast_evropa <- data.frame(name=umrli_evropa$GEO[1:32], value = rast)
#rast_evropa <- rast_evropa[order(rast_evropa$value, decreasing = TRUE),]  
