# Species delimitation in <i>Gustavia</i> (Lecythidaceae): an integrative taxonomic approach

[![Journal](https://img.shields.io/badge/Journal-American%20Journal%20of%20Botany-2b592c)](https://bsapubs.onlinelibrary.wiley.com/journal/15372197)
[![Status](https://img.shields.io/badge/Status-Draft-purple)]()

Supplementary data for: Ángel-Vallejo, MC, Mora-López, JD, Gutiérrez-Duque D, Jara-Muñoz, OA, Medellín-Zabala D (in review). Species delimitation in <i>Gustavia</i> (Lecythidaceae): an integrative taxonomic approach. American Journal of Botany.

---
This repository has been created with the aim of reproducibility of the analyses done. Also, it provides the required tools for any integrative study that aims to circumscribe species in Neotropical Lecythidaceae, particularly in the genus _Gustavia_. Various tools are presented for [morphometric analysis](Morphometric%20analysis), [Climatic niche similarity analyses], [Ecological Niche Modeling], [phenology visualization](Phenology), [Preliminary IUCN Red List assessment], and [displaying the occurrence records on protected areas]. Additionally, we include a script for phylogenetic tree pruning.

## Morphometric analysis
We revised and measured 51 herbarium specimens ([Morphometric analysis/gustavia_comp.csv](Morphometric%20analysis/gustavia_comp.csv)). Eight morphological characters of taxonomic importance were measured. In order to understand the intraspecific and interspecific morphometric variation, non-metric multidimensional scaling (NMDS) was performed using the ```metaMDS``` function of the R package vegan (Oksanen et al., 2026) within the R statistical environment (R Core Team, 2024). Prior to the NMDS analyses, all continuous characters were scaled to have unit variance, and a dissimilarity matrix was calculated using the Gower’s formula implemented in the ```daisy``` function of the R package cluster (Maechler et al., 2023).

Permutational multivariate analysis of variance (PERMANOVA) was performed to test for significant morphological differentiation among the predefined species groups using the ```adonis2``` function (vegan). Post-hoc pairwise comparisons between species pairs were calculated using the ```pairwise.adonis2``` function from the R package pairwiseAdonis (Martínez, 2017). 
```
#devtools::install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")
library(pairwiseAdonis)
# Run the pairwise comparison
pairwise_results <- pairwise.adonis2(gower_dist ~ species, data = gustData, nperm = 10000)
# View the results
pairwise_results
```
Complete [script](Morphometric%20analysis/morphometric_analysis.R) and [results](Morphometric%20analysis/nmds_plot.png) can be found in the folder [Morphometric analysis](Morphometric%20analysis)


## Climatic niche similarity analyses
start

## Ecological Niche Modeling (ENM)
start

## Phylogenetic tree pruning
We pruned the Maximum Likelihood phylogenetic tree inferred by [Medellín-Zabala et al. (2026)](https://doi.org/10.1111/jbi.70225) to visualize the subclade that ecompasses <i>Gustavia fasciculata</i> sp. nov. and its closely related taxa.
```
library(ape)
library(phytools)
library(phangorn)
library(maps)

# Loading the tree
Lecy.tree <- read.tree(file="ufbt_Lecy_newtaxo.treefile")
head(Lecy.tree)

#extracting the Gustavia clade
plotTree(Lecy.tree, ftype="i", fsize=0.4, lwd=1)
nodelabels(Lecy.tree$node.label, frame = "none", cex = 0.6)
nodelabels(frame = "circ", bg = "white", cex = 0.4) #to see the node labels
Lecy.tree.gustavia <- extract.clade(Lecy.tree, node = 592)
plotTree(Lecy.tree.gustavia)

write.tree(Lecy.tree.gustavia, file = "Gustavia_ML.treefile")

#extracting G. gentryi species complex
Gustavia.tree <- read.tree(file="Gustavia_ML.treefile")
Gustavia.tree #92 tips
head(Gustavia.tree)

plotTree(Gustavia.tree, ftype="i", fsize=0.4, lwd=1)
nodelabels(Gustavia.tree$node.label, frame = "none", cex = 0.6)
nodelabels(frame = "circ", bg = "white", cex = 0.4) #to see the node labels
Lecy.tree.gentryi <- extract.clade(Gustavia.tree, node = 141)
plotTree(Lecy.tree.gentryi)

write.tree(Lecy.tree.gentryi, file = "G_gentryi_complex_ML.treefile")

# Plotting the tree
pdf(height = 5, width = 6, file = "Gentryi_complex.pdf")
Gentryi.tree <- read.tree(file="G_gentryi_complex_ML.treefile")
Gentryi.tree$root.edge <- 0.005
plot.phylo(Gentryi.tree, root.edge = TRUE, ftype="i", cex=0.9, lwd=3, label.offset = 0.002, y.lim = c(-1, Ntip(Gentryi.tree)))
nodelabels(Gentryi.tree$node.label, frame = "none", cex=0.7, adj = -0.3)
add.scale.bar(cex = 0.6, lwd = 1, y=-0.3, x=0)

dev.off()
```

## Phenology
The phenological data were obtained from all fertile examined specimens and categorized as flowering, fruiting, or both ([Phenology/data_phe.csv](Phenology/data_phe.csv)). Then it was graphed in R ([script](Phenology/phenology_script.R)). Results can be found in the folder [Phenology](Phenology).
```
library(ggplot2)
library(tidyr)
library(dplyr)
library(readxl)

windowsFonts(Times=windowsFont("Times New Roman"))

data <- read.table(file="data_phe.csv", header = TRUE, sep = ",")
str(data)
data$Month = factor(data$Month, levels= c("Jan", "Feb", "Mar", "Apr", "May",
                                          "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
data$Phenology = factor(data$Phenology, levels= c("Flower","Fruit"))

ggplot(data, aes(x = Month, y = Records, fill = Phenology)) +
  geom_bar(stat = "identity", position = "stack") +
  coord_polar(start = 0) +
  scale_fill_manual(values = c("#702963", "orange")) +
  theme_minimal()+ theme(text=element_text(family="Times",size=14))
```

## Preliminary IUCN Red List assessment
start

## Occurrence in protected areas
start

---

## References

Cobos, M. E., Peterson, A. T., Barve, N., & Osorio-Olvera, L. (2019). kuenm: an R package for detailed development of ecological niche models using Maxent. PeerJ, 7, e6281. https://doi.org/10.7717/peerj.6281

Dauby, G., & de Lima, R. A. F. (2024). ConR: Computation of Parameters Used in Preliminary Assessment of Species Conservation Status. R package (version 2.1.0).

Maechler, M., Rousseeuw, P., Struyf, A., Hubert, M., & Hornik, K. (2023).  _cluster: Cluster Analysis Basics and Extensions_. R package version 2.1.6.

Martinez, P. (2017). _pairwiseAdonis: Pairwise Multilevel Comparison using Adonis_. R package version 0.4.1, commit cb190f7668a0c82c0b0853927db239e7b9ec3e83, <https://github.com/pmartinezarbizu/pairwiseAdonis>.

Medellín-Zabala, D., J. L. M. Charboneau, O. M. Vargas, S. A. Smith, D. J. P. Gonçalves, A. S. Chanderbali, D. E. Soltis, et al. 2026. Assembling the Neotropical Tree Flora: Andean Uplift and the Historical Biogeography of the Brazil Nut Family (Lecythidaceae). _Journal of Biogeography_ 53: e70225. https://doi.org/10.1111/jbi.70225

Oksanen J, Simpson G, Blanchet F, Kindt R, Legendre P, Minchin P, O'Hara R, Solymos P, Stevens M, Szoecs E, Wagner H, Barbour M, Bedward M, Bolker B, Borcard D, Borman T, Carvalho G, Chirico M, De Caceres M, Durand S, Evangelista H, FitzJohn R, Friendly M, Furneaux B, Hannigan G, Hill M, Lahti L, Martino C, McGlinn D, Ouellette M, Ribeiro Cunha E, Smith T, Stier A, Ter Braak C, & Weedon J. (2026). _vegan: Community Ecology Package_. R package version 2.7-3, <https://CRAN.R-project.org/package=vegan>.

R Core Team (2024). R: A Language and Environment for Statistical Computing. R Foundation for Statistical Computing, Vienna, Austria. https://www.R-project.org/
