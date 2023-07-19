# Title : manuseando dados da pnad-c
# Author: Victor Gabriel Alcantara 
# Date: 19/07/2023  
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Setup and packages --------------------------------------------------------
#install.packages()

library(tidyverse)
library(openxlsx)
library(rio)

getwd() # verifica o dir de trabalho
setwd("G:/Meu Drive/00 data/IBGE/PNADc") # modifica o dir

wd_data_intror <- "G:/Meu Drive/00 GitHub/R-Introduction/000 - P&R/00 data/"

# 1. Import dos dados ----------------------------------------------------------
pnadc2022 <- import("2022/1trim/pnadc_2022_1T.csv")

# 2. Manuseio dos dados --------------------------------------------------------

# Selecionando vars de interesse
myPnad2022 <- pnadc2022 %>% select(
  "UF","Capital",
  "V1022", # Área rural/urbana
  "V1023", # Tipo de área
  "V1028", # Peso amostral
  "V2009", # Idade
  "V2007", # Sexo
  "V2010", # Cor/Raca
  "VD3004",# Nvl de instrução mais elevado
  "VD3005",# Anos de estudo
  "VD4001",# Pos forca de trab
  "VD4002",# Pos ocup
  "VD4016",# Renda da ocupacao princip
  "VD4009",# Pos ocupacional
  "V4010", # Código ocup princip
  "VD4010",# Agrupamento ocup1
  "VD4011" # Agrupamento ocup2
)

# Renomeando vars

myPnad2022 <- myPnad2022 %>% rename(.,
                                    area = "V1022", # Área rural/urbana
                                    tipoArea = "V1023", # Tipo de área
                                    peso = "V1028", # Peso amostral
                                    idad = "V2009", # Idade
                                    sexo = "V2007", # Sexo
                                    raca = "V2010", # Cor/Raca
                                    nvlMaisElevado = "VD3004",# Nvl de instrução mais elevado
                                    anosEst = "VD3005",# Anos de estudo
                                    posTrab = "VD4001",# Pos forca de trab
                                    posOcup = "VD4002",# Pos ocup
                                    rendOcup = "VD4016",# Renda da ocupacao princip
                                    grupPosOcup="VD4009",# grupos de pos ocupacional
                                    ocup = "V4010", # Código ocup princip
                                    classeOcup1="VD4010",# Agrupamento ocup1
                                    classeOcup2="VD4011" # Agrupamento ocup2
)

# Função mutate para transformar nossas variáveis
myPnad2022 <- myPnad2022 %>% 
  mutate(.,
         
         ln_rendOcup = log(rendOcup),
         
         # Formatando para numérico
         anosEst = ifelse(
           test = anosEst == "Sem instrução e menos de 1 ano de estudo",
           yes  = 0,
           no   = as.numeric(anosEst)),
         
         ocup = as.numeric(ocup),
         
         sexo = case_when(
           sexo == 1 ~ "M",
           sexo == 2 ~ "F",
         ),
         
         raca = case_when(
           raca == 1 ~ "Branca",
           raca == 2 ~ "Preta",
           raca == 3 ~ "Amarela",
           raca == 4 ~ "Parda ",
           raca == 5 ~ "Indígena",
           raca == 9 ~ "Ignorado"
         ),
  )

myPnad2022_mg <- myPnad2022 %>% filter(UF == "31")

# Amostragem aleatória para fins didáticos

myPnad2022 <- myPnad2022 %>% na.exclude()

# Nova amostragem aleatória da pnadc para fins didáticos
# Desconsidera design específico da pnadc

s <- sample(x=1:475193,size = 50000,replace = F)
myPnad2022 <- myPnad2022[s,]

# Note que estamos acabando com o design amostral da pnad-c
# para fins didáticos.

# Salvando objeto com os dados

write.csv(x = myPnad2022,
          file=paste0(wd_data_intror,"myPNAD2022_1T.csv"))

write.xlsx(x= myPnad2022,
           file=paste0(wd_data_intror,"myPNAD2022_1T.xlsx"))

save(object = myPnad2022,
     file=paste0(wd_data_intror,"myPNAD2022_1T.RDS"))

# Usando pacote RIO
export(x = myPnad2022,
       file=paste0(wd_data_intror,"myPNAD2022_1T.csv"))