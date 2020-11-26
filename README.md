# Analiza podatkov s programom R, 2019/20

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2019/20

* [![Shiny](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/jaanos/APPR-2019-20/master?urlpath=shiny/APPR-2019-20/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/jaanos/APPR-2019-20/master?urlpath=rstudio) RStudio

## Analiza transporta v Sloveniji in Evropi

V svoji projektni nalogi bom analizirala podatke o potniškem transportu v Sloveniji in Evropi v obdobju med 2006 in 2014, saj menim, da je to obdobje zaradi finančne krize 2008 za analizo podatkov zelo zanimivo. Najprej bom analizirala cestni, železniški, letalski in pristaniški potniški promet v Sloveniji. Zanimalo me bo, kako se je struktrua prometa skozi čas spreminjala in to nato primerjala s podatki o potniškem prometu v drugih članicah EU. Nadaljnje se bom osredotočila samo na Slovenijo, kjer bom analizirala cestni promet, saj predvidevam, da največ prebivalcev Slovenije uporablja to vrso prometa. Cestni promet bom analizirala po regijah, kjer me bo zanimalo, kako se je po posameznih regijah in skozi čas spreminjalo število registriranih avtomobilov, povprečna starost avtomobilov in kakšne vrste motornih vozil prevladujejo, ter če je to kako povezano s številom delovnih migracij ter stopnjo brezposlenosti. Zanimalo me bo tudi kako se je po regijah spreminjala gostota cestnega omrežja po regijah in kako je to povezano s številom umrlih v prometnih nesrečah. 

## Tabele

1. tabela: Letalski promet po državah EU (države, leto).
2. tabela: Pristaniški promet po državah EU (države, leto).
3. tabela: Železniški promet po državah EU (države, leto).
4. tabela: cestni promet po državah EU (države, leto).
5. tabela: Cestna vozila v Sloveniji (vrsta vozila, statistična regija, leto).
6. tabela: Delovne migracije v Sloveniji (regija, delovno aktivno prebivalstvo, indeks dnevnih migracij, leto).
7. tabela: Nekateri kazalniki transporta po statističnih regijah (število osebnih avtomobilov, povprečna starost osebnih avtomobilov, gostota cestnega omrežja, število umrlih v cestnoprometnih nesrečah, leto).

* Vire bom črpala z [Eurostata](https://ec.europa.eu/eurostat) in s [SiStata](https://pxweb.stat.si/SiStat/sl).


## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `rgeos` - za podporo zemljevidom
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `tidyr` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-201819)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
