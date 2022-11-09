# Title : importando dados da pnad-c
# Author: Victor Gabriel Alcantara 
# Date: 30/08/2022  
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Setup and packages --------------------------------------------------------
library(tidyverse)
library(psych)

getwd() # verifica o dir de trabalho
setwd("H:/Meu Drive/00 data/IBGE/PNADc") # modifica o dir

options(scipen=999) # Remove notação científica

# 1. Import dos dados ----------------------------------------------------------
load("myPnad2022_1trim.RDS")
bd = myPnad2022_1trim

# 2. Algumas analises descritivas ----------------------------------------------

## 2.1 Medidas de tendência central ----
mean(bd$rend)     # média
median(bd$rend)   # mediana

# Medidas de dispersão
var(bd$rend)    # variância
sd(bd$rend)     # desvio-padrão

# Funções úteis para descrição
summary(bd$rend)
psych::describe(bd$rend)

table(bd$raca)

# Cálculos por grupos
# group_by()

t_ocup <- bd %>% group_by(vd_ocup) %>% summarise(
  n = n(),
  me_educ = round(mean(educ),1),
  me_rend = mean(rend)
)

t_sexo <- bd %>% group_by(sexo) %>% summarise(
  n = n(),
  me_educ = round(mean(educ),1),
  me_rend = mean(rend)
)

t_educ <- bd %>% group_by(educ) %>% summarise(
  n = n(),
  me_rend = mean(rend),
  ma_rend = median(rend)
)

## 2.2 Tabelas de frequência ----

tab1 <- table(bd$sexo,bd$raca)

tab1_prop <- prop.table(tab1,margin = 1) # margin 1 = percentual na linha

# 3. Gráficos ------------------------------------------------------------------

plot(x=t_educ$educ,y=t_educ$me_rend)

tab1 <- table(bd$sexo)

barplot(tab1,ylim = c(0,15000),
        main = "Frequência absoluta por sexo",
        col = "steelblue")

boxplot(data=bd,rend ~ sexo)
boxplot(data=bd,ln_rend ~ sexo)

# 4. GGPLOT --------------------------------------------------------------------
# Grammar of Graphics

# Barras
ggplot(data=bd,aes(x = sexo))+
  theme_bw()+
  geom_bar(fill="steelblue")+
  scale_y_continuous(limits = c(0,12000),expand = c(0.01,0))+
  scale_x_discrete(name="")

# Histograma
ggplot(data=bd,aes(x = ln_rend))+
  theme_bw()+
  geom_histogram()

# Densidade
ggplot(data=bd,aes(x = rend))+
  theme_bw()+
  geom_density()

# Boxplot
ggplot(data=bd,aes(x = vd_ocup,y=idad))+
  theme_bw()+
  geom_boxplot(fill="steelblue")+
  coord_flip()

# Dispersão
ggplot(data=bd,aes(x = educ,y=ln_rend))+
  theme_bw()+
  geom_point()+
  scale_x_continuous(name="Anos de escolarização")+
  scale_y_continuous(name="ln renda")#+
  # stat_smooth(aes(x = educ, y = ln_rend), method = "lm",
  #             formula = y ~ x, se = FALSE)+
  #facet_wrap(~sexo)
