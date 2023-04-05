# Title : importando dados da pnad-c
# Author: Victor Gabriel Alcantara 
# Date: 30/08/2022  
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Setup and packages --------------------------------------------------------
install.packages("PNADcIBGE")
library(PNADcIBGE)
library(tidyverse)
library(openxlsx)

# Requisitando/baixando dados da pnad-c 2022, 1º trim
pnad2022 <- get_pnadc(year = 2022, # ano
                      quarter = 1, # trimestre
                      design = F   # estrutura específica survey design
                      )

save(pnad2022,file = "PNAD2022_1T.RDS")

# Selecionando vars de interesse
myPnad2022 <- pnad2022 %>% select(
  "UF",
  "V1022", # Área rural/urbana
  "V1023", # Tipo de área
  "V1028", # Peso amostral
  "V2009", # Idade
  "V2007", # Sexo
  "V2010", # Cor/Raca
  "VD3005",# Anos de estudo
  "VD4016",# Renda da ocupacao princip
  "V4010"  # Código ocup princip 
)

# Renomeando vars

myPnad2022 <- myPnad2022 %>% rename(.,
                                    peso = "V1028",
                                    area = "V1022",
                                    tipoArea = "V1023",
                                    idad = "V2009",
                                    sexo = "V2007",
                                    raca = "V2010",
                                    educ = "VD3005",
                                    rend = "VD4016",
                                    ocup = "V4010"
                                    )

myPnad2022_sp <- myPnad2022 %>% filter(UF == "São Paulo")

# Amostragem aleatória para fins didáticos

s <- sample(x=1:475193,size = 50000,replace = F)

myPnad2022 <- myPnad2022[s,]

# Note que estamos acabando com o design amostral da pnad-c
# para fins didáticos.

# Salvando objeto com os dados
getwd() # verifica o dir de trabalho
setwd("G:/Meu Drive/00 data/IBGE/PNADc/1T_2022") # modifica o dir

write.csv(x = myPnad2022,
          file="myPNAD2022_1T.csv")

save(object = myPnad2022,
     file="myPNAD2022_1T.RDS")

write.xlsx(x= myPnad2022,"myPNAD2022_1T.xlsx")

# Pnad SP

write.csv(x = myPnad2022_sp,
          file="myPNAD2022_1T_SP.csv")

save(object = myPnad2022_sp,
     file="myPNAD2022_1T_SP.RDS")

write.xlsx(x= myPnad2022_sp,"myPNAD2022_1T_SP.xlsx")
