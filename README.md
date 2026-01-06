# Analyse des Déterminants Macro-Financiers des Crises Bancaires  
### Approche ACP – Clustering et Régression sur Données de Panel
## Master 1 — Monnaie, Banque, Finance et Assurance  
Parcours Ingénierie Économique et Financière  
Université de Rennes — Promotion 2025-2026  
**Auteurs :**  
- Nguyen Hoang Phuc PHAN  
- Ndeye Mbayang TALL  

---
## 1️⃣ Présentation du projet
Cette étude analyse les **vulnérabilités macro-financières** de 14 pays émergents entre **1993 et 2002**, période marquée par plusieurs crises majeures (Mexique, Asie, Russie, Argentine, Brésil).
L’approche combine trois piliers méthodologiques :

✔ **Analyse en Composantes Principales (ACP)**  
✔ **Méthodes de clustering (HCPC & k-means)**  
✔ **Régression économétrique sur données de panel**  
L’objectif est de **caractériser les mécanismes de vulnérabilité bancaire** et d’identifier les variables expliquant l’occurrence de crises.
L’étude mobilise **13 indicateurs macro-économiques & bancaires** couvrant :  
(1) stabilité bancaire — (2) crédit & investissement — (3) prix & change — (4) déséquilibres externes — (5) cycle macroéconomique

---
## 2️⃣ ACP non pondérée & pondérée
Deux axes principaux émergent :
- **Profondeur et endettement financier**
- **Vulnérabilité bancaire & externe**
Les deux premières dimensions expliquent **≈ 55 %** de la variance totale.  
La pondération renforce la pertinence économique en réduisant l’influence des valeurs extrêmes.

---
## 3️⃣ Clustering (HCPC / k-means)
Trois profils de pays sont identifiés :
### 🟢 Cluster 1 — Économies stables
- Croissance forte  
- Crédit élevé  
- Rentabilité bancaire positive  
- Inflation maîtrisée  
⬆ Systèmes financiers profonds et relativement résilients  

---
### 🔴 Cluster 2 — Économies sévèrement fragilisées
- Récession forte  
- Hyperinflation  
- Dépréciation massive  
- Pertes bancaires  
- NPL élevés  
⬆ Profil caractéristique des **économies en crise systémique**

---
### 🟡 Cluster 3 — Économies intermédiaires
- Croissance modérée  
- Rentabilité bancaire élevée  
- Inflation et change plus volatils  
⬆ Résilience partielle mais exposition macro-financière réelle  
---

## 4️⃣ ACP Pré-crise vs Post-crise
### Avant crise
➡ Les tensions nominales dominent (inflation, change)

### Après crise
➡ Le rôle des **indicateurs bancaires** devient central
📌 Cela montre que la crise **reconfigure la structure macro-financière**

---

## 5️⃣ Régression sur données de panel
### 🧮 Modèle retenu : Effets aléatoires (procédure Baltagi)
### ✨ Variables significatives
| Variable | Effet sur la probabilité de crise |
|----------|------------------------------------|
| ROAA | -0.0436 |🔻 Négatif — stabilisateur |
| INFL | -0.0133 |🔻 Négatif — effet contre-intuitif |
| CAGDP | 0.0235 |🔺 Positif |
| DEPRATE | 0.0134 | 🔺 Positif |

➡ Les résultats sont **robustes** (Logit RE, robust SE, Mundlak)
**R² ≈ 0,19 — cohérent avec phénomènes rares et non-linéaires**

---

## 6️⃣ Interprétation économique
### ROAA — Rentabilité des actifs
✔ améliore la résilience bancaire
### Balance courante / PIB
✔ excédents élevés → risques structurels possibles
### Inflation
✔ relation négative dans cet échantillon — résultat spécifique au contexte
### Taux de dépôt
✔ hausse → boom du crédit → vulnérabilité financière

---

## 7️⃣ Tests diagnostiques
✔ Normalité — non cruciale ici  
✔ Homoscédasticité — validée  
✔ Multicolinéarité — faible  

---
## 8️⃣ Enseignements majeurs
- Les crises bancaires résultent d’**interactions macro-financières complexes**
- La **structure de vulnérabilité change après crise**
- Les **indicateurs bancaires deviennent centraux**
- Le crédit et les déséquilibres externes jouent un rôle clé
- Les pays émergents présentent **trajectoires hétérogènes de résilience**

---

## 9️⃣ Conclusion
L’étude offre une **lecture intégrée** des crises bancaires dans les pays émergents :
✔ importance du crédit et de la profondeur financière  
✔ rôle déterminant du secteur bancaire  
✔ recomposition des mécanismes post-crise  
✔ utilité des approches multivariées  
Elle illustre la nécessité d’une **surveillance macro-prudentielle globale** combinant :
📌 stabilité bancaire  
📌 conditions monétaires  
📌 déséquilibres extérieurs  
📌 dynamique du crédit  

---
## Références principales
Baltagi (2013) — Panel Econometrics  
Kaminsky & Reinhart (1999) — Twin Crises  
Schularick & Taylor (2012) — Credit boom-bust  
Demirgüç-Kunt & Huizinga (2000) — Bank profitability  
McKinnon (1973), Shaw (1973) — Financial deepening  

---
## Code
L’ensemble des analyses (ACP, clustering, panel) est implémenté en **R**  
avec les librairies :
- FactoMineR  
- plm  
- corrplot  
- tidyverse  

---
## Contexte académique
Projet réalisé dans le cadre du :
🎓 **Master 1 — Ingénierie Économique & Financière**  
Université de Rennes  

Objectif : **relier recherche académique et analyse empirique quantitative**.
