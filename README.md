# Species delimitation in <i>Gustavia</i> (Lecythidaceae): an integrative taxonomic approach

[![Journal](https://img.shields.io/badge/Journal-American%20Journal%20of%20Botany-2b592c)](https://bsapubs.onlinelibrary.wiley.com/journal/15372197)
[![Status](https://img.shields.io/badge/Status-Draft-purple)]()

Supplementary data for: Ángel-Vallejo, MC, Mora-López, JD, Gutiérrez-Duque D, Jara-Muñoz, OA, Medellín-Zabala D (in review). Species delimitation in <i>Gustavia</i> (Lecythidaceae): an integrative taxonomic approach. American Journal of Botany.

---
This repository has been created with the aim of reproducibility of the analyses done. Also, it provides the required tools for any integrative study that aims to circumscribe species in Neotropical Lecythidaceae, particularly in the genus _Gustavia_. Various tools are presented for [morphometric analysis](Morphometric%20analysis), [Climatic niche similarity analyses], [Ecological Niche Modeling], [phenology visualization](Phenology), and [Preliminary IUCN Red List assessment]. Additionally, we include a script for phylogenetic tree pruning.

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

Environmental niche comparisons among the four species (*G.fasciculata*, *G. poeppigiana*, *G. gentryi*, and *G. gracillima*) were conducted using the PCA-env approach and the niche similarity analyses implemented in the [ecospat R package](Climatic%20niche%20similarity%20analyses/Niche%20smilarity%20analyses.R) (Broennimann et al., 2012; Di Cola et al., 2017). The niche similarity hypothesis was evaluated to determine whether observed niche overlap between species was higher than expected by chance. The level of climatic niche similarity between pairs of species  was assessed using the Shoener’s D index (Schoener, 1970) and the modified Hellinger distance I (Warren et al., 2008).

To determine whether observed niche overlap differed from null expectations, we conducted niche similarity tests following the PCA-env framework of Broennimann et al. (2012). In these analyses, the niche of one species was held constant, whereas occurrence records of the second species were randomly redistributed within its accessible environmental background to generate a null distribution of niche overlap values.

Climatic data, ocurrence records for each species can be found in the folder [Climatic niche similarity analyses](Climatic%20niche%20similarity%20analyses) and the analysis [script](Climatic%20niche%20similarity%20analyses/Niche%20similarity%20analyses.R)

## Ecological Niche Modeling (ENM)
To construct the Ecological Niche Model (ENM), occurrence records for the species and 19 bioclimatic variables available from the [Worldclim](https://www.worldclim.org/data/worldclim21.html) database were used. Occurrence records were filtered to retain only one record per square kilometer and then partitioned into [joint](ENM/gustavia_joint.csv), [train](ENM/gustavia_train.csv), and [test](ENM/gustavia_test.csv) dataset. The bioclimatic variables were refined through a correlation analysis. The accessible area (M) was delineated by intersecting species occurrence records with the ecoregions (Dinerstein et al. 2017) covering the Middle and Low Magdalena Valley [(M_variables)](ENM/M_variables/Set_1). 

The ENM was built using the maximum entropy algorithm (Maxent) via the KUENM package (Cobos et al. 2019). The model was generated using a unique [set](ENM/M_variables/Set_1) of bioclimatic variables and the partitioned ocurrences records, and was calibrated with 15 regularization multipliers (0.1–1 at intervals of 0.1, and 2–6 at intervals of 1) and seven combinations of feature classes (l = linear, q = quadratic, and p = product features).All analyses were conducted using the software [R](https://www.r-project.org/) (R Core Team, 2024). 



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

The preliminary IUCN Red List assessment of the Extent of occurrence (EOO) and area of occupancy (AOO) was estimated based on the geographical data from the specimens, using the ConR v.2.1 R package ([Dauby and de Lima 2024](https://github.com/gdauby/ConR)). We used the Convex Hull method to compute EOO, setting 2 × 2 km grid cells. This grid was randomly overlaid 100 times to calculate AOO. The IUCN Red List category for the species was assessed following the guidelines of the International Union for Conservation of Nature v.16 (IUCN 2024). 
The code for this analysis can be found in [IUCN-Assessment/analysis-iucn.R](IUCN%20Assessment/analysis%20iucn.R)
### Extent of Occurrence (EOO)
```
EOO.datos <- EOO.computing(XY = datos, method.range = "convex.hull", export_shp = TRUE, show_progress = FALSE)
country_map <- ne_countries(scale = 50)
plot(st_geometry(country_map), extent = EOO.datos$spatial)
plot(EOO.datos$spatial, lwd = 2, col = "red",  add= TRUE)
print(EOO.datos)
#EEO 14779.8 km2
```
The EEO estimated for the species was **14779.8 km2**.

```
### Area of Occupancy (AOO)
AOO.datos <- AOO.computing(XY = datos, cell_size_AOO = 2, nbe.rep.rast.AOO = 100, show_progress = FALSE)
print(AOO.datos)
#AOO 84 km2
```
The AOO estimated for the species was **84 km2**.
```
radius <- subpop.radius(XY = datos, quant.max = 0.9)
radius
sub <- subpop.comp(XY = datos,
                   resol_sub_pop = radius$radius,
                   show_progress = FALSE)
print(sub)
#5 subpopulations
```
First, the radius is calculated in order to estabilsh the distance between subpopulations. After that, the number of subpopulations are estimated, giving **five subpopulations**.

### Fragmentation
```
locs <- locations.comp(datos,
                       method = "fixed_grid",
                       nbe_rep = 100,
                       cell_size_locations = 10,
                       rel_cell_size = 0.05,
                       #threat_list = strict.ucs.spdf,
                       #id_shape = "NAME",
                       method_polygons = "no_more_than_one",
                       show_progress = FALSE)
print(locs)
#13 locations
sever.frag <- severe_frag(XY = datos,
                          resol_sub_pop = radius$radius,
                          dist_isolated = radius$radius,
                          show_progress = FALSE,
                          nbe_rep = 100)
print(sever.frag)
#71 frac, severe_frag TRUE
```
The number of localities is estimated. With the radius between subpopulations previously estimated, and the number of localities known, the degree of fragmentation is estimated. The result was **severely fragmented**.

### IUCN Criteria assessment
```
critB <- criterion_B(x = datos,
                     AOO = AOO.datos,
                     EOO = EOO.datos$results,
                     locations = locs$locations,
                     severe.frag = sever.frag,
                     subpops = sub,
                     decline = "Decreasing")


print(critB)
#                       tax  EOO AOO locations nbe_unique_occs category_B category_B_code subpop severe_frag issue_aoo issue_eoo issue_locations main_threat
# Gustavia.fasciculata 14779.8  84      17              21         EN            B2ab      5        TRUE        NA        NA              NA        <NA>
```
Finally, the data obtained from EOO, AOO, number of subpopulations, number of localities, degree of fragmentation and threats is used to estimate the preliminary IUCN Red list assessment for *Gustavia fasciculata* as **Endangered (EN)**.


## References

Cobos, M. E., Peterson, A. T., Barve, N., & Osorio-Olvera, L. (2019). kuenm: an R package for detailed development of ecological niche models using Maxent. PeerJ, 7, e6281. https://doi.org/10.7717/peerj.6281

Broennimann, O., Fitzpatrick, M. C., Pearman, P. B., Petitpierre, B., Pellissier, L., Yoccoz, N. G., ... & Guisan, A. (2012). Measuring ecological niche overlap from occurrence and spatial environmental data. Global ecology and biogeography, 21(4), 481-497.

Dauby, G., & de Lima, R. A. F. (2024). ConR: Computation of Parameters Used in Preliminary Assessment of Species Conservation Status. R package (version 2.1.0).

Di Cola, V., Broennimann, O., Petitpierre, B., Breiner, F. T., d'Amen, M., Randin, C., ... & Guisan, A. (2017). ecospat: an R package to support spatial analyses and modeling of species niches and distributions. Ecography, 40(6), 774-787.

Maechler, M., Rousseeuw, P., Struyf, A., Hubert, M., & Hornik, K. (2023).  _cluster: Cluster Analysis Basics and Extensions_. R package version 2.1.6.

Martinez, P. (2017). _pairwiseAdonis: Pairwise Multilevel Comparison using Adonis_. R package version 0.4.1, commit cb190f7668a0c82c0b0853927db239e7b9ec3e83, <https://github.com/pmartinezarbizu/pairwiseAdonis>.

Medellín-Zabala, D., J. L. M. Charboneau, O. M. Vargas, S. A. Smith, D. J. P. Gonçalves, A. S. Chanderbali, D. E. Soltis, et al. 2026. Assembling the Neotropical Tree Flora: Andean Uplift and the Historical Biogeography of the Brazil Nut Family (Lecythidaceae). _Journal of Biogeography_ 53: e70225. https://doi.org/10.1111/jbi.70225

Oksanen J, Simpson G, Blanchet F, Kindt R, Legendre P, Minchin P, O'Hara R, Solymos P, Stevens M, Szoecs E, Wagner H, Barbour M, Bedward M, Bolker B, Borcard D, Borman T, Carvalho G, Chirico M, De Caceres M, Durand S, Evangelista H, FitzJohn R, Friendly M, Furneaux B, Hannigan G, Hill M, Lahti L, Martino C, McGlinn D, Ouellette M, Ribeiro Cunha E, Smith T, Stier A, Ter Braak C, & Weedon J. (2026). _vegan: Community Ecology Package_. R package version 2.7-3, <https://CRAN.R-project.org/package=vegan>.

R Core Team (2024). R: A Language and Environment for Statistical Computing. R Foundation for Statistical Computing, Vienna, Austria. https://www.R-project.org/

Schoener, T. W. (1970). Nonsynchronous spatial overlap of lizards in patchy habitats. Ecology, 51(3), 408-418.

Warren, D. L., Glor, R. E., & Turelli, M. (2008). Environmental niche equivalency versus conservatism: quantitative approaches to niche evolution. Evolution, 62(11), 2868-2883.
