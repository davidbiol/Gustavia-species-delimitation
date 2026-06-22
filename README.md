# Species delimitation in <i>Gustavia</i> (Lecythidaceae): an integrative taxonomic approach

[![Journal](https://img.shields.io/badge/Journal-American%20Journal%20of%20Botany-2b592c)](https://bsapubs.onlinelibrary.wiley.com/journal/15372197)
[![Status](https://img.shields.io/badge/Status-Draft-purple)]()

Supplementary data for: Ángel-Vallejo, MC, Mora-López, JD, Gutiérrez-Duque D, Jara-Muñoz, OA, Medellín-Zabala D (in review). Species delimitation in <i>Gustavia</i> (Lecythidaceae): an integrative taxonomic approach. American Journal of Botany.

---
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
The [script](Morphometric%20analysis/morphometric_analysis.R) and the [results](Morphometric%20analysis/nmds_plot.png) can be found in the folder [Morphometric analysis](Morphometric%20analysis)


## Climatic niche similarity analyses
start

## Ecological Niche Modeling (ENM)
start

## Phylogenetic cut
start

## Phenology
The phenological data were obtained from all fertile examined specimens and categorized as flowering, fruiting, or both ([Phenology/data_phe.csv](Phenology/data_phe.csv)). Then it was graphed in R ([script](Phenology/phenology_script.R)). Results can be found in the folder [Phenology](Phenology).

## Preliminary IUCN Red List assessment
start

## Occurrence in protected areas
start

---

## References

Cobos, M. E., Peterson, A. T., Barve, N., & Osorio-Olvera, L. (2019). kuenm: an R package for detailed development of ecological niche models using Maxent. PeerJ, 7, e6281. https://doi.org/10.7717/peerj.6281

Dauby, G., & de Lima, R. A. F. (2024). ConR: Computation of Parameters Used in Preliminary Assessment of Species Conservation Status. R package (version 2.1.0).

R Core Team (2024). R: A Language and Environment for Statistical Computing. R Foundation for Statistical Computing, Vienna, Austria. https://www.R-project.org/
