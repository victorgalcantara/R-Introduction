# A02 - Data frames - 18/07/2023
# Autor: Victor G Alcantara

educ = c( 12, 9, 12, 9,17 )
rend = c( 2500, 900,2000,1200,6800)
raca = c( "branca", "indígena", "parda", "preta","branca")

meus_dados <- data.frame(educ, rend, raca)

meus_dados[,]

meus_dados$educ

meus_dados$raca == "branca"

# Subset

subset(x = meus_dados,subset = raca == "branca") # Filtro

subset(x = meus_dados,select = raca) # Seleção

# Trabalhando com pacote tidyverse
myFunction = function( x ) { x*2 }

myFunction(x = 2)

