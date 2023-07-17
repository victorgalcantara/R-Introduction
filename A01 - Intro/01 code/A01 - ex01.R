# Exercício 01
# Escreva um cabeçalho para o seu código. Lembre-se, é importante identificar
# o título (do que se trata) e sua autoria (quem produziu)

# Passo 1
# Crie um objeto "country" do tipo character com 10 nomes de países

# Passo 2
# Crie um objeto "nota" do tipo numérico com nota de 0-10 para cada país
# Considere a nota como sua vontade de viajar para o país

# Passo 3
# Considere 8 como nota de corte para sua vontade de viajar. 
# Atribua falso para os países em que a nota é menor ou igual a 8, e verdadeiro
# para o contrário

# Passo 4
# Crie um data.frame com os dados e salve em um objeto

# Print o dado no console

# Passo 5
# Utilize a função "paste" para unir as duas informações uma frase
# e fazer o print das frases com a seguinte estrutura:
# "A nota para <<country>> é <<nota>>."

# Passo 6
# Veja os primeiros cinco casos

# Passo 7
# Veja apenas os casos em que vc viajaria, considerando a nota de corte

# Passo 8
# Faça um sumário descritivo das notas de todos os países




# ---------------- EXEMPLO COM RESPOSTAS ABAIXO ---------------- 




# Exercício 01 resolvido
# Autor: Victor G Alcantara

# Passo 1
# Crie um objeto "country" do tipo character com 10 nomes de países
country <- c("França","Peru","Egito","China","Austrália",
             "Argentina","Portugal","Alemanha","EUA","Itália")

# Passo 2
# Crie um objeto "nota" do tipo numérico com nota de 0-10 para cada país
# Considere a nota como sua vontade de viajar para o país
note <- c(10,8,9,6,5,6,7,6,8,9)

# Passo 3
# Considere 8 como nota de corte para sua vontade de viajar. 
# Atribua falso para os países em que a nota é menor ou igual a 8, e verdadeiro
# para o contrário
travel <- note > 8

# Passo 4
# Crie um data.frame com os dados e salve em um objeto
mydata <-data.frame(country,note,travel)

# Print o dado no console

# Passo 5
# Utilize a função "paste" para unir as duas informações uma frase
# e fazer o print das frases com a seguinte estrutura:
# "A nota para <<country>> é <<nota>>."
paste("A nota para",country,"é",note)

# Veja os primeiros cinco casos
head(mydata)

# Veja apenas os casos em que vc viajaria, considerando a nota de corte
mydata[note>8,]

# Faça um sumário descritivo das notas de todos os países
summary(mydata$note)