# Title : manuseando dados do censo 2010
# Author: Victor Gabriel Alcantara 
# Date: 20/07/2023
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# 0. Packages and setup --------------------------------------------------------
# install.package(pacman)
library(pacman)
p_load(tidyverse,rio,janitor,openxlsx,geobr,stats)

getwd() # verifica o dir de trabalho
setwd("G:/Meu Drive/00 data/IBGE/CENSO") # modifica o dir

# To clean memory
rm(list=ls()) # Remove all objects
gc() # Garbage Clean

processQuantiles <- function(data, col,q, output_col) {
  quantiles <- quantile(data[[col]], probs = seq(0, 1, q), na.rm = TRUE)
  
  for (i in 1:length(quantiles)) {
    condition <- data[[col]] > quantiles[i] & data[[col]] <= quantiles[i + 1]
    condition[is.na(condition)] <- FALSE
    data[condition, output_col] <- i
  }
  
  return(data)
}

# Work directories
wd_outp_intror <- "G:/Meu Drive/00 GitHub/R-Introduction/A03 - Import and Tidy Data/02 outp/"
wd_data_intror <- "G:/Meu Drive/00 GitHub/R-Introduction/000 - P&R/00 data/"

# Data censo
wd_censo <- "G:/Meu Drive/00 data/IBGE/CENSO/"

# 1. Import data ------------------------------------------------

# Fist try from IBGE
# Population census

auxDataCenso <- import(file =
                         paste0(wd_censo,
                                "Result Gerais Amostra/Documentação/tam_var_bases.csv"))

auxDataCenso$dec <- ifelse(is.na(auxDataCenso$dec),0,auxDataCenso$dec)

auxDataCenso$tam2 <- auxDataCenso$tam+auxDataCenso$dec

# Read Fixed Width Format (FWF)
auxDataCenso <- auxDataCenso %>% filter(base == "PESSOAS")

# Importando dados do censo
censo_pessoas_RMSP <- read.fwf(file =
paste0(wd_censo,"Result Gerais Amostra/SP2-RM/Amostra_Pessoas_35_RMSP.txt"),
                         widths = auxDataCenso$tam2,fileEncoding = "ASCII")

# Imput dos códigos das variáveis
colnames(censo_pessoas_RMSP) <- auxDataCenso$cod

# Salvando em RDS
save(censo_pessoas_RMSP,file = paste0(wd_censo,"censo_pessoas_SP2RM.RDS"))

# Salvando em CSV
export(censo_pessoas_RMSP,file = paste0(wd_censo,"censo_pessoas_SP2RM.csv"))

# Filtrando pelo código do município de Cotia-SP
data_censo_cotia <- censo_pessoas_RMSP %>% filter(V0002 == 13009)

# Salvando dados de Cotia-SP
save(data_censo_cotia,file = paste0(wd_censo,"censo_pessoas_cotia.RDS"))

export(data_censo_cotia,file = paste0(wd_censo,"censo_pessoas_cotia.csv"))

# Censo SP
load(file = paste0(wd_censo,"Result Gerais Amostra/CEM/data_censo_sp.RDS"))

data_censo_cotia <- data_censo_sp %>% filter(cem_harm_codmunic2010 == 351300)

# 2. Management ----------------------------------------------------------------

data_censo_cotia <- data_censo_cotia %>% 
  mutate(.,
         renda = cem_harm_rendaindividualtotal*1.8309,
         
         PIT = ifelse(cem_harm_idade > 14,1,0), # Pessoas em Idade de Trabalhar
         
         raca = case_when(
           cem_harm_raca == 1 ~ "Brancos",
           cem_harm_raca %in% c(2:3) ~ "PPI",
         ),
         
         nvlEsc = factor(cem_harm_niveleducacao,
                         levels=c(1:9),
                         labels=c('Nenhum',
                                  'EFI incompl.',
                                  'EFI compl.',
                                  'EFII incompl.',
                                  'EFII compl.',
                                  'EM Incompl.',
                                  'EM compl.',
                                  'ES incompl.',
                                  'ES compl.'))
                                                )

# Médias
data_censo_cotia %>% filter(PIT == 1) %>% 
  group_by(raca) %>% summarise(
  me = weighted.mean(renda,
                na.rm = T,wheight=cem_harm_peso)
)

data_censo_cotia_b <- data_censo_cotia %>% 
  filter(PIT == 1 & renda > 0)

data_censo_cotia_b <- processQuantiles(data = data_censo_cotia_b,
                                     col = "renda",
                                     output_col = "q_renda",q=0.1)

data_censo_cotia_b <- processQuantiles(data = data_censo_cotia_b,
                                     col = "renda",
                                     output_col = "q_renda",q=0.1)

tab_qRenda <- data_censo_cotia_b %>% 
  group_by(raca,q_renda) %>% summarise(
  me=weighted.mean(renda,na.rm=T),wheight=cem_harm_peso)

tab_qRenda <- tab_qRenda %>% mutate(.,
                                    q_renda=as.numeric(q_renda),
)

plt_distRenda <- tab_qRenda %>% drop_na(q_renda) %>% 
  ggplot(aes(x = q_renda,y=me,col=raca))+
  theme_bw()+
  geom_line(lwd=1)+
  scale_x_continuous(limits = c(1,10),breaks = seq(0,100,1))+
  scale_y_continuous(breaks = seq(0,20000,2500))+
  scale_color_manual(values=c("red","black"))+
  labs(y="Renda média em reais (R$)",x="Decis da distribuição",
       col="Cor/Raça")

# Save plot
dev.off()
pdf(file=paste0(wd_out_graph,"plt_distRenda.pdf"),
    width = 10, height = 6)
plot(plt_distRenda)
dev.off()

# Nvl escolaridade ----

tab_raca = data_censo_cotia %>% filter(cem_harm_idade > 24) %>% 
  tabyl(raca,nvlEsc) %>% adorn_percentages("row")

tab_raca = tab_raca %>% gather(key = nvlEsc,value = "prop",-raca)

tab_raca <- tab_raca %>% mutate(.,
                              nvlEsc = factor(nvlEsc,
                                              levels=c('Nenhum',
                                                       'EFI incompl.',
                                                       'EFI compl.',
                                                       'EFII incompl.',
                                                       'EFII compl.',
                                                       'EM Incompl.',
                                                       'EM compl.',
                                                       'ES incompl.',
                                                       'ES compl.'),
                                              ordered = T)  
                              )

tab_raca %>% drop_na(nvlEsc,raca) %>% 
  ggplot(aes(x = nvlEsc,fill=raca))+
  theme_bw()+
  geom_bar(aes(y=prop),stat="identity",position="dodge",alpha=.7)+
  scale_y_continuous(limits = c(0,.3),breaks = seq(0,.3,.05),expand = c(0.0,0.001))+
  scale_fill_manual(values=c("green","blue"))+
  labs(y="Frequência relativa",x="",fill="")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# População branca com ES
tab_raca %>% filter(raca == "Brancos" & nvlEsc %in% c('ES incompl.','ES compl.')) %>%
  summarise(p = sum(prop))

# População PPI com ES
tab_raca %>% filter(raca == "PPI" & nvlEsc %in% c('ES incompl.','ES compl.')) %>%
  summarise(p = sum(prop))

# População branca no fundamental
tab_raca %>% filter(raca == "PPI" & nvlEsc %in% c('EFI incompl.',
                                                      'EFI compl.',
                                                      'EFII incompl.',
                                                      'EFII compl.')) %>%
  summarise(p = sum(prop))

# Save plot
dev.off()
pdf(file=paste0(wd_out_graph,"plt_propNvlEduc.pdf"),
    width = 10, height = 6)
plot(plt_propNvlEduc)
dev.off()

# Renda por nvl escolaridade ----

tab_qRenda <- data_censo_cotia %>% 
  group_by(raca,nvlEsc) %>% summarise(
    me=weighted.mean(renda,na.rm=T,weights=cem_harm_peso))

tab_qRenda <- tab_qRenda %>% mutate(.,
                                    nvlEsc = factor(nvlEsc,
                                                    levels=c('Nenhum',
                                                             'EFI incompl.',
                                                             'EFI compl.',
                                                             'EFII incompl.',
                                                             'EFII compl.',
                                                             'EM Incompl.',
                                                             'EM compl.',
                                                             'ES incompl.',
                                                             'ES compl.'),
                                                    #labels = c(1:9),
                                                    ordered = T)
)

tab_qRenda %>% drop_na(nvlEsc,raca) %>% 
  ggplot(aes(x = nvlEsc,y=me,col=raca,group=raca))+
  theme_bw()+
  geom_point(aes(shape=raca),size=1.8)+
  geom_line(lwd=.8)+
  scale_y_continuous(limits=c(0,9500),breaks = seq(0,10000,1500))+
  scale_color_manual(values=c("green","blue"))+
  labs(y="Renda média em reais (R$)",x="",
       col="",shape="")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# População branca com ES
tab_qRenda %>% filter(raca == "PPI" & nvlEsc %in% c('ES compl.')) %>%
  summarise(p = mean(me))

