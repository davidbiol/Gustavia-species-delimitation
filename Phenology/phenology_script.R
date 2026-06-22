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
