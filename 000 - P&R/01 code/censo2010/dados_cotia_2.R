# Title : manuseando dados do censo 2010 - Setores censitários
# Author: Victor Gabriel Alcantara 
# Date: 30/08/2022  
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Packages and setup --------------------------------------------------------

# install.package(pacman)
library(pacman)
p_load(tidyverse,rio,janitor,patchwork,geobr)

# To clean memory
rm(list=ls()) # Remove all objects
gc() # Garbage Clean

# Work directories
wd_outp_intror <- "G:/Meu Drive/00 GitHub/R-Introduction/A03 - Import and Tidy Data/02 outp"
wd_data_intror <- "G:/Meu Drive/00 GitHub/R-Introduction/000 - P&R/00 data/"

# Data censo
wd_data_censo <- "G:/Meu Drive/00 data/IBGE/CENSO/SETORES CENSO/"

# 1. Import data ---------------------------------------------------------------

# Population census
basico_SP2 <- import(file = paste0(wd_data_censo,"/SP_Exceto_a_Capital_20190207/CSV/Basico_SP2.csv"))

Pessoa03_SP <- import(file = paste0(wd_data_censo,"/SP_Exceto_a_Capital_20190207/CSV/Pessoa03_SP.csv"))

# Geographic data of SP State
geo_sp <- read_census_tract(code_tract = 35,year = 2010)

# 1.1 View data ----------------------------------------------------------------

# Dimesions
dim(Pessoa03_SP)

# Structure
str(Pessoa03_SP)

# 1. Data imput and merge --------------------------------------

# Substituindo vírgulas por pontos (notação inglesa)
basico_SP2 <- basico_SP2 %>% mutate_all(~ gsub(",", ".", .))

# Transformando a variável renda para métrica
basico_SP2 <- basico_SP2 %>%  mutate(
  V009 = as.numeric(V009)
) 

basico_SP2 <- basico_SP2 %>% rename(
  "code_tract" = Cod_setor,
  "me_rend" = V009
)

# Selecionando apenas cod do setor e renda das pessoas
mydata1 <- basico_SP2 %>% select(code_tract,me_rend)

# Fazendo o mesmo com a base das pessoas
Pessoa03_SP <- Pessoa03_SP %>% mutate_all(~ gsub(",", ".", .))

Pessoa03_SP <- Pessoa03_SP %>% mutate(.,
                                    qt_pessoas=as.numeric(V001),
                                    qt_brancos = as.numeric(V002),         
                                    qt_pretos = as.numeric(V003),
                                    qt_amarelos = as.numeric(V004),
                                    qt_pardos = as.numeric(V005),
                                    qt_indigena = as.numeric(V006),
)

Pessoa03_SP <- Pessoa03_SP %>% mutate(
  p_PPI = (qt_pretos+qt_pardos+qt_indigena)/qt_pessoas,
  p_negros = (qt_pretos+qt_pardos)/qt_pessoas,
  p_amarelos = qt_amarelos/qt_pessoas,
  p_indigena = qt_indigena/qt_pessoas,
) %>% rename(
  "code_tract" = Cod_setor
)

mydata2 <- Pessoa03_SP %>% select(code_tract,p_negros,p_PPI,qt_pessoas)

mydata <- merge(mydata1,mydata2)

mydata <- merge(geo_sp,mydata, by = "code_tract")

# 2. Data management -------------------------------------------

mydata <- mydata %>% mutate(.,me_rend_cor = me_rend*1.8309)

summary(mydata$me_rend_cor)

mydata$me_renda2 <-  cut(mydata$me_rend_cor,
                         breaks = c(0,1000,2000,5000,10000,max(mydata$me_rend, na.rm = T)),
                         labels = c("0 - 1000", "1000 - 2000", 
                                    "2000 - 5000","5000 - 10000", "+ 10000"),
                         ordered_result = T)

mydata$p_PPI2 <-  cut(mydata$p_PPI,
                         breaks = c(0,.2,.3,.4,.5,max(mydata$p_PPI, na.rm = T)),
                         labels = c("0 - 20%", "20% - 30% ", "30% - 40%",
                                    "40% - 50%", "+ 50%"),
                         ordered_result = T)

# mydata$dens_pop2 <-  cut(mydata$densidade_pop,
#                          breaks = c(0,2500,5000,10000,15000,max(mydata$densidade_pop, na.rm = T)),
#                          labels = c("      0 - 2500 ", "  2500 - 5000 ", "  5000 - 10000",
#                                     "10000 - 15000", "  + 15000"),
#                          ordered_result = T)

# 2. Plot maps --------------------------------------------------

mydata <- mydata %>% filter(code_muni == 3513009)

# We have to remove axis from the ggplot layers
no_axis <- theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank())
# Mean of income
map_cotia_renda <- mydata %>% drop_na(me_renda2) %>% ggplot() +
  geom_sf(aes(fill = me_renda2), show.legend = T,color=NA) +
  scale_fill_manual(name="Renda média \n em Reais (R$)",
                    values = rev(heat.colors(6, alpha = 1.0)))+
  theme_minimal()+
  labs(title = "Composição Econômica")+
  no_axis

# Proportion race
map_cotia_raca <- mydata %>% drop_na(p_PPI2) %>% ggplot() +
  geom_sf(aes(fill = p_PPI2), show.legend = T,color=NA) +
  scale_fill_manual(name="Proporção \n PPI",
                    values = rev(heat.colors(6, alpha = 1.0)))+
  theme_minimal()+
  labs(title = "Composição étnico-racial")+
  no_axis

plt_map_renda_raca <- map_cotia_renda+map_cotia_raca+
  plot_annotation(tag_levels = "A")

# Save plot
dev.off()
pdf(file=paste0(wd_out_graph,"map_raca.pdf"),
    width = 10, height = 6)
plot(plt_map_renda_raca)
dev.off()

# 3. Explorando escolas em Cotia -----------------------------------------------

geo_schools <- read_schools(year = 2020)

schools_cotia <- geo_schools %>% filter(name_muni == "Cotia")

map_cotia_renda + geom_sf(data = schools_cotia,
                             color="black",size=1,shape=1)

# Olhem a minha escola
mySchool <- schools_cotia %>% filter(name_school %in% c("SIDRONIA NUNES PIRES",
                                                        "IDALINA GODINHO DA SILVA EM",
                                                        "IVO MARIO ISAAC PIRES PREFEITO EM"))

map_cotia_renda + geom_sf(data = mySchool,
                          color="black",size=1.5,shape=1)
