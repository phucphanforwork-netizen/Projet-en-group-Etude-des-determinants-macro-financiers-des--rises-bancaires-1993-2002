
required <- c("dplyr","tidyverse","FactoMineR",
              "factoextra","corrplot","strucchange",
              "ggplot2","reshape2", "dplyr", "tidyverse", 
              "performance", "marginaleffects", "clubSandwich", 
              "pROC", "plm", "lme4", "lmtest", "car")

for(pkg in required){
  if(!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)
  library(pkg, character.only = TRUE)
}

#============================================================================
#     Partie 1: Télécharger des données et prendre la pondération
#============================================================================

# Import file ews
setwd("C:/Users/HOANG PHUC/Downloads/Candidate 2025/Étude des déterminants macro-financiers des crises bancaires sur la période 1993 – 2002")
database <- read.csv("ews.csv")

# Voire 6 premieres lignes
head(database)

# Vérifier la structure de database
str(database)

#Nettoyage de données
colSums(is.na(database))
database_clean <- database %>%  mutate(across(where(is.numeric), ~ ifelse(is.na(.), mean(., na.rm = TRUE), .)))

summary(database)

#Standardisation (z-score)
vars <- c("ROAA","NPLGROSSLOANS","PER","CREDITGDP","GDPG","GFCFG",
          "GFCFGDP","HFCEG","HFCEGDP","CAGDP","INFL","REALRATE","DEPRATE")
database_z <- database_clean %>% mutate(across(all_of(vars), scale))

#Pondération
weights <- c(ROAA = 0.8, NPLGROSSLOANS = 1, CREDITGDP = 1,
             GDPG = 0.8, INFL = 0.8, CAGDP = 0.6,
             GFCFG = 0.6, GFCFGDP = 0.6, HFCEG = 0.6, HFCEGDP = 0.6,
             PER = 0.1, REALRATE = 0.8, DEPRATE = 0.8)
database_w <- database_z %>% mutate(across(all_of(names(weights)), ~ . * weights[cur_column()]))

#============================================================================
#     Partie 2: ANALYSE EN COMPOSANTES PRINCIPALES 
#============================================================================
#     Partie 2.1: Analyse de la matrice de corrélation 
#============================================================================
corr <- cor(database_w[,vars], use = "complete.obs")
corrplot(corr,
         method = "color",  
         col = colorRampPalette(c("lightblue", "white", "pink"))(200),
         tl.col = "black",
         tl.cex = 1,
         tl.font = 1,           
         type = "upper",
         diag = FALSE
)

#============================================================================
#     Partie 2.2: Analyse en composantes sans pondération
#============================================================================
res.pca.simple <- PCA(database_z[, vars],  scale.unit = FALSE, graph = FALSE)
plot(res.pca.simple, choix = "var")
res.pca.simple$var$coord

#============================================================================
#     Partie 2.3: Analyse en composantes avec pondération
#============================================================================
res.pca.w <- PCA(database_w[, vars],  scale.unit = FALSE, graph = FALSE)
plot(res.pca.w, choix = "var")
res.pca.w$var$coord

#Scree plot individuel
plot(res.pca.w, choix = "ind")
# Visualisation avec un barplot des pourcentage de Variance expliquée
eig <- res.pca.w$eig[, "percentage of variance"]
barplot <- barplot(eig,
                   main = "Pourcentage de Variance expliquée",
                   names.arg = 1:nrow(res.pca.w$eig),
                   col = "lightblue",
                   border = NA,
                   xlab = "Composante Principale",
                   ylab = "% de variance expliquée",
                   ylim = c(0, max(eig) * 1.1))
lines(barplot, eig, type = "o", pch = 19, col = "darkblue", lwd = 2)
text(x = barplot,
     y = eig+ max(eig)*0.05,
     labels = round(eig, 1),
     cex = 0.9, font = 2)
#Visualisation avec un barplot des pourcentage de Variance expliquée cumul
cum_eig <- cumsum(eig)
barplot(cum_eig,
        main = "Variance Cumulée Expliquée",
        names.arg = 1:length(cum_eig),
        col = "lightblue",
        xlab = "Composante Principale",
        ylab = "% de variance cumulée",
        ylim = c(0, max(cum_eig) * 1.15)
)
text(x = barplot,
     y = cum_eig+ max(cum_eig)*0.03,
     labels = round(cum_eig, 1),
     cex = 0.9, font = 2)


#============================================================================
#     Partie 3: CLUSTERING HIÉRACHIQUE (HCPC/KMEANS)
#============================================================================
#Clustering (k-means)
pc_scores <- res.pca.w$ind$coord[, 1:3]
#k-means
set.seed(123)
km <- kmeans(pc_scores, centers = 3)
database_clean$cluster <- km$cluster

#Profil des clusters
aggregate(database_clean[, vars],
          by = list(database_clean$cluster),
          FUN = mean)
HACP = HCPC(res.pca.w, nb.clust = 3)


#============================================================================
#     Partie 4: ANALYSE EN COMPOSANTES PRINCIPALES PRE/POST-CRISE
#============================================================================
#    Partie 4.1: Analyse en Composantes Principales post-crise
#============================================================================
post <- database_w %>% filter(PCRISIS1 == 1)
pca_post <- PCA(post[, vars], graph = FALSE)
plot(pca_post, choix = "var")
pca_post$var$coord


pca_post_eig <- pca_post$eig[, "percentage of variance"]
barplot <- barplot(pca_post_eig,
                   main = "Pourcentage de Variance expliquée",
                   names.arg = 1:nrow(pca_post$eig),
                   col = "lightblue",
                   border = NA,
                   xlab = "Composante Principale",
                   ylab = "% de variance expliquée",
                   ylim = c(0, max(pca_post_eig) * 1.1))
lines(barplot, pca_post_eig, type = "o", pch = 19, col = "darkblue", lwd = 2)
text(x = barplot,
     y = pca_post_eig+ max(pca_post_eig)*0.05,
     labels = round(pca_post_eig, 1),
     cex = 0.9, font = 2)

#============================================================================
#    Partie 4.2: Analyse en Composantes Principales pre-crise
#============================================================================
pre <- database_w %>% filter(PCRISIS1 == 0)
pca_pre <- PCA(pre[, vars], graph = FALSE)
plot(pca_pre, choix = "var")
pca_pre$var$coord

pca_pre_eig <- pca_pre$eig[, "percentage of variance"]
barplot <- barplot(pca_pre_eig,
                   main = "Pourcentage de Variance expliquée",
                   names.arg = 1:nrow(pca_pre$eig),
                   col = "lightblue",
                   border = NA,
                   xlab = "Composante Principale",
                   ylab = "% de variance expliquée",
                   ylim = c(0, max(pca_pre_eig) * 1.1))
lines(barplot, pca_pre_eig, type = "o", pch = 19, col = "darkblue", lwd = 2)
text(x = barplot,
     y = pca_pre_eig+ max(pca_pre_eig)*0.05,
     labels = round(pca_pre_eig, 1),
     cex = 0.9, font = 2)


#============================================================================
#    Partie 4.3: Classement de pays 
#============================================================================
pre_df  <- database_w %>% filter(PCRISIS1 == 0)
post_df <- database_w %>% filter(PCRISIS1 == 1)

cat("Observations pré-crise :", nrow(pre_df), "\n")
cat("Observations post-crise:", nrow(post_df), "\n")

# Exécuter PCA sur subsets pré & post 
res.pca.pre  <- PCA(pre_df[, vars],  scale.unit = FALSE, graph = FALSE)
res.pca.post <- PCA(post_df[, vars], scale.unit = FALSE, graph = FALSE)

#SCREE PLOT pre/post crise
png("scree_pre.png", width = 800, height = 600)
fviz_eig(pca_pre, addlabels = TRUE, main = "Scree plot - Pré-crise")
dev.off()
png("scree_post.png", width = 800, height = 600)
fviz_eig(pca_post, addlabels = TRUE, main = "Scree plot - Post-crise")
dev.off()

scores_pre  <- as.data.frame(res.pca.pre$ind$coord)
scores_pre$iso3c  <- pre_df$iso3c
scores_pre$obs_id <- rownames(pre_df)

scores_post <- as.data.frame(res.pca.post$ind$coord)
scores_post$iso3c <- post_df$iso3c
scores_post$obs_id <- rownames(post_df)

mean_pre_by_country  <- scores_pre  %>% group_by(iso3c)  %>% summarise(mean_CP1_pre = mean(Dim.1, na.rm = TRUE), n_pre = n())
mean_post_by_country <- scores_post %>% group_by(iso3c)  %>% summarise(mean_CP1_post = mean(Dim.1, na.rm = TRUE), n_post = n())

country_cmp <- full_join(mean_pre_by_country, mean_post_by_country, by = "iso3c") %>%
  mutate(mean_CP1_pre  = ifelse(is.na(mean_CP1_pre), 0, mean_CP1_pre),
         mean_CP1_post = ifelse(is.na(mean_CP1_post), 0, mean_CP1_post),
         delta_CP1 = mean_CP1_post - mean_CP1_pre) %>%
  arrange(delta_CP1)   # tri asc : les plus négatifs = plus forte baisse

# Exporter top 20
write.csv(country_cmp, "country_cp1_pre_post_comparison.csv", row.names = FALSE)

# Top 10 pays les plus durement touchés (plus grande baisse de CP1)
top10_hurt <- head(country_cmp, 10)
#Graphique pour 10 pays les plus durement touchés
ggplot(top10_hurt, aes(x = delta_CP1, y = reorder(iso3c, delta_CP1))) +
  geom_col(fill = "grey35", width = 0.8) +
  geom_vline(xintercept = 0, color = "grey40", linewidth = 0.6) +
  labs(
    title = "Top 10 pays : baisse moyenne CP1 (post - pre)",
    x = "Delta CP1 (post - pre)",
    y = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(hjust = 0.5),
    panel.grid.major.y = element_blank()
  )


#===================================================================================================
#    Partie 5:	ANALYSE ECONOMETRIQUE – TESTS ET INTERPRETATON ECONOMIQUE :Regression pannel
#===================================================================================================
library(plm)
pdata <- pdata.frame(database, index = c("iso3c", "date"))
summary(pdata)

#===================================================================================================
#    Partie 5.1: Sélection du modèle de régression sur données de panel 
#===================================================================================================
#Modele 1: Pooled OLS
#Modèle complet:
pooling <- plm(PCRISIS1 ~ ROAA + NPLGROSSLOANS + PER + CREDITGDP + GDPG + GFCFG + GFCFGDP + HFCEG + HFCEGDP + CAGDP + INFL + REALRATE + DEPRATE,
               data = database,
               model = "pooling")
summary(pooling)

#Modele 2:FIXED EFFECTS
#Modèle complet:
fe <-plm(PCRISIS1 ~ ROAA + NPLGROSSLOANS + PER + CREDITGDP + GDPG + GFCFG + GFCFGDP + HFCEG + HFCEGDP + CAGDP + INFL + REALRATE + DEPRATE,
         data = pdata,
         model = "within")

#Test de chow
pFtest(fe, pooling)


#Modele 3: RANDOM EFFECTS
#Pour analyser cette modèle, nous devrons assurer que le nombre de coefficients, y compris le constant, est égal au celui de individus. Comme le modèle pooling MCO est meilleur que celui Fixed Effet. Nous visons à réaliser une élimination des varaibles explicative via méthode Backward jusqu'à avoir le même nombre de variables explicatives et des individus.
#Via cette dernière, nous retirons 4 variables le plus non significatives où p_value le plus élevé, ce sont respectivement NPLGROSSLOANS, GFCRFGDP,CFCFG, GFCFGDP

#Modele FE de 9 variables
fe1 <-plm(PCRISIS1 ~ ROAA + PER + GDPG + HFCEG + HFCEGDP + CAGDP + INFL + REALRATE + DEPRATE,
          data = pdata,
          model = "within")
summary(fe1)

#Modèle complet de RE de 9 variables
re <- plm(PCRISIS1 ~ ROAA + PER + GDPG + HFCEG + HFCEGDP + CAGDP + INFL + REALRATE + DEPRATE,  
          data = pdata,
          model = "random")

#Le test de Hausman
phtest(fe1, re)

#Modele de pooled de 9 varaibles
pooling1 <- plm(PCRISIS1 ~ ROAA + PER + GDPG + HFCEG + HFCEGDP + CAGDP + INFL + REALRATE + DEPRATE,  
                data = pdata,
                model = "pooling")

#Test de Breusch–Pagan
plmtest(pooling1, type = "bp")

#===================================================================================================
#    Partie 5.2: Modèle final et interprétation des données
#===================================================================================================
#Modèle final:
re <- plm(PCRISIS1 ~ ROAA  + CAGDP + INFL + DEPRATE,  
          data = pdata,
          model = "random")
summary(re)
print(re)

#robustness check - Résultats du modèle logit à effets aléatoires 
library(lme4)
logit_re <- glmer(  PCRISIS1 ~ ROAA + CAGDP + INFL + DEPRATE + (1 | iso3c),
                    data = database,
                    family = binomial(link = "logit"))
print(logit_re)

# Test de robustesse – Modèle à effets aléatoires avec erreurs standards robustes
library(lmtest)
coeftest(re, vcov = vcovHC(re, type = "HC1", cluster = "group"))

#Approche de Mundlak
library(dplyr)
pdata <- pdata %>%
  group_by(iso3c) %>%
  mutate(
    ROAA_mean = mean(ROAA),
    INFL_mean = mean(INFL),
    CAGDP_mean = mean(CAGDP),
    DEPRATE_mean = mean(DEPRATE)  )
re_mundlak <- plm(  PCRISIS1 ~ ROAA + INFL + CAGDP + DEPRATE +
                      ROAA_mean + INFL_mean + CAGDP_mean + DEPRATE_mean,
                    data = pdata,
                    model = "random" )
summary(re_mundlak)

#===================================================================================================
#    Partie 5.3: Tests diagnostiques 
#===================================================================================================
#Test de normalité
res_re <- residuals(re)    
shapiro.test(res_re)

#Test de homoscadasticité
library(lmtest)
library(car)

bptest(re)

#Test de multi colinéarité
df <- as.data.frame(pdata)
lm_for_vif <- lm(formula(re), data = df)
vif(lm_for_vif)

#========================================================================
# Partie 6: Les modèles de choix binaire (Logit)
#========================================================================
library(dplyr)
library(lme4)

vars <- c("PCRISIS1","ROAA","CAGDP","INFL","DEPRATE","iso3c")
db_logit <- database[, vars, drop = FALSE]
db_logit <- na.omit(db_logit)

# ======================================================================
# 6.1. Modèle Logit de RE
#=======================================================================
logit_re_final <- glmer(
  PCRISIS1 ~ ROAA + CAGDP + INFL + DEPRATE + (1 | iso3c),
  data = db_logit,
  family = binomial(link = "logit")
)
summary(logit_re_final)

#Likelihood Ratio Test
logit_null <- glmer(PCRISIS1 ~ 1 + (1 | iso3c),
                    data = db_logit,
                    family = binomial("logit"))

anova(logit_null, logit_re_final, test = "Chisq")

#Psuedo R2
library(performance) #Psuedo
r2(logit_re_final)

#===============================================================================
# 6.2. Qualité de prédiction
#===============================================================================
library(pROC)

prob <- predict(logit_re_final, type = "response")

roc_obj <- roc(db_logit$PCRISIS1[!is.na(prob)], prob)
auc(roc_obj)
plot(roc_obj, col = "blue")

#=======================================================================
#6.3. Probabilité de la crise de banque
#=======================================================================
database$prob_crisis[as.integer(rownames(db_logit))] <- prob

summary(database$prob_crisis)

#===============================================================================
#6.4. Effets Marginals
#===============================================================================
library(marginaleffects)

dat_used <- model.frame(logit_re_final)

#===============================================================================
# 6.4. Effets marginaux + Probabilité estimée au point moyen (X̄)
#===============================================================================
library(marginaleffects)

#===============================================================================
# 6.4. Effets marginaux + Probabilité estimée au point moyen (X̄)
#===============================================================================
library(marginaleffects)

# (0) échantillon de logit  (N=116)
dat_used <- model.frame(logit_re_final)

# (1) X moyenne (X̄)
X_mean <- data.frame(
  ROAA    = mean(dat_used$ROAA),
  CAGDP   = mean(dat_used$CAGDP),
  INFL    = mean(dat_used$INFL),
  DEPRATE = mean(dat_used$DEPRATE),
  iso3c   = dat_used$iso3c[1]  # cần cho (1|iso3c), không ảnh hưởng nếu re.form=NA
)
X_mean

# (2) Probabilité estimée au point moyen : p(Y=1 | X = X̄)
P_meanX <- predict(logit_re_final, newdata = X_mean, type = "response", re.form = NA)
P_meanX

# (3) AME (Average Marginal Effects) = margins, dydx(*) trong Stata
ame <- avg_slopes(logit_re_final, variables = c("ROAA","CAGDP","INFL","DEPRATE"),
                  newdata = dat_used, re.form = NA)
ame

# (4) Descriptives (Moyenne de  X)
summary(dat_used[, c("ROAA","CAGDP","INFL","DEPRATE")])
