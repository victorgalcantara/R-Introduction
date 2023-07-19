# Title : importando dados da pnad-c
# Author: Victor Gabriel Alcantara 
# Date: 30/08/2022  
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Setup and packages --------------------------------------------------------
library(tidyverse)
library(psych)

getwd() # verifica o dir de trabalho
setwd("G:/Meu Drive/00 data/IBGE/PNADc") # modifica o dir

wd_data_intror <- "G:/Meu Drive/00 GitHub/R-Introduction/000 - P&R/00 data/"

options(scipen=999) # Remove notação científica

# 1. Import dos dados ----------------------------------------------------------
load(paste0(wd_data_intror,"myPNAD2022_1T.RDS"))
bd = myPnad2022

# 1.2 Olhando para a base de dados ---------------------------------------------

# Dimensões dos dados
dim(bd)

# Estrutura dos dados
str(bd)

# Variáveis dos dados
names(bd)

# 2. Algumas analises descritivas ----------------------------------------------

## 2.1 Medidas de tendência central ----
mean(bd$rendOcup)     # média
median(bd$rendOcup)   # mediana

# Medidas de dispersão
var(bd$rendOcup)    # variância
sd(bd$rendOcup)     # desvio-padrão

# Funções úteis para descrição
summary(bd$rendOcup)
psych::describe(bd$rendOcup)

table(bd$raca)

# Cálculos por grupos
# group_by()

t_ocup <- bd %>% group_by(classeOcup1) %>% summarise(
  n = n(),
  me_educ = round(mean(anosEst),1),
  me_rend = mean(rendOcup)
)

t_sexo <- bd %>% group_by(sexo) %>% summarise(
  n = n(),
  me_educ = round(mean(anosEst),1),
  me_rend = mean(rendOcup)
)

t_educ <- bd %>% group_by(anosEst) %>% summarise(
  n = n(),
  me_rend = mean(rendOcup),
  ma_rend = median(rendOcup)
)

## 2.2 Tabelas de frequência ----

tab1 <- table(bd$sexo,bd$raca)

tab1_prop <- prop.table(tab1,margin = 1) # margin 1 = percentual na linha

# 3. Gráficos ------------------------------------------------------------------

plot(x=t_educ$anosEst,y=t_educ$me_rend)

tab1 <- table(bd$sexo)

barplot(tab1,
        main = "Frequência absoluta por sexo",
        col = "steelblue")

# 4. GGPLOT --------------------------------------------------------------------
# Grammar of Graphics

# Barras
ggplot(data=bd,aes(x = sexo))+
  theme_bw()+
  geom_bar(fill="steelblue")+
  scale_y_continuous(expand = c(0.01,0))+
  scale_x_discrete(name="")

# Histograma
ggplot(data=bd,aes(x = rendOcup))+
  theme_bw()+
  geom_histogram()

# Densidade
ggplot(data=bd,aes(x = rendOcup))+
  theme_bw()+
  geom_density()

# Boxplot
d1 <- ggplot(data=bd,aes(x = log(rendOcup),fill=sexo))+
  theme_bw()+
  geom_density()

d1 + facet_wrap(~sexo)

# Dispersão
d1 <- ggplot(data=bd,aes(x = anosEst,y=rendOcup))+
  theme_bw()+
  geom_point()+
  scale_x_continuous(name="Anos de escolarização",
                     limits=c(0,17),breaks = seq(0,18,2),
                     expand = c(0,0))+
  scale_y_continuous(name="Renda da ocupação principal")

d2 <- d1 + stat_smooth(aes(x = anosEst, y = rendOcup), 
                        method = "lm",
                        formula = y ~ x, se = FALSE)

d2 + facet_wrap(~sexo)
