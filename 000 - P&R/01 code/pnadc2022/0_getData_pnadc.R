# Title : importando dados da pnad-c
# Author: Victor Gabriel Alcantara 
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Setup and packages --------------------------------------------------------
#install.packages("pacman")
library(pacman)
p_load(tidyverse,PNADcIBGE)

wd <- "G:/Meu Drive/00 data/IBGE/PNADc"
setwd(wd)

# 1. Get data ------------------------------------------------------------------

year <- 2012:2022

# To create directories/folders ----
for(i in 1:length(year)){
  print(i)
  dir.create(paste0(year[i]))
  dir.create(paste0(year[i],"/1trim"))
  dir.create(paste0(year[i],"/1visit"))
}


# Request quarters data ----

for(i in 11){
  print(i)

# Requisitando/baixando dados da pnad-c 2022, 1º trim
pnadc <- get_pnadc(year = year[i], # ano
                      quarter = 1, # trimestre
                      design = F,   # estrutura específica survey design
                      labels = F
                      )

# Saving all data from pnadc

# R Data Format
save(pnadc,
     file = paste0(year[i],"/1trim/pnadc_",year[i],".RDS"))

# CSV format
write.csv(pnadc,
          file = paste0(year[i],"/1trim/pnadc_",year[i],".csv"),
          row.names = F)

# Cleaning memory
rm(pnadc)
gc()

}

# Request anual data ----

for(i in 1:5){
  print(i)
  
  # Requisitando/baixando dados da pnad-c 2022, 1º trim
  pnadc_anual_1visit <- get_pnadc(
                     year = year[i],# ano
                     interview = 1, # visita 1
                     design = F,    # estrutura survey design
                     vars = c("UF","Capital",
                              "V1022", # Área rural/urbana
                              "V1023", # Tipo de área
                              "V2009", # Idade
                              "V2007", # Sexo
                              "V2010", # Cor/Raca
                              "VD3005",# Anos de estudo
                              "VD4016",# Renda da ocupacao princip
                              "V4010", # Código ocup princip
                              "V4013", # CNAE 2.0
                              "V2001","V2005","V3007","VD3004",
                              "VD4001","VD4002","VD4020","VD4035",
                              "V4097" # Sindicalizacao
                              )
  )
  
  # Saving all data from pnadc
  
  # R Data Format
  save(pnadc_anual_1visit,
       file = paste0(year[i],"/1visit/selected_pnadc_anual_1visit_",year[i],".RDS"))
  
  # CSV format
  # write.csv(pnadc_anual_1visit,
  #           file = paste0(year[i],"/1visit/selected_pnadc_anual_1visit_",year[i],".csv"),
  #           row.names = F)
  
  # Cleaning memory
  rm(pnadc_anual_1visit)
  gc()
  
}
