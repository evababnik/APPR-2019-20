library(ggplot2)
library(ggvis)
library(dplyr)
library(rgdal)
library(mosaic)
library(maptools)
library(maps)
library(plotly)
library(gam)
source('uvoz/uvoz.r', encoding = 'UTF-8')
# 4. faza: Analiza podatkov
#napredna analiza podatkov

#napoved stevila umrlih v cestno prometnih nesrečah glede na rast
#števila avtobomilov v Sloveniji



podatki1 <- gam(stevilo ~ leto , data = podatki_za_slovenijo %>% filter(kazalnik == "Število osebnih avtomobilov na 1.000 prebivalcev"))
napovedana_leta1 <- data.frame(leto = seq(2019,2025))
napoved <- napovedana_leta1 %>% mutate(stevilo = predict(podatki1, .))

napoved.avtomobili <- bind_rows(napoved, (podatki_za_slovenijo %>%  filter(kazalnik == "Število osebnih avtomobilov na 1.000 prebivalcev")))
names(napoved.avtomobili)[2] <- "stevilo_avtomobilov"
napoved.avtomobili$kazalnik <- NULL

podatki2 <- gam(stevilo ~ leto , data = podatki_za_slovenijo %>% filter(kazalnik == "Število umrlih v cestnoprometnih nesrečah na 10.000 prebivalcev"))
napovedana_leta2 <- data.frame(leto = seq(2019,2025))
napoved2 <- napovedana_leta2 %>% mutate(stevilo = predict(podatki2, .)) 
napoved.smrti <- bind_rows(napoved2, (podatki_za_slovenijo %>%  filter(kazalnik == "Število umrlih v cestnoprometnih nesrečah na 10.000 prebivalcev")))

names(napoved.smrti)[2] <- "stevilo_smrti"
napoved.smrti$kazalnik <- NULL

napoved_umrli_avtomobili <- napoved.avtomobili  %>% full_join(napoved.smrti)
napoved_umrli_avtomobili$napoved_razmerje <- (napoved_umrli_avtomobili$stevilo_smrti* 1000 / (napoved_umrli_avtomobili$stevilo_avtomobilov))

graf_napoved_razmerja <- ggplot(napoved_umrli_avtomobili, aes(x = leto, y = napoved_razmerje)) + 
 geom_point() + scale_x_continuous(name = "Leto", breaks = seq(2009,2025,1)) + ylab("Število umrlih") +
  ggtitle("Napoved števila umrlih v prometnih nesrečah na 100.000 avtomobilov") +
  geom_smooth(method = 'gam', formula = y ~ x, se = FALSE) + theme(axis.text.x=element_text(angle=90, vjust=0.5, hjust=1))
plot(graf_napoved_razmerja)