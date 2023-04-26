# Maps : IDEB Municipios
# Author: Victor G Alcantara
# date : 21.11.21

# Dados retirados do Inep
# https://www.gov.br/inep/pt-br/areas-de-atuacao/pesquisas-estatisticas-e-indicadores/ideb/resultados

# 0. Packages and setup -------------------------------------------------------

library(tidyverse)
library(rio)
library(readxl)
library(geobr)
require(sf)

wd <- "G:\\Meu Drive\\00 data\\EDUC\\IDEB\\EM"
setwd(wd)

# 1. Import data --------------------------------------------------------------

#### IDEB
# UF
ideb2021_uf <- import("UF/divulgacao_regioes_ufs_ideb_2021.xlsx")
# colnames(ideb2021_uf) <- ideb2021_uf[9,]
# ideb2021_uf <- ideb2021_uf[-c(1:9),]

# Municipios
ideb2021_muni <- import("MUNI/divulgacao_ensino_medio_municipios_2021.xlsx")
colnames(ideb2021_muni) <- ideb2021_muni[9,]
ideb2021_muni <- ideb2021_muni[-c(1:9),]

#### MALHA CARTOGRÁFICA
brasil <- read_state(year = 2020)
muni   <- read_municipality(year = 2020)

# 2. Data management -------------------------------------------------------

str(brasil)

# IDEB POR ESTADO
ideb2021_uf <- ideb2021_uf %>% filter(rede == "Estadual")
colnames(ideb2021_uf)[1] <- "name_state"

ideb2021_uf <- ideb2021_uf %>% mutate(.,
                                          ideb2021 = as.numeric(ideb2021)
)

ideb2021_muni <- ideb2021_muni %>% mutate(.,
                          ideb2021 = as.numeric(VL_OBSERVADO_2021)
                          )

muni$code_muni <- as.character(muni$code_muni)

df_muni <- merge(muni,ideb2021_muni,by.x="code_muni",by.y="CO_MUNICIPIO")
df_bras <- merge(brasil,ideb2021_uf,by="name_state")

# 3. Maps ---------------------------------------------------------------------

# We have to remove axis from the ggplot layers
no_axis <- theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank())

#### Mapas

# Brasil

ggplot() +
  geom_sf(data=Brasil, aes(fill=nivel_particip), color= "Black", size=0.01) + #try color = "Grey"
  labs(title="Participa??o de Escolas P?blicas no SAEB", subtitle = "Estados do Brasil, 2017", size=8,
       caption = "Fonte: Instituto de Pesquisas Educacionais An?sio Teixeira (INEP)") +
  scale_fill_manual(values = heat.colors(5, alpha = 1.0), name="N?vel de participa??o \nPropor??o relativa ao Estado") +
  theme_minimal() +
  no_axis

# Municipios

df %>% ggplot() +
  geom_sf(aes(fill=VL_OBSERVADO_2021), color= "Black", size=0.01) + #try color = "Grey"
  labs(title="IDEB 2021", subtitle = "Municípios, 2021", size=8,
       caption = "Fonte: Instituto de Pesquisas Educacionais Anísio Teixeira (INEP)") +
  theme_minimal() +
  no_axis

