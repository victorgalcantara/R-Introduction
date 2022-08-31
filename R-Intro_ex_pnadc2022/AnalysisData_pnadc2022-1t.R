# Title : importando dados da pnad-c
# Author: Victor Gabriel Alcantara 
# Date: 30/08/2022  
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Setup and packages --------------------------------------------------------
library(tidyverse)

getwd() # verifica o dir de trabalho
setwd("H:/Meu Drive/00 data/IBGE/PNADc") # modifica o dir

# 1. Import dos dados ----------------------------------------------------------
load("myPnad2022_1trim.RDS")
bd = myPnad2022_1trim

# 2. Algumas analises descritivas ----------------------------------------------

t <- bd %>% group_by(vd_ocup) %>% summarise(
  n = n(),
  me_educ = round(mean(educ),1),
  me_rend = mean(rend)
)

t <- bd %>% group_by(sexo) %>% summarise(
  n = n(),
  me_educ = round(mean(educ),1),
  me_rend = mean(rend)
)

