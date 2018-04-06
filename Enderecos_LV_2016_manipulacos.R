### pacotes necessarios ###

library(dplyr)
library(readxl)
library(stringr)
library(tidyverse)
library(geosphere)

### definindo working directory ###

dir_d <- c("D:/Dropbox/Documentos/Comparacao GeoLV CEM/Teste RM")
setwd(dir_d)

### importando variavaies de RM ###

rms <- read_excel("Lista_municipios_RMs_zoneamento.xlsx")


### importando aux mun ###

aux_mun <- read.csv("aux_mun_code5570.csv", sep=";", header=TRUE)

cod_mun <- aux_mun %>%
  select(Cod_TSE_5, Cod_IBGE)

### merging ###

rms <- merge(rms, cod_mun, by.x="cod_mun_b", by.y="Cod_IBGE")

### Definindo municipios da Regiao Metropolitana de Curitiba ###

rm_Curitiba <- rms %>%
  filter(RM=="CURITIBA")

### Criando vetor de nomes dos municipios ###

mun_selecionados <- rm_Curitiba$Cod_TSE_5

### importando enderecos ###

end <- read.csv("Locais de votação 2016_2.csv", sep=";", header=TRUE)

### criando id unico ###

end <- end %>% mutate( idLV = paste0(CD_LOCALIDADE_TSE, NR_ZONA, NR_LOCVOT))


### criando base de enderecos de locais de votacao ##

base_lV <- end %>%
  select(-NR_SECAO)%>%
  group_by(idLV, SG_UF,CD_LOCALIDADE_TSE, NM_LOCALIDADE,NR_ZONA, NR_LOCVOT,NM_LOCVOT, DS_ENDERECO, DS_BAIRRO, NR_CEP)%>%
  summarise(n_locs = n())

### verificando se observacao eh unica ###

ver_un <- base_lV %>% 
  mutate( dupl = duplicated(idLV)) %>% 
  filter(dupl=="TRUE") ### PASSOU NO TESTE

### selecionando enderecos corretos ###

end_selecionados <- base_lV %>%
  filter (CD_LOCALIDADE_TSE %in% mun_selecionados)

###  salvando csv ###
write.csv(end_selecionados, "end_rm_curitiva.csv",  fileEncoding = "UTF-8")