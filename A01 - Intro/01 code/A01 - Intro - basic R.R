# Introdução ao R - operações básicas ------------------------------------------
# Author: Victor Gabriel Alcantara 
# Github: https://github.com/victorgalcantara 
# LinkedIn: https://www.linkedin.com/in/victorgalcantara/ 

# Recomendações: 

# Livro introdutório "R for data science"
# https://r4ds.had.co.nz/index.html

# Tutorial Leonardo Barone
# https://github.com/leobarone/cebrap_lab_programacao_r

# Parte I - Noções gerais e funções básicas ----------------------------------------------

# 1. R como calculadora ----

2+3      # soma
2*3      # multiplicação
2^2      # potência

# Respeita ordem PEMDAS
# Parenteses> Expoentes > Multiplicação > Divisão > Adição > Subtração
2+2*3

2+2*3^3

# Ordem do cálculo
3 * 3 * 3
3 * 3 * 3 * 2
3 * 3 * 3 * 2 + 2

# Divisão inteira: quanto sobra da divisão
4%%2
3%%2

# No python não tem isso!
pi-2

# 1.2 Introduzindo funções básicas ----

sqrt(x = 16) # raíz quadrada / square roots

exp(x = 1)   # exponencial - padrão: n de euler (e)

log(x = 10)  # logarítmo

log2(16)

2^4

# 2. Criando objetos ----

x <- 2
x = 3

x+3

x <- 1:16
y <- sqrt(1:16)

plot(x = x,y = y)
lines(x,y)

# PULO PARA BASE DE DADOS

## 1. Vetores ----
# Def.: coleção ordenada de dados de mesma classe/tipo
# Propriedades: nome, tipo/classe, elementos, dimensão

# 0. Unidade básica no R
# 1. Apenas uma dimensão
# 2. Só aceita uma classe (núm, char, logi)
# 3. Default: string sobrepõe

j <- c(1.20,3.2,2.2,3.4)
x <- c(2L,4L,4L,6L)
y <- c("Fulano","Ciclano","Beltrano","Tetrano")
z <- c(TRUE,FALSE,TRUE,FALSE)

class(j)
class(x)
class(y)
class(z)

t <- c(1,2,"Fulano",FALSE)
class(t)

w <- c(j,x,y,z)
w # observe o que compõe o vetor "w"
class(w)

w <- as.numeric(w) # o que aconteceria se tudo fosse transformado para número?
w

# Factor: isso também não tem no py! ;)
a <- c("Bom","Ruim","Regular","Péssimo")

a <- factor(a,levels=c("Péssimo","Ruim","Regular","Bom"), ordered=T)

a
levels(a)

# Agora podemos fazer algumas operações com factor
min(a)
max(a)

## 2. Data frame ----
# Def.: coleção de vetores de mesma dimensão que guardam infos
# Propriedades: dim e str
# 0. Dados estruturados em observações x variáveis (survey)

idad  <- c(65,74,21,24,27,34,24,23)
educ  <- c(2,2,12,14,12,16,14,14)
rend  <- c(1200,1600,1800,2200,1800,6400,2300,2500)
sexo  <- c("M","F","F","M","F","M","F","M")
raca  <- c("Branca","Parda","Preta","Parda","Preta","Branca",
           "Parda","Amarela")

d <- data.frame(educ = educ, idad = idad, rend = rend,
                sexo = sexo, raca = raca)

# 3. Verbos importantes ----
# Visualizar dados - fluxo de trabalho

class(d)  # classe do objeto
dim(d)    # dimensão da base (linhas x colunas)
head(d)   # Primeiros 5 casos
tail(d)   # Últimos 5 casos
str(d)    # Estrutura dos dados

summary(d)      # sumário das variáveis
summary(d$rend) # sumário de uma variável numérica
summary(d$sexo) # sumário de uma variável categórica

### 4. Subset ----

# acessar informações guardadas em um vetor
y[1]

# acessar informações guardadas em um data.frame 
# [linhas,colunas]
d[1,1]

# operações com coordenadas
d[,"nome"] <- y # criando nova variável
df <- d[,-6]    # excluindo variável

# Filtrando dados
filtro <- c(F,T,T,T,T,T,T,T)
df <- d[filtro,]

# Selecionando variáveis
selecao <- c(T,T,T,T,T,F)
df <- d[,selecao]

# Complexificando
filtro <- d[,"idad"] < 29
df <- d[filtro,]

selecao <- names(d) %in% c("educ","rend")
df <- d[,selecao]

# Função base para subset
subset(x = d, subset = sexo == "F")
subset(x = d, select = "sexo")

### 5. Recodificação ----

# Renda
d[,"ln_rend"] <- log(d[,"rend"])

# Raca
d[,"vd_raca"] <- d$raca

negra   <- d[,"raca"] %in% c("Preta","Parda")

d[negra,"vd_raca"] <- "Negra"

# Complexificando mais um pouco
# Raca e sexo
m_negra   <- d[,"raca"] %in% c("Preta","Parda") &
  d[,"sexo"] == "F"

m_branca   <- d[,"raca"] %in% c("Branca") &
  d[,"sexo"] == "M"

d[m_negra,"vd_raca_sexo"] <- "Mulher negra"
d[m_branca,"vd_raca_sexo"] <- "Mulher branca"

h_negro   <- d[,"raca"] %in% c("Preta","Parda") & d[,"sexo"] == "M"

h_branco   <- d[,"raca"] %in% c("Branca") & d[,"sexo"] == "M"

h_amarelo   <- d[,"raca"] %in% c("Amarela") & d[,"sexo"] == "M"

d[h_negro,"vd_raca_sexo"] <- "Homem negro"
d[h_branco,"vd_raca_sexo"] <- "Homem branco"
d[h_amarelo,"vd_raca_sexo"] <- "Homem amarelo"

# vocês entenderam...

# 3. Operações lógicas ----
# São operações em testamos uma sentença tendo como resultado:
# TRUE (T) ou FALSE (F)

2 >  2  # MAIOR QUE
2 < 2   # MENOR QUE
2 == 3  # IGUALDADE

2 >= 2 # MAIOR OU IGUAL

# Por quê igualdade são dois sinais?
# R: Porque apenas um significa atribuição de valor. Igual a setinha.

x = 1:10
x <- 1:10

"eu" == "todo mundo" # Igualdade
"eu" == "eu"
"eu" != "vc"         # Diferença

# Teste em grupo
"eu" %in% c("vc","todo mundo") # Generalização - se contém

# Nota importante: "!" opera como um sinal de negação/diferença

!("eu" %in% c("vc","todo mundo"))

# 4. Relações "OU" e "E" ----
# "|" para "OU"
2 > 2 | 2 == 2
2 > 2 | 2 < 2

# "&" para "E"
2 > 2 & 2 == 2
2 > 1 & 2 == 2

# 5. Condições ----
# se verificado isso, aplique aquilo
# else: ou, se não verificado, aplique aquilo outro

if(2 > 3){"Não sei lógica"}else{"Sei lógica!"} # Teste executar apenas 
                                               # a primeira parte
TRUE+TRUE+FALSE

true_igual_um <- c(T,T,T,F)
true_igual_um + 1

# 6. Loops ----
# Loops são operações de iteração fundamentais na automação
# Trabalho com processos repetitivos

a=1
while (a<=10)  {
  a=a+1
  print (a)
}

a=1
repeat {
  print (a)
  a=a+1
  if (a >= 10) break()
}

for(i in 1:10){
  print(i)
  }

# 7. Funções ----
# são operações já programadas
# (input-processo-output)
# nome_da_função(argumentos)

# Exemplo de funções
# argumentos = input

ifelse(test = 2>3,yes = "Que isso?",no ="Ah, tá.")
ifelse # Veja como essa função está programada

sum(true_igual_um)

# 8. Pacotes ----
# são conj. de funções
# devem ser instalados    : install.packages()
# deve carregar na memória: library()
install.packages("tidyverse") # Principal biblioteca de funções para manuseio
library(tidyverse) # Pegando na biblioteca
require(dplyr)     # Nem sempre é necessário

# 9. Navegação no computador ----
# wd : Working Directory = Diretório/pasta de trabalho

getwd() # Em qual diretório/pasta estou trabalhando?
dir()   # o que tem nesse diretório/pasta?

setwd() # Mude o diretório de trabalho
dir.create("minha pasta") # Crie uma pasta com este nome

# Parte II - Classes de objetos ------------------------------------------------

# Funções que facilitam a nossa vida: pacote TIDYVERSE

# 6. Usando tidyverse ----

## 6.1 Select e Filter ----
# selecionar variáveis e filtrar casos

# Jovens
d <- d %>% filter(idad > 15  & idad < 29)

d <- d %>% select(educ,rend,sexo_raca)

## 6.1 Verbo "mutate" ----

d <- mutate(d, "lnRenda"=log(rend))

d <- mutate(d, "vd_raca"= case_when(
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
