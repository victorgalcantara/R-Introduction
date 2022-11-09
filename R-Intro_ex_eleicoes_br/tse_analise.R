# Eleicoes Brazil analise
## Author: Victor Alcantara (PPGSA/UFRJ) --- Date: 15.05.21
### Github: 
### Lattes:
### LinkedIn: 

# 0. Packages and Setup -------------------------------------------------------
#install.packages("pacman")
library(pacman)
p_load("rio","tidyverse","psych","janitor"
)

wd = "H:\\Meu Drive\\00 data\\TSE\\eleicoes"
setwd(wd)

data     <- import("2022/votacao_secao_2022_SP.csv")
data2018 <- import("2022/votacao_secao_2022_SP.csv")

d <- data %>% filter(NM_MUNICIPIO == "COTIA",DS_CARGO=="SENADOR")

mpontes = d %>% filter(NM_VOTAVEL == "MARCOS CESAR PONTES")
mfranca = d %>% filter(NM_VOTAVEL == "M\xc1RCIO LUIZ FRAN\xc7A GOMES")
nulos = d %>% filter(NM_VOTAVEL == "VOTO NULO")

sum(mpontes$QT_VOTOS)
sum(mfranca$QT_VOTOS)
sum(nulos$QT_VOTOS)

haddad = d %>% filter(NM_VOTAVEL == "FERNANDO HADDAD",NR_SECAO==220)
tarcis = d %>% filter(NM_VOTAVEL == "TARCISIO GOMES DE FREITAS",NR_SECAO==220)
nulos = d %>% filter(NM_VOTAVEL == "VOTO NULO",NR_SECAO==220)

sum(haddad$QT_VOTOS)
sum(tarcis$QT_VOTOS)
sum(nulos$QT_VOTOS)


