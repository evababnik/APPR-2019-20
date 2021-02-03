
# 3. faza: Vizualizacija podatkov



library(ggplot2)
library(ggvis)
library(dplyr)
library(rgdal)
library(mosaic)
library(maptools)
library(maps)
library(plotly)

source(file = 'lib/uvozi.zemljevid.r', encoding = 'UTF-8')
source('lib/libraries.r', encoding = 'UTF-8')
source('uvoz/uvoz.r', encoding = 'UTF-8')

#struktura cestnih vozil skozi čas
graf_vozil <- ggplot(vrste_vozil, aes(x=leto, y=stevilo_vozil, fill=vrsta)) + labs(title="Vrste cestnih vizil v Sloveniji med letoma 2008 in 2009") + xlab("Leto") + ylab("Število vozil") + 
  geom_area()

#graf stevila avtomobilov po regijah in letih

graf.st_avtomobilov <- ggplot((data=st_avtomobilov), aes(x=leto, y=st_avtomobilov, col=Regija)) + 
  geom_point() + geom_line() + theme_classic() +  scale_x_continuous('Leto',breaks = seq(2009, 2018, 1), limits = c(2009, 2018)) + labs(title='Stevilo avtomobilov na 10000 prebivalcev po regijah 2009-2018')

#zemljevid razmerja med stevilom avtomobilov in umrlimi
Slovenija <- uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/SVN_adm_shp.zip",
                             "SVN_adm1") %>% fortify()
colnames(Slovenija)[12] <- 'Regija'
Slovenija$Regija <- gsub('Notranjsko-kraĹˇka', 'Primorsko-notranjska', Slovenija$Regija)
Slovenija$Regija <- gsub('Spodnjeposavska', 'Posavska', Slovenija$Regija)
Slovenija$Regija <- gsub("KoroĹˇka", "Koroška", Slovenija$Regija)
Slovenija$Regija <- gsub("GoriĹˇka", "Goriška", Slovenija$Regija)
Slovenija$Regija <- gsub("Obalno-kraĹˇka", "Obalno-kraška", Slovenija$Regija)

graf_slovenija <- ggplot(Slovenija, aes(x=long, y=lat, group=group, fill=Regija)) +
  geom_polygon() +
  labs(title="Slovenija") +
  theme_classic()


povprecno_stevilo <- tapply( st_avtomobilov$st_avtomobilov,st_avtomobilov$Regija, mean)
povprecno_stevilo_avtomobilov <- data.frame(Regija=names(povprecno_stevilo), povprecno_stevilo_avtomobilov=povprecno_stevilo)
povprecno_stevilo2 <- tapply(stevilo_umrlih$stevilo_umrlih, stevilo_umrlih$Regija, mean)
povprecno_stevilo_umrlih <- data.frame(Regija=names(povprecno_stevilo2), povprecno_stevilo_umrlih=povprecno_stevilo2)

umrli_avtomobili <- povprecno_stevilo_avtomobilov %>% full_join(povprecno_stevilo_umrlih)
umrli_avtomobili$Razmerje <- (umrli_avtomobili$povprecno_stevilo_umrlih * 10000 / umrli_avtomobili$povprecno_stevilo_avtomobilov)

zemljevid.razmerje_avtomobili_smrti <- ggplot() +
  geom_polygon(data = right_join(umrli_avtomobili,Slovenija, by = c('Regija')),
               aes(x = long, y = lat, group = group, fill = Razmerje))+
  xlab("") + ylab("") + ggtitle('Razmerje med številom umrlih v prometnih nesrečah in številom avtomobilov') + 
  theme(axis.title=element_blank(), axis.text=element_blank(), axis.ticks=element_blank(), panel.background = element_blank()) + 
  scale_fill_gradient(low = '#25511C', high='#2BFF00', limits = c(0.8, 1.93))
zemljevid.razmerje_avtomobili_smrti$labels$fill <- 'Stevilo umrlih na 10.000 avtomobilov'


graf_rast_eu <- ggplot(rast_evropa, aes(x= reorder(name,-value),value,
                                        fill = ifelse(name == "Slovenija", "Highlighted", "Normal") ), 
                       label = name) + geom_bar(stat = "identity") + ylab("Zmanjšanje umrlih v prometnih nesrečah (v %)")+
  geom_text(aes(label = name), angle = 90, hjust = -.05, size = 3) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        legend.position = "none") + 
  geom_hline(yintercept = mean(rast_evropa$value), color="green")


plot(graf_rast_eu)
#graf stevila umrlih po regijah in letih
#graf.st_umrlih <- ggplot((data=stevilo_umrlih), aes(x=leto, y=stevilo_umrlih, col=Regija)) + 
# geom_point() + geom_line() + theme_classic() +  scale_x_continuous('Leto',breaks = seq(2009, 2018, 1), limits = c(2009, 2018)) + labs(title='Stevilo umrlih v prometnih nesrečah na 10000 prebivalcev po regijah 2009-2018')

#plot(graf.st_umrlih)

#povezava med stevilom umrlih v nesrečah in številom avtomobilov po regijah
#razmerje_avti_smrti <- stevilo_starost_smrti_migrantje$stevilo_umrlih / stevilo_starost_smrti_migrantje$st_avtomobilov
#graf.povezava_nesrece_avtomobili <- ggplot((data=stevilo_starost_smrti_migrantje), aes(x=leto, y=(razmerje_avti_smrti), col=Regija)) + 
#geom_point() + geom_line() + theme_classic() +  scale_x_continuous('Leto',breaks = seq(2009, 2018, 1), limits = c(2009, 2018)) + labs(title='Razmerje med stevilom umrlih v nesrečah in številom avtomobilov po regijah 2009-2018')

#graf starosti avtomobilov
#graf.starost_avtomobilov <-  ggplot((data=starost_avtomobilov), aes(x=leto, y=(starost_avtomobila), col=Regija)) + 
# geom_point() + geom_line() + theme_classic() +  scale_x_continuous('Leto',breaks = seq(2009, 2018, 1), limits = c(2009, 2018)) + labs(title='Starost avtomobilov po regijah 2009-2018')
#plot(graf.starost_avtomobilov)
#graf delovne migracije
#graf.delovni_migranti <-  ggplot((data=delez_delovnih_migrantov), aes(x=leto, y=(migranti), col=Regija)) + 
# geom_point() + geom_line() + theme_classic() +  scale_x_continuous('Leto',breaks = seq(2009, 2018, 1), limits = c(2009, 2018)) + labs(title='Delovni migranti po regijah 2009-2018')
#plot(graf.delovni_migranti)

#graf plače
#graf.povprecne_place <-  ggplot((data=povprecne_place), aes(x=leto, y=(place), col=Regija)) + 
#  geom_point() + geom_line() + theme_classic() +  scale_x_continuous('Leto',breaks = seq(2009, 2018, 1), limits = c(2009, 2018)) + labs(title='Povprečne plače po regijah 2009-2018')
#plot(graf.povprecne_place)

#povezana med delovnimi migracijami in stevilom avtomobilov
tabela_migracije_avti <- delez_delovnih_migrantov %>% full_join(st_avtomobilov)
graf_migracije_avti <- ggplot(data = tabela_migracije_avti, aes(x=st_avtomobilov, y=migranti, color=Regija)) + geom_point(aes(frame=leto, ids=Regija)) + scale_x_log10()
graf_migracije_avti <- graf_migracije_avti + xlab('Povprečno število avtomobilov') + ylab('Delež delovnih migrantov')
graf_migracije_avti <- ggplotly(graf_migracije_avti)

#povezava med plačami in starostjo avtomobilov

tabela_place_avti <- povprecne_place %>% full_join(starost_avtomobilov)

graf_place_avti <- ggplot(data = tabela_place_avti, aes(x=starost_avtomobila, y=place, color=Regija)) + geom_point(aes(frame=leto, ids=Regija)) + scale_x_log10() 
graf_place_avti <- graf_place_avti + xlab('Starost avtomobila') + ylab('Povprečna mesečna placa') 
graf_place_avti <- ggplotly(graf_place_avti) 

print(graf_place_avti)