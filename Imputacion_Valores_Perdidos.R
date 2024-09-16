rm(list=ls())

set.seed(123)

library(haven)
library(mice)
library(reshape2) 
library(mitml)
library(lme4)
library(lavaan)
library(semPlot)
library(psych)


datos <- read_sav("Liderazgo.sav")
View(datos)

table(is.na(datos))

#obtenemos la matriz de var-cov de los datos  brutos para chequear luego como recupera la matriz la imputación múltiple obteniendo la matriz residual

datos <- datos[,-c(14,15,3,9)] #quitamos las variables de los factores y de los ítems que no forman parte del modelo CFA

raw_m <- cov(datos)
raw_m


#Simulamos valores NA al 40% (MCAR)

datos_NA <- datos

table(is.na(datos_NA))

# Proporción de valores perdidos a introducir (puedes ajustar según tus necesidades)
proporcion_NA<- 0.4

# Obtener el número de filas y columnas en tus datos
num_filas <- nrow(datos_NA)
num_columnas <- ncol(datos_NA)

# Calcular el número total de valores a introducir como perdidos
num_NA <- round(proporcion_NA* num_filas * num_columnas)

# Generar ubicaciones aleatorias para los valores perdidos
ubicaciones_NA <- data.frame(
  fila = sample(1:num_filas, num_NA, replace = TRUE),
  columna = sample(1:num_columnas, num_NA, replace = TRUE)
)

# Introducir valores perdidos en las ubicaciones generadas
for (i in 1:num_NA) {
  datos_NA[ubicaciones_NA$fila[i], ubicaciones_NA$columna[i]] <- NA
}


table(is.na(datos_NA))


write.csv(datos_NA,"liderazgo_NA.txt")

View(datos_NA)

str(datos_NA)


#imputamos datos

imp <- mice(datos_NA, seed = 20000, meth = "pmm", m = 20)
imp$imp$p1  # Imputación del primer item en las 20 bases de datos

complete_data <- complete(imp, 1)  # Imputación de la base de datos 1, los 13 items

matrices <- list()

for (i in 1:20) {
  data <- complete(imp, action = i)
  cov_matrix <- cov(data)
  matrices[[i]] <- cov_matrix
}

head(matrices)

# Ahora promedio las matrices de covarianza
average_cov_matrix <- Reduce(`+`, matrices) / length(matrices)


################Recuperación de la matriz (matriz residual)###################

#raw_m[upper.tri(raw_m)] <- 0
#raw_m

#average_cov_matrix[upper.tri(average_cov_matrix)] <- 0
#average_cov_matrix

#m_dif <- raw_m-average_cov_matrix  #(residuos muy bajos,la imputacion recupera bien)
#m_dif
###############################################################################



# Definiendo el modelo de CFA

modelo <- '
  
  factor1 =~ p1 + p2 + p8 + p5 + p12
  factor2 =~ p4 + p7 + p10 + p11
  factor3 =~ p6 + p13
  
  factor1 ~~ factor2
  factor1 ~~ factor3
  factor2 ~~ factor3
'

# Realizando el CFA con la matriz de covarianza promediada

afc <- cfa(modelo, sample.cov = average_cov_matrix, sample.nobs = 96, std.lv = TRUE, meanstructure = TRUE, estimator = "ML")

summary(afc, standardized=TRUE, fit.measures=TRUE)
coef(afc)

semPaths(afc,"std",edge.label.cex=0.5, curvePivot = TRUE)


############## Realizamos también el CFA con los datos brutos (sin simular datos MCAR) e introduciendo como input la matriz de varianzas-covarianzas##################


raw_datos <- read_sav("Liderazgo.sav")
str(raw_datos)

#eliminamos variables innecesarias y las que no estan incluidas en el modelo

raw_datos <- raw_datos[,-c(14,15,3,9)]

head(raw_datos)

matriz <- cov(raw_datos)

matriz


#CFA 

raw_modelo <- '

  factor1=~p1+p2+p8+p5+p12
  factor2=~p4+p7+p10+p11
  factor3=~p6+p13
  
  factor1~~factor2
  factor1~~factor3
  factor2~~factor3

'


raw_afc <- cfa(raw_modelo, sample.cov = matriz, sample.nobs = 96, std.lv = TRUE, meanstructure = TRUE, estimator = "ML")

summary(raw_afc, standardized=TRUE, fit.measures=TRUE)
coef(raw_afc)

semPaths(raw_afc,"std",edge.label.cex=0.5, curvePivot = TRUE)

