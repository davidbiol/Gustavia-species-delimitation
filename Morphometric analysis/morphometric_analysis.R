library(vegan)
library(readxl)
library(cluster)
library(ggplot2)

#Load data
gustData <- readxl::read_xlsx("gustavia_comp.xlsx")


gustData$species <- as.factor(gustData$species)
gustData$veinsPairsMedian <- as.numeric(gustData$veinsPairsMedian)
gustData$leafLengthMedian <- as.numeric(gustData$leafLengthMedian)
gustData$leafWidthMedian <- as.numeric(gustData$leafWidthMedian)
gustData$petioleLengthMedian <- as.numeric(gustData$petioleLengthMedian)
gustData$inflorescenceType <- as.factor(gustData$inflorescenceType)
gustData$rachisInflorescenceLength <- as.numeric(gustData$rachisInflorescenceLength)
gustData$numberFlowersMedian <- as.numeric(gustData$numberFlowersMedian)
gustData$corolaColor <- as.factor(gustData$corolaColor)


str(gustData)

#Scale numerical data
gustData$veinsPairsMedian <- as.numeric(scale(gustData$veinsPairsMedian))
gustData$leafLengthMedian <- as.numeric(scale(gustData$leafLengthMedian))
gustData$leafWidthMedian <- as.numeric(scale(gustData$leafWidthMedian))
gustData$petioleLengthMedian <- as.numeric(scale(gustData$petioleLengthMedian))
gustData$rachisInflorescenceLength <- as.numeric(scale(gustData$rachisInflorescenceLength))
gustData$numberFlowersMedian <- as.numeric(scale(gustData$numberFlowersMedian))

analyzeGustData <- as.data.frame(gustData[,-c(1,2,3,4,5)])

#Calculate distance
str(analyzeGustData)
gower_dist <- daisy(analyzeGustData, metric = "gower")
gower_dist


nmds_result <- metaMDS(gower_dist, k = 2, trymax = 200)

# Print the results to check stress and other information
print(nmds_result)


# Extract NMDS scores
nmds_scores <- as.data.frame(nmds_result$points)
colnames(nmds_scores) <- c("NMDS1", "NMDS2")
nmds_scores$sample_id <- gustData$species
nmds_scores$collectors <- gustData$collectorName
nmds_scores$specialName <- gustData$specialName

my_colors <- c(
  "Gustavia fasciculata" = "#FF00C5",  # Red-ish
  "Gustavia gentryi"     = "#FFFF00",  # Green-ish
  "Gustavia gracillima"  = "#55FF00",  # Blue-ish
  "Gustavia poeppigiana" = "#C500FF"   # Purple-ish
)

# Create the plot
ggplot(nmds_scores, aes(x = NMDS1, y = NMDS2, color = sample_id)) +
  geom_point(aes(fill = sample_id), shape = 21, color = "black", size = 3, stroke = 0.8) +
  stat_ellipse(aes(fill = sample_id), geom = "polygon", alpha = 0.1) +
  theme_minimal() +
  labs(color = "Species",
       fill = "Species") +
  scale_color_manual(values = my_colors) +
  scale_fill_manual(values = my_colors) +
  theme(
    axis.title.x = element_text(face = "bold", family = "Arial", size = 11, margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", family = "Arial", size = 11, margin = margin(r = 10)),
    axis.text.x = element_text(family = "Arial", color = "black", size = 10),
    axis.text.y = element_text(family = "Arial", color = "black", size = 10),
    legend.title = element_text(face = "bold", family = "Arial", color = "black", size = 10),
    legend.text = element_text(face = "italic", family = "Arial", color = "black", size = 10))

nmds_result$ndis
adonis2(gower_dist ~ gustData$species, permutations = 10000)

#devtools::install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")
library(pairwiseAdonis)
# Run the pairwise comparison
pairwise_results <- pairwise.adonis2(gower_dist ~ species, data = gustData, nperm = 10000)
# View the results
pairwise_results

library(vegan)
library(dplyr)

# 2. Fit the variables to the NMDS ordination
fit <- envfit(nmds_result, analyzeGustData, permutations = 10000, na.rm = TRUE)
env_vectors <- as.data.frame(scores(fit, display = "vectors"))
env_vectors$Variable <- rownames(env_vectors)
env_vectors$p_value <- fit$vectors$pvals

# 3. View the results
fit
