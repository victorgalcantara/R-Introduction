# Title : importando dados da pnad-c
# Author: Victor Gabriel Alcantara 
# Date: 30/08/2022  
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Setup and packages --------------------------------------------------------
install.packages("PNADcIBGE")
library(PNADcIBGE)
library(tidyverse)

# Requisitando/baixando dados da pnad-c 2022, 1º trim
pnad2022 <- get_pnadc(year = 2022, # ano
                      quarter = 1, # trimestre
                      design = F   # estrutura específica survey design
                      )

# Selecionando vars de interesse
myPnad2022 <- pnad2022 %>% select(
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
                                    idad = "V2009",
                                    sexo = "V2007",
                                    raca = "V2010",
                                    educ = "VD3005",
                                    rend = "VD4016",
                                    ocup = "V4010"
                                    )

# Amostragem aleatória para fins didáticos
# sample(x=1:6,size=1,replace=F)
s <- sample(x=1:475193,size = 50000,replace = F)
myPnad2022_1trim <- myPnad2022[s,]

# Note que estamos acabando com o design amostral da pnad-c
# para fins didáticos.

# Salvando objeto com os dados
getwd() # verifica o dir de trabalho
setwd("H:/Meu Drive/00 data/IBGE/PNADc") # modifica o dir

write.csv(x = myPnad2022_1trim,
          file="sample_Pnad2022_1trim.csv")

save(object = myPnad2022_1trim,
          file="sample_myPnad2022_1trim.RDS")
