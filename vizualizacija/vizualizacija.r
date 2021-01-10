# 3. faza: Vizualizacija podatkov



library(ggplot2)
library(ggvis)
library(dplyr)
library(rgdal)
library(mosaic)
library(maptools)
library(maps)
library(plotly)
library(lubridate)
source(file = 'lib/uvozi.zemljevid.r', encoding = 'UTF-8')
source('lib/libraries.r', encoding = 'UTF-8')
source('uvoz/uvoz.r', encoding = 'UTF-8')

#graf stevila avtomobilov po regijah in letih

graf.st_avtomobilov <- ggplot((data=st_avtomobilov), aes(x=leto, y=st_avtomobilov, col=regija)) + 
  geom_point() + geom_line() + theme_classic() +  scale_x_continuous('Leto',breaks = seq(2009, 2018, 1), limits = c(2009, 2018)) + labs(title='Stevilo avtomobilov na 10000 prebivalcev po regijah 2009-2018')

plot(graf.st_avtomobilov)

#graf stevila umrlih po regijah in letih
graf.st_umrlih <- ggplot((data=stevilo_umrlih), aes(x=leto, y=stevilo_umrlih, col=regija)) + 
  geom_point() + geom_line() + theme_classic() +  scale_x_continuous('Leto',breaks = seq(2009, 2018, 1), limits = c(2009, 2018)) + labs(title='Stevilo umrlih v prometnih nesrečah na 10000 prebivalcev po regijah 2009-2018')

plot(graf.st_umrlih)

#povezava med stevilom umrlih v nesrečah in številom avtomobilov po regijah
razmerje_avti_smrti <- stevilo_starost_smrti_migrantje$stevilo_umrlih / stevilo_starost_smrti_migrantje$st_avtomobilov
graf.povezava_nesrece_avtomobili <- ggplot((data=stevilo_starost_smrti_migrantje), aes(x=leto, y=(razmerje_avti_smrti), col=regija)) + 
  geom_point() + geom_line() + theme_classic() +  scale_x_continuous('Leto',breaks = seq(2009, 2018, 1), limits = c(2009, 2018)) + labs(title='Razmerje med stevilom umrlih v nesrečah in številom avtomobilov po regijah 2009-2018')

#graf starosti avtomobilov
graf.starost_avtomobilov <-  ggplot((data=starost_avtomobilov), aes(x=leto, y=(starost_avtomobila), col=regija)) + 
  geom_point() + geom_line() + theme_classic() +  scale_x_continuous('Leto',breaks = seq(2009, 2018, 1), limits = c(2009, 2018)) + labs(title='Starost avtomobilov po regijah 2009-2018')
plot(graf.starost_avtomobilov)
#graf delovne migracije
graf.delovni_migranti <-  ggplot((data=delez_delovnih_migrantov), aes(x=leto, y=(migranti), col=regija)) + 
 geom_point() + geom_line() + theme_classic() +  scale_x_continuous('Leto',breaks = seq(2009, 2018, 1), limits = c(2009, 2018)) + labs(title='Delovni migranti po regijah 2009-2018')
plot(graf.delovni_migranti)

#graf plače
graf.povprecne_place <-  ggplot((data=povprecne_place), aes(x=leto, y=(place), col=regija)) + 
  geom_point() + geom_line() + theme_classic() +  scale_x_continuous('Leto',breaks = seq(2009, 2018, 1), limits = c(2009, 2018)) + labs(title='Povprečne plače po regijah 2009-2018')
plot(graf.povprecne_place)

#povezava med plačami in starostjo avtomobilov
tabela_place_avti <- povprecne_place %>% full_join(starost_avtomobilov)
graf_place_avti <- ggplot(data = tabela_place_avti, aes(x=starost_avtomobila, y=place, color=regija)) + geom_point(aes(frame=leto, ids=regija)) + scale_x_log10()
graf_place_avti <- graf_place_avti + xlab('Starost avtomobila') + ylab('Povprečna mesečna placa')
graf_place_avti <- ggplotly(graf_place_avti)

#struktura cestnih vozil skozi čas
graf_vozil <- ggplot(vrste_vozil, aes(x=leto, y=stevilo_vozil, fill=vrsta)) + 
  geom_area()
