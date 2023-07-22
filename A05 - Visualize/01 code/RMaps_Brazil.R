# install.packages("pacman")
library(pacman)
p_load(geobr,ggplot2,sf,dplyr)

# Available data sets
datasets <- list_geobr()
datasets

# We have to remove axis from the ggplot layers
no_axis <- theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank())


# Depict all the Brazilian States + Federal District, 2019
states <- read_state(year=2020)

ggplot() +
  geom_sf(data=states, fill="#FFDB6D", color="#293352", size=.5, show.legend = FALSE) +
  labs(subtitle="States of Brazil and Federal District, 2020", size=8) +
  theme_minimal() +
  no_axis

# Depict all the Brazilian States + Federal District, 1920
states <- read_state(year=1872)
ggplot() +
  geom_sf(data=states, fill="#FFDB6D", color="#293352", size=.5, show.legend = FALSE) +
  labs(subtitle="States of Brazil and Federal District, 1920", size=8) +
  theme_minimal() +
  no_axis

#Intermediate units
meso <- read_intermediate_region(year=2019)
ggplot() +
  geom_sf(data=meso, fill="#FFDB6D", color="#293352", size=.15, show.legend = FALSE) +
  labs(subtitle="Intermediate Stats units of Brazil, 2019", size=8) +
  theme_minimal() +
  no_axis

# All municipalities in Brazil
muni <- read_municipality(year=2020)
ggplot() +
  geom_sf(data=muni, fill="#FFDB6D", color="#293352", size=.15, show.legend = FALSE) +
  labs(subtitle="Municipalities of Brazil, 2019", size=8) +
  theme_minimal() +
  no_axis

# All municipalities in the state of MG
muniMG <- read_municipality(code_muni= "MG", year=2020)
ggplot() +
  geom_sf(data=muniMG, fill="#FFDB6D", color="#293352", size=.15, show.legend = FALSE) +
  labs(subtitle="Municipalities of Minas Gerais, 2020", size=8) +
  theme_minimal() +
  no_axis

# Municipality of MG city
muniRJC <- read_municipality(code_muni = 3304557, year=2019)
ggplot() +
  geom_sf(data=muniRJC, fill="#FFDB6D", color="#293352", size=.15, show.legend = FALSE) +
  labs(subtitle="Municipality of Rio de Janeiro, 2019", size=8) +
  theme_minimal() +
  no_axis

#####################################################################################
# Thematic maps
# Read data.frame with Population density
# Import data on the variable you want to depict
# Excel file RMaps_Brazil

RMaps_Brazil <- import(file.choose())

# Compute density
data <- mutate(RMaps_Brazil, Popdens=Pop/AreaKm2)

states <- read_state(year=2019) 
states$name_state <- tolower(states$name_state)
data$State          <- tolower(data$State)

# join the databases
states <- dplyr::left_join(states, data, by = c("name_state" = "State"))

ggplot() +
  geom_sf(data=states, aes(fill=Popdens), color= NA, size=.15) + #try color = "Grey"
  labs(subtitle="Population Density (hab/Km2), Brazilian States, 2019", size=8) +
  scale_fill_distiller(palette = "Reds", direction = 1, #default = -1
                       name="Population Density \n(hab/Km2), 2019", limits = c(0,600)) +
  theme_minimal() +
  no_axis +
  coord_sf(xlim = c(-75, -32), ylim = c(-34.5, 7),expand=FALSE)
