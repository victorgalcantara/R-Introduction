# Title : manuseando dados da pnad-c
# Author: Victor Gabriel Alcantara 
# Date: 30/08/2022  
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Setup and packages --------------------------------------------------------
library(tidyverse)

getwd() # verifica o dir de trabalho
setwd("G:/Meu Drive/00 data/IBGE/PNADc") # modifica o dir

# 1. Import dos dados ----------------------------------------------------------
load("sample_myPnad2022_1trim.RDS")

# 2. Manuseio dos dados --------------------------------------------------------
# Select e Filter

# "!" em geral é "negação"
myPnad2022_1trim <- myPnad2022_1trim %>% select(!peso) 

myPnad2022_1trim <- myPnad2022_1trim %>% filter(idad > 18,
                                                idad < 65)

# Limpeza e formatação

unique(myPnad2022_1trim$educ)

myPnad2022_1trim <- myPnad2022_1trim %>% 
  mutate(.,
         # Formatando para numérico
         educ = ifelse(
           test = educ == "Sem instrução e menos de 1 ano de estudo",
           yes  = 0,
           no   = as.numeric(educ)),
         
         ocup = as.numeric(ocup),
         
         ln_rend = log(rend)
  )

myPnad2022_1trim <- myPnad2022_1trim %>% 
  mutate(.,
         # Grupamento das ocup pelo IBGE (anexos)
         vd_ocup = case_when(
           ocup >= 1111 & ocup <= 1439 ~ "Diretores e gerentes",
           ocup >= 2111 & ocup <= 2659 ~ "Profissionais das ciências e intelectuais",
           ocup >= 3111 & ocup <= 3522 ~ "Técnicos e profissionais de nível médio",
           ocup >= 4110 & ocup <= 4419 ~ "Trabalhadores de apoio administrativo",
           ocup >= 5111 & ocup <= 5419 ~ "Trabalhadores dos serviços, vendedores dos
comércios e mercados",
           ocup >= 6111 & ocup <= 6225 ~ "Trabalhadores dos serviços, vendedores dos
comércios e mercados",
           ocup >= 7111 & ocup <= 7549 ~ "Trabalhadores qualificados, operários e artesões
da construção, das artes mecânicas e outros
ofícios",
           ocup >= 8111 & ocup <= 8350 ~ "Operadores de instalações e máquinas e
montadores",
           ocup >= 9111 & ocup <= 9629 ~ "Ocupações elementares",
           ocup >= 110 & ocup <= 512 ~ "Membros das forças armadas, policiais e
bombeiros militares",
           ocup >= 0 ~ "Ocupações maldefinidas",
         )
  )

# Exclui todos os casos com NA
myPnad2022_1trim <- na.exclude(myPnad2022_1trim)

# Salvando objeto com os dados
write.csv(x = myPnad2022_1trim,
          file="myPnad2022_1trim.csv")

save(object = myPnad2022_1trim,
     file="myPnad2022_1trim.RDS")
