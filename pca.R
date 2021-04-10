library(readr)
library(dplyr)
library(FactoMineR)
library(factoextra)

# PCA: State ----

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
decathlon2
decathlon2 %>% skimr::skim()

# EDA: pca
dec_PCA <- PCA(decathlon2, graph = FALSE,
               ind.sup = 24:27,
               quanti.sup = 11:12,
               quali.sup = 13)
# - Eigenvalues
fviz_eig(dec_PCA, addlabels = TRUE, ylim = c(0,50))
# - extract results for variables
pca_var <- dec_PCA %>% get_pca_var()
# - visual
dec_PCA$var$cos2 %>%  ggcorrplot::ggcorrplot(lab = TRUE)
pca_ind <- dec_PCA %>% get_pca_ind()


# Variables
fviz_pca_var(dec_PCA,
             # Features
             col.var = "black",
             # Target
             col.quanti.sup = "red")
fviz_contrib(dec_PCA, choice = "var", axes = 1:2, top = 10)

# Observations
fviz_pca_ind(dec_PCA, repel = TRUE,
             # Test
             col.ind.sup = "blue",
             # Group
             habillage = 13, palette = "jco",
             addEllipses = TRUE, ellipse.type = "confidence"
) %>% 
  # Target
  fviz_add(dec_PCA$quali.sup$coord, color = "red")

fviz_contrib(mod_pca, choice = "ind", axes = 1:2, top = 20)


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
pokemon_stats <- pokemon %>% 
  select(HitPoints:Speed)

# Matrix
pokemon_Cov <- pokemon_stats %>% scale() %>% cov()

# Eigen
pokemon_Eig <- pokemon_Cov %>% eigen()
pokemon_Eig$values
pokemon_Eig$vectors

# PCA
pokemon_PCA <- pokemon_stats %>% prcomp(scale = TRUE)
pokemon_PCA
