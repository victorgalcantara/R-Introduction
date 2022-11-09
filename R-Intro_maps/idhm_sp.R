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

wd <- "G:\\Meu Drive\\00 data\\ATLASBR"
setwd(wd)

# 1. Import data --------------------------------------------------------------
# Escolas no SAEB2017, Escolas no cat?logo INEP,

# SP
d_sp <- import("data_sp.xlsx")
tail(d_sp)
d_sp <- d_sp[-c(1,646:648),]

d_sp[500:510,"Territorialidades"]
muni$name_muni[500:510]
#### MALHA CARTOGRÁFICA
muni   <- read_municipality(code_muni = "SP",year = 2010)
muni$code <- 1:645


# 2. Data management -------------------------------------------------------

d_sp$name_muni = str_remove(string = d_sp$Territorialidades,pattern = "(SP)")
d_sp$name_muni = gsub(x = d_sp$name_muni,"[()]","")

d_sp$name_muni2 = gsub(x = d_sp$name_muni," ","")
muni$name_muni2 = gsub(x = muni$name_muni," ","")


df_muni <- merge(muni,d_sp,by="name_muni2")

str(df_muni)

t = muni %>% select(order("name_muni"))

# 3. Maps ---------------------------------------------------------------------

# We have to remove axis from the ggplot layers
no_axis <- theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank())

#### Mapas

# SP

ggplot() +
  geom_sf(data=df_muni, aes(fill=`Índice de Gini 2010`), color= "Black", size=0.01) + #try color = "Grey"
  labs(title="IDHM 2010", subtitle = "São Paulo", size=8,
       caption = "Fonte: AtlasBR") +
  theme_minimal() +
  no_axis

ggplot() +
  geom_sf(data=df_muni, aes(fill=`% de cobertura vegetal natural 2017`), color= "Black", size=0.01) + #try color = "Grey"
  labs(title="IDHM 2010", subtitle = "São Paulo", size=8,
       caption = "Fonte: AtlasBR") +
  theme_minimal() +
  no_axis

