# Introdução ao R

# Operações básicas ----
# "+" \ "-" \ "*" \ "/" \ "%%"
2+3
2*3

# Respeita ordem PEMDAS
# Parenteses> Expoentes > Multiplicação > Divisão > Adição > Subtração
2+2*3
2+2*3/3

# Divisão inteira: quanto sobra da divisão
4%%2
3%%2

# No python não tem isso!
pi-2

# Operações lógicas ----
2 > 2  # Maior que
2 >= 2 # Maior ou igual

"eu" == "todo mundo" # Igualdade
"eu" == "eu" 
"eu" != "vc" # Diferença

"eu" %in% c("vc","todo mundo") # Generalização - se contém

# "|" para "OU"
2 > 2 | 2 == 2
2 > 2 | 2 < 2

# "&" para "E"
2 > 2 & 2 == 2
2 > 1 & 2 == 2

# Condicional: se verificado isso, aplique aquilo
# else: ou, se não verificado, aplique aquilo outro

if(2 > 3){"Não sei lógica"}else{"Sei lógica!"}

T+T+F

true_igual_um <- c(T,T,T,F)
true_igual_um + 1

# Funções: são operações já programadas
# nome_da_função(parâmetros)

ifelse(2>3,"Que isso?","Ah, tá.")

sum(true_igual_um)

# Pacotes: são conjuntos de funções

# Vetores ----
# Def.: coleção ordenada de dados de mesma classe/tipo
# Propriedades: nome, tipo/classe, elementos, dimensão
# 0. Unidade básica no R
# 1. Apenas uma dimensão
# 2. Só aceita uma classe (núm, char, logi)
# 3. Default: string sobrepõe

x <- c(2,4,4,6,12,16,2,4)
y <- c("Fulano","Ciclano","Beltrano","Fulano Jr")
z <- c(T,F,T,F)

w <- c(x,y,z)
class(w)

# Data frame ----
# Def.: coleção de vetores de mesma dimensão que guardam infos
# Propriedades: dim e str
# 0. Dados estruturados em observações x variáveis (survey)

educ  <- c(2,2,12,14,12,16,14,14)
idad  <- c(65,74,21,24,27,34,24,23)
rend  <- c(1200,1600,1800,2200,1800,6400,2300,2500)
sexo  <- c("M","F","F","M","F","M","F","M")
raca  <- c("Branca","Parda","Preta","Parda","Preta","Branca",
           "Parda","Amarela")

d <- data.frame(educ = educ, idad = idad, rend = rend,
                sexo = sexo, raca = raca)

# Verbos importantes ----
# Visualizar dados - fluxo de trabalho

class(d)  # classe do objeto
dim(d)    # dimensão da base (linhas x colunas)
head(d)   # Primeiros 5 casos
str(d)    # Estrutura dos dados

summary(d) # sumário das variáveis
summary(d$rend) # sumário de uma variável
summary(d$sexo) # sumário de uma variável

# Recodificação com R base ----

# Renda
d[,"ln_rend"] <- log(d[,"rend"])

# Raca
negra   <- d[,"raca"] %in% c("Preta","Parda")
branca  <- d[,"raca"] == "Branca"
indigena<- d[,"raca"] == "Indígena"
amarela <- d[,"raca"] == "Amarela"

d[negros,"vd_raca"]    <- "negra"
d[brancos,"vd_raca"]   <- "branca"
d[indigenas,"vd_raca"] <- "indígena"
d[amarelos,"vd_raca"]  <- "amarela"

# Raca e sexo
m_negra   <- d[,"raca"] %in% c("Preta","Parda") &
             d[,"sexo"] == "F"

h_negro   <- d[,"raca"] %in% c("Preta","Parda") &
  d[,"sexo"] == "M"

# vocês entenderam...

# Funções que facilitam a nossa vida: pacote TIDYVERSE
install.package("tidyverse")
library(tidyverse)

# Mutate: modificar variáveis
d <- mutate(d, "lnRenda"=log(rend))

d <- mutate(d, "vd_raca"=case_when(
  raca == "Preta" ~ "Negra",
  raca == "Parda" ~ "Negra",
  raca == "Branca" ~ "Branca",
  raca == "Indígena" ~ "Indígena",
  raca == "Amarela" ~ "Amarela",
))

d <- mutate(d, "sexo_raca" = case_when(
  sexo == "F" & raca == "Branca"   ~ "Mulher Branca",
  sexo == "F" & raca == "Preta"    ~ "Mulher Preta",
  sexo == "F" & raca == "Parda"    ~ "Mulher Parda",
  sexo == "F" & raca == "Indígena" ~ "Mulher Indígena",
  sexo == "F" & raca == "Amarela" ~ "Mulher Amarela",
  
  sexo == "M" & raca == "Branca"   ~ "Homem Branco",
  sexo == "M" & raca == "Preta"    ~ "Homem Preto",
  sexo == "M" & raca == "Parda"    ~ "Homem Pardo",
  sexo == "M" & raca == "Indígena" ~ "Homem Indígena",
  sexo == "M" & raca == "Amarela" ~ "Mulher Amarelo",
))

# Select and Filter: selecionar variáveis e filtrar casos
# Jovens
d <- d %>% filter(idad < 29 & idad > 15)

d <- d %>% select(educ,rend,sexo_raca)