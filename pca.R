library(readr)
library(dplyr)
library(tibble)
library(FactoMineR)
library(factoextra)

# PCA: State ----

# EDA

# Matrix
state_CovMatrix <- cov(scale(state.x77))

# Eigenvalues
state_Eig <- eigen(state_CovMatrix)
state_Eig$values
state_Eig$vectors

# PCA
state_PCA <- princomp(state.x77, cor = TRUE, scores = TRUE)
state_PCA %>% summary()
state_PCA %>% plot()


#
# PCA: Decathon ----

# DECATHOLON

# Data
decathlon <- decathlon2 %>% 
  rownames_to_column(var = "name") %>% as_tibble()
decathlon_scores <- decathlon %>% 
  select(X100m:X1500m)

# EDA
decathlon_scores %>% cor() %>% 
  corrplot::corrplot(method = "number", type = "upper")
  
# Matrix
decathlon_Matrix <- decathlon_scores %>% scale() %>% as.matrix()
decathlon_CovMatrix <- decathlon_Matrix %>% cov()

# Eigen
decathlon_Eig <- decathlon_CovMatrix %>% eigen()
decathlon_Eig$values
decathlon_Eig$vectors

# PCA
decathlon_PCA <- decathlon_scores %>% 
  prcomp(center = TRUE, scale. = TRUE)
decathlon_PCA$sdev^2
decathlon_PCA$rotation

# FactoM
decathlon_FactoM <- decathlon %>%
  select(X100m:X1500m) %>% 
  PCA(scale.unit = TRUE, graph = FALSE)
# - eigens
decathlon_FactoM$svd$vs^2
decathlon_FactoM$svd$V
decathlon_FactoM %>% get_eig()
decathlon_FactoM %>% fviz_eig(addlabels = TRUE)

# Plot
decathlon_FactoM %>% 
  fviz_pca_biplot(repel = TRUE,
                  col.var = "black", alpha.var = "cos2")
# - variables
decathlon_FactoM$var$coord[,c(1,2)]
decathlon_FactoM$var$cos2[,c(1,2)] # Quality of Representation
decathlon_FactoM$var$contrib[,c(1,2)]

# - individuals:
decathlon_FactoM$ind$coord[,c(1,2)]
decathlon_FactoM$ind$cos2[,c(1,2)] # Quality of Representation
decathlon_FactoM$ind$contrib[,c(1,2)]

# PCA-Competition
decathlon_FactoM %>% fviz_pca_biplot(repel = TRUE,
                                     col.var = "black", alpha.var = "cos2",
                                     col.ind = decathlon$Competition, addEllipses = TRUE, ellipse.type = "confidence")

#
# PCA: NFL Combine ----

# Data
nfl <- read_csv("Data/DataCampCombine.csv")
combine <- nfl %>% 
  select(height:shuttle)

# Matrix
combine_Matrix <- scale(as.matrix(combine))
combine_Covariance_Matrix <- cov(combine_Matrix)

# Eigenvalues
combine_Eig <- eigen(combine_Covariance_Matrix)
combine_Eig$values
combine_Eig$vectors

# PCA
combine_Scaled <- combine %>% scale()
combine_Scaled %>% prcomp()
# FactoMiner
combine_PCA <- combine %>% 
  PCA(scale.unit = TRUE, graph = FALSE)
# - eigenvalues
combine_PCA$eig
# - eigenvectors V
combine_PCA$var$
#
# PCA: Pokemon ----

# Data
pokemon <- read_csv("Data/Pokemon.csv")
pokemon <- pokemon %>% 
  mutate(Type1 = Type1 %>% factor,
         Type2 = Type2 %>% factor,
         Generation = Generation %>% factor())
pokemon_stats <- pokemon %>% 
  select(HitPoints:Speed)

# EDA
pokemon_stats %>% cor() %>% 
  corrplot::corrplot(method = "number", type = "upper")

# Matrix
pokemon_Cov <- pokemon_stats %>% scale() %>% cov()

# Eigen
pokemon_Eig <- pokemon_Cov %>% eigen()
pokemon_Eig$values
pokemon_Eig$vectors

# PCA
pokemon_PCA_Base <- pokemon_stats %>% prcomp(scale = TRUE)
# - eigenvalues
pokemon_PCA_Base$sdev^2
pokemon_PCA_Base$rotation

# FactoM
pokemon_PCA <- pokemon %>%
  select(HitPoints:Speed) %>% 
  PCA(scale.unit = TRUE, graph = FALSE)
pokemon_PCA$svd$vs^2
pokemon_PCA$svd$V
pokemon_PCA %>% get_eig()
pokemon_PCA %>% fviz_eig(addlabels = TRUE)

pokemon_PCA %>% 
  fviz_pca_biplot(repel = TRUE,
                  col.var = "black", 
                  alpha.ind = "cos2")
# - variables
pokemon_PCA$var$coord[,c(1,2)]
pokemon_PCA$var$cos2[,c(1,2)] # Quality of Representation
pokemon_PCA$var$contrib[,c(1,2)]

# PCA-Legendary
pokemon_PCA %>% fviz_pca_biplot(repel = TRUE,
                                col.var = "black", alpha.ind = "cos2",
                                col.ind = pokemon$Legendary, addEllipses = TRUE, ellipse.type = "confidence",
                                legend.title = "Legendary")

# PCA-Type 1
pokemon_PCA %>% fviz_pca_biplot(repel = TRUE,
                                col.var = "black", alpha.ind = "cos2",
                                col.ind = pokemon$Type1, addEllipses = TRUE, ellipse.type = "confidence",
                                legend.title = "Type 1")

# PCA-Type 2 
pokemon_PCA %>% fviz_pca_biplot(repel = TRUE,
                                col.var = "black", alpha.ind = "cos2",
                                col.ind = pokemon$Type2, addEllipses = TRUE, ellipse.type = "confidence",
                                legend.title = "Type 2")

# PCA-Generation
pokemon_PCA %>% fviz_pca_biplot(repel = TRUE,
                                col.var = "black", alpha.ind = "cos2",
                                col.ind = pokemon$Generation, addEllipses = TRUE, ellipse.type = "confidence",
                                legend.title = "Generation")

