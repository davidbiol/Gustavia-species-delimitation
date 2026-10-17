library(vegan)
library(readxl)
library(cluster)
library(ggplot2)
#remotes::install_github("alekseyenko/WdStar", force = TRUE)
library(WdStar)
library(BiasedUrn)

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

###Testing multivariate homogeneity of grooups dispersions
trait_cols <- c("veinsPairsMedian", "leafLengthMedian", "leafWidthMedian", "petioleLengthMedian",
                "inflorescenceType", "rachisInflorescenceLength", "numberFlowersMedian", "corolaColor")
traits_df  <- analyzeGustData[, trait_cols]

# 3. Calculate the distance matrix
dist_matrix <- daisy(traits_df, metric = "gower")

species_groups <- factor(c(rep("fasciculata",21), rep("gentryi", 6),
                         rep("gracillima", 9), rep("poeppigiana", 15)),
                         labels = c("fasciculata", "gentryi", "gracillima", "poeppigiana"))
# 4. Run betadisper
disp_mod <- betadisper(dist_matrix, group = species_groups, type = "median")

# 5. Run the permutation test
disp_test <- permutest(disp_mod, permutations = 10000)
print(disp_test)



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


###Homocediticity is violated, so a Welch-modified PERMANOVA is performed
a <- WdS.test(dm=dist_matrix, f=species_groups, nrep = 10000)
a$
result <- Tw2.posthoc.tests(dm = dist_matrix, f = species_groups)
print(result)

###Pairwise PERMANOVA (Welch)
# 1. Get all unique pairs of your 4 species
species_list <- unique(species_groups)
species_pairs <- combn(species_list, 2)

# 2. Create an empty data frame to store results
pairwise_results <- data.frame(
  Comparison = character(),
  WdS_Stat = numeric(),
  p_value = numeric(),
  Omega_Sq = numeric(),
  stringsAsFactors = FALSE
)

# 3. Loop through each pair and run the Welch PERMANOVA
# Note: WdS.test requires a matrix object for the distance matrix
dm_matrix <- as.matrix(dist_matrix)

# 3. The Loop (With the factor level fix)
for(i in 1:ncol(species_pairs)) {
  sp1 <- species_pairs[1, i]
  sp2 <- species_pairs[2, i]

  idx <- which(species_groups %in% c(sp1, sp2))

  sub_dm <- as.dist(dm_matrix[idx, idx])

  # FIX: Wrapping in factor() completely drops the unused empty species levels!
  sub_groups <- factor(species_groups[idx])

  # Run the test
  pair_test <- WdS.test(dm = sub_dm, f = sub_groups, nperm = 999)

  # Save data cleanly
  pairwise_results[i, ] <- data.frame(
    Comparison = paste(sp1, "vs", sp2),
    WdS_Stat = round(pair_test$statistic, 3),
    p_value = pair_test$p.value,
    Omega_Sq = round(pair_test$estimate, 4),
    stringsAsFactors = FALSE
  )
}

# 4. Correct for multiple testing (False Discovery Rate)
pairwise_results$p_value <- as.numeric(pairwise_results$p_value)
pairwise_results$p_adj <- p.adjust(pairwise_results$p_value, method = "BH")

print(pairwise_results)

library(vegan)
library(dplyr)

# 2. Fit the variables to the NMDS ordination
fit <- envfit(nmds_result, analyzeGustData, permutations = 10000, na.rm = TRUE)
env_vectors <- as.data.frame(scores(fit, display = "vectors"))
env_vectors$Variable <- rownames(env_vectors)
env_vectors$p_value <- fit$vectors$pvals

# 3. View the results
fit
