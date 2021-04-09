library(readr)
library(dplyr)
library(FactoMineR)
library(factoextra)

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
combine_Covariance_Matrix <- t(combine_Matrix) %*% combine_Matrix / ( nrow(combine_Matrix) - 1 )

# Eigenvalues
combine_Eig <- eigen(combine_Covariance_Matrix)
combine_Eig$values

# PCA: Pokemon ----
dat <- read_csv("https://assets.datacamp.com/production/course_6430/datasets/Pokemon.csv",
                col_types = cols(
                  Number = col_integer(),
                  Name = col_character(),
                  Type1 = col_factor(),
                  Type2 = col_factor(),
                  Total = col_integer(),
                  HitPoints = col_integer(),
                  Attack = col_integer(),
                  Defense = col_integer(),
                  SpecialAttack = col_integer(),
                  SpecialDefense = col_integer(),
                  Speed = col_integer(),
                  Generation = col_integer(),
                  Legendary = col_factor()
                ))
# pca
dat_PCA <- dat %>% select(-Number, -Name) %>% 
  PCA(quali.sup = c(1,2,11))

# Variables
dat_PCA %>% fviz_pca_var(repel = TRUE)                         
dat_PCA$var$cos2 %>% corrplot::corrplot(method = "number") 
dat_PCA %>% fviz_contrib(choice = "var", axes = 1) # Total Overall Skills
dat_PCA %>% fviz_contrib(choice = "var", axes = 2) # Speed & Defense
dat_PCA %>% fviz_contrib(choice = "var", axes = 3) # Generation
dat_PCA %>% fviz_contrib(choice = "var", axes = 4) # Hit Points & SpecialDefense
# assessment
dat_PCA %>% dimdesc(axes = c(1,2), proba = 0.05)

# BiPlot
dat_PCA %>%
  fviz_pca_biplot(
    # Individuals
    geom = "point", alpha.ind = "cos2", col.ind = dat$Legendary, 
    pointshape = 21, fill.ind = "darkgrey", 
    col.var = "black", alpha.var = "cos2",
    addEllipses = TRUE, ellipse.type = "confidence",
  ) %>% 
  ggpubr::ggpar(title = "Principal Component Analysis",
                subtitle = "Lengendary",
                legend.title = list(alpha = "Quality of Rep"),
                palette = c("#DE1A1A","#29BF12"))

# -- MTCARS
dat <- cbind(mtcars,model = rownames(mtcars)) %>% tibble()
dat <- dat %>% mutate(
  cyl = factor(cyl),
  vs = factor(ifelse(vs == 0, "V-shaped","Straight")),
  gear = factor(gear),
  carb = factor(carb),
  automatic = factor(ifelse(am == 0,"Yes","No"))) %>% 
  select(-am)
dat <- dat %>% select(model, everything())
# PCA
dat_PCA <- dat %>% select(-cyl,-vs,-gear,-carb,-automatic) %>% 
  PCA(quanti.sup = 2, quali.sup = 1)
dat_PCA %>% fviz_screeplot(addlabels = TRUE, ylim = c(0,70))
# Variables
dat_PCA$var$cos2 %>% corrplot::corrplot(method = "number")
dat_PCA %>% fviz_pca_var(alpha.var = "cos2")
dat_PCA %>% fviz_contrib(choice = "var", axes = 1) # Power Output, Fuel Efficency (disp,hp,wt)
dat_PCA %>% fviz_contrib(choice = "var", axes = 2) # Performance-control (qsec,drat)
# Cylinder
dat_PCA %>% fviz_pca_biplot(
  geom = "point", pointshape = 21, fill.ind = "grey",
  alpha.ind = "cos2",
  col.var = "black", alpha.var = "cos2",
  col.quanti.sup = "red",
  col.ind = dat$cyl, addEllipses = TRUE, ellipse.type = "confidence",
)
dat_PCA %>% fviz_contrib(choice = "ind", axes = 1)
# Vs
dat_PCA %>% fviz_pca_biplot(
  geom = "point", pointshape = 21, fill.ind = "grey",
  alpha.ind = "cos2",
  col.var = "black", alpha.var = "cos2",
  col.quanti.sup = "red",
  col.ind = dat$vs, addEllipses = TRUE, ellipse.type = "confidence",
)
# Gear
dat_PCA %>% fviz_pca_biplot(
  geom = "point", pointshape = 21, fill.ind = "grey",
  alpha.ind = "cos2",
  col.var = "black", alpha.var = "cos2",
  col.quanti.sup = "red",
  col.ind = dat$gear, addEllipses = TRUE, ellipse.type = "confidence",
)
# Carb
dat_PCA %>% fviz_pca_biplot(
  geom = "point", pointshape = 21, fill.ind = "grey",
  alpha.ind = "cos2",
  col.var = "black", alpha.var = "cos2",
  col.quanti.sup = "red",
  col.ind = dat$carb
)
# Automatic
dat_PCA %>% fviz_pca_biplot(
  geom = "point", pointshape = 21, fill.ind = "grey",
  alpha.ind = "cos2",
  col.var = "black", alpha.var = "cos2",
  col.quanti.sup = "red",
  col.ind = dat$automatic, addEllipses = TRUE, ellipse.type = "confidence",
)
# Name
dat_PCA %>% fviz_pca_biplot(invisible = "ind",
                            alpha.var = "cos2", col.var = "black",
                            col.quanti.sup = "red",
                            habillage = dat$automatic
) %>% 
  fviz_add(dat_PCA$quali.sup$coord,
           geom = "text", color = "steelblue")

#
