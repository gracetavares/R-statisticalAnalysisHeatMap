# Instalar os pacotes necessários
if (!requireNamespace("geobr", quietly = TRUE)) {
  install.packages("geobr")
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
if (!requireNamespace("sf", quietly = TRUE)) {
  install.packages("sf")
}
if (!requireNamespace("cowplot", quietly = TRUE)) {
  install.packages("cowplot")
}
if (!requireNamespace("tidyr", quietly = TRUE)) {
  install.packages("tidyr")
}
if (!requireNamespace("viridis", quietly = TRUE)) {
  install.packages("viridis")
}


# Carregar os pacotes
library(ggplot2)
library(sf)
library(dplyr)
library(geobr)
library(cowplot)
library(tidyr)
library(viridis)
library(here)
library(tidyverse)
# Carregar os dados
dados1 <- read.csv(here ("vendas_químicos_bioquimicos_2009-2022.csv"), 
                   sep = ";", header = TRUE, dec = ",", 
                   col.names = c("abbrev_state", "Ano_2022", "Ano_2021", "Ano_2020", "Ano_2019", "Ano_2018", 
                                 "Ano_2017", "Ano_2016", "Ano_2015", "Ano_2014", "Ano_2013", "Ano_2012",
                                 "Ano_2011", "Ano_2010", "Ano_2009"), check.names = FALSE)



# Ajustar os nomes dos estados para combinar com os dados de frequência
#dados1$abbrev_state = toupper(dados1$abrrev_state)

dados_long <- dados1 %>%
  pivot_longer(cols = -abbrev_state, names_to = "Ano", values_to = "Valor")

dados_long$log_Valor = log(dados_long$Valor)

# Carregar os dados geográficos dos estados brasileiros usando geobr (ano 2019)
brasil <- read_state(code_state = "all", 
                     year = 2019)

#join dos dados
dados_completos = full_join(brasil, 
                            dados_long, 
                            by = "abbrev_state")

# TODO: Plotar os gráficos de pizza no mapa do Brasil
 mapa = ggplot() +
  geom_sf(data = dados_completos, 
          color = "black", 
          aes(fill = log_Valor)) +
  facet_wrap(~Ano, ncol = 6) +  #montagem do painel de mapas
   # scale_fill_viridis_c(option = "B") +
   scale_fill_gradient(low = "green", 
                       high = "red", 
                       na.value = "white",
                       space = "Lab") +
   labs(title = "Vendas de agroquimicos") +
   theme_minimal()

  plot(mapa)
  
  
ggsave("mapa_vendas_agroquimicos3.png", plot = mapa, width = 10, height = 8, units = "in", dpi = 300)

