# Estudio de la Recuperación de un Análisis Factorial Confirmatorio sobre una matriz de varianzas y covarianzas cuyos datos presentaban valores perdidos

Este estudio evalúa la efectividad de la imputación múltiple en el análisis factorial confirmatorio (AFC) al manejar valores perdidos en un conjunto de datos sobre liderazgo. Se simularon valores perdidos completamente al azar (MCAR) en un 40% de los datos de 96 sujetos y se aplicó la imputación múltiple usando el método de "predictive mean matching". Se calcularon matrices de varianzas y covarianzas a partir de 20 bases de datos imputadas, y se compararon los parámetros estimados y los índices de ajuste del modelo AFC resultante con aquellos obtenidos a partir de datos originales sin valores perdidos. La hipótesis plantea que los resultados del modelo imputado serán similares a los del modelo sin imputar, sugiriendo que la imputación múltiple es una estrategia viable para el AFC.

Este repositorio contiene:
- El modelo de Liderazgo de Frutos (1998). (Archivo: "Liderazgo_Frutos.pdf")
- La base de datos de Liderazgo. (Archivo: "Liderazgo.sav")
- El script de R (Archivo: "Imputacion_Valores_Perdidos.R")
- El script de RMarkdown (Archivo:"Imputacion_Valores_Perdidos.Rmd")
- El pdf con el estudio final (Archivo: "Imputacion_Valores_Perdidos.pdf")
