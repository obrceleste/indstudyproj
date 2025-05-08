### PCA ###
# Author: Celeste O'Brien

# I know this is bad practice, but a quick fix is a quick fix
install.packages("ggplot2")
install.packages("tidyverse")

# Load required libraries
library(ggplot2)
library(tidyverse)

# Read in data set
final_movies <- read.csv("cleaned_movie_data.csv")

# Display large numbers in non-scientific format
options(scipen = 999)

# Select numeric variables and remove NAs
pca_data <- final_movies %>%
  select(vote_average, vote_count, revenue, popularity, production_budget_usd,
         domestic_gross_usd, worldwide_gross_usd, domestic_box_office_usd, 
         running_time_minutes) %>%
  drop_na()

# Scale the data
pca_scaled <- scale(pca_data)

# Run PCA
pca_result <- prcomp(pca_scaled)

# Calculate proportion of variance explained
pca_var <- pca_result$sdev^2
pca_var_explained <- pca_var / sum(pca_var)

# Create a scree plot
scree_df <- data.frame(
  PC = paste0("PC", 1:length(pca_var_explained)),
  Variance = pca_var_explained
)

### Add cumulative variance to scree plot ###
# This helps to see how many PCs are needed to explain most of the variance
scree_df$cumulative <- cumsum(scree_df$Variance)

ggplot(scree_df, aes(x = as.numeric(gsub("PC", "", PC)))) +
  geom_col(aes(y = Variance), fill = "steelblue", alpha = 0.8) +
  geom_line(aes(y = cumulative), color = "black", size = 1) +
  geom_point(aes(y = cumulative), color = "black", size = 2) +
  ylab("Variance Explained") +
  xlab("Principal Component") +
  scale_x_continuous(breaks = 1:nrow(scree_df)) +
  ggtitle("Scree Plot with Cumulative Variance", 
          subtitle = "How many PCs are needed to explain most of the variance?") +
  theme_light() +
  theme(
    plot.title = element_text(size = 14, hjust = 0.5),  
    plot.subtitle = element_text(size = 12, hjust = 0.5) 
  )

# Save plot
ggsave("figures/cumvar_scree.png", width = 8, height = 6, dpi = 300)


### Plot PCA as a scatterplot ###
# Convert PCA scores to a data frame
pca_scores <- as.data.frame(pca_result$x)

# Plot PC1 vs PC2
ggplot(pca_scores, aes(x = PC1, y = PC2)) +
  geom_point(alpha = 0.6, color = "darkblue") +
  ggtitle("PCA: PC1 vs PC2") +
  xlab(paste0("PC1 (", round(pca_var_explained[1]*100, 1), "%)")) +
  ylab(paste0("PC2 (", round(pca_var_explained[2]*100, 1), "%)")) +
  theme_light() +
  theme(
    plot.title = element_text(size = 14, hjust = 0.5),  
    plot.subtitle = element_text(size = 12, hjust = 0.5) 
  )

# Save plot
ggsave("figures/scatter_pca.png", width = 8, height = 6, dpi = 300)


### Perform K-means clustering on PCA ###
# Use first 2 PCs
set.seed(123)
kmeans_result <- kmeans(pca_scores[, 1:2], centers = 3)

# Add cluster labels
pca_scores$cluster <- factor(kmeans_result$cluster)

# Plot clusters
# This visual helps you see natural groupings in your data after dimension reduction with PCA
ggplot(pca_scores, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.7) +
  ggtitle("K-means Clustering on First 2 PCs", 
          subtitle = "What are the natural groupings after dimensionality reduction?") +
  theme_light() +
  theme(
    plot.title = element_text(size = 14, hjust = 0.5),  
    plot.subtitle = element_text(size = 12, hjust = 0.5) 
  )

# Save plot
ggsave("figures/clusers.png", width = 8, height = 6, dpi = 300)

# Add cluster labels back to the original data
final_movies_with_clusters <- final_movies %>%
  filter(!is.na(vote_average), !is.na(vote_count), !is.na(revenue),
         !is.na(popularity), !is.na(production_budget_usd),
         !is.na(domestic_gross_usd), !is.na(worldwide_gross_usd),
         !is.na(domestic_box_office_usd), !is.na(running_time_minutes)) %>%
  mutate(cluster = pca_scores$cluster)

# Summarize numeric variables by cluster
final_movies_with_clusters %>%
  group_by(cluster) %>%
  summarise(
    avg_budget = mean(production_budget_usd, na.rm = TRUE),
    avg_revenue = mean(revenue, na.rm = TRUE),
    avg_popularity = mean(popularity, na.rm = TRUE),
    avg_vote = mean(vote_average, na.rm = TRUE),
    avg_runtime = mean(running_time_minutes, na.rm = TRUE),
    count = n()
  )

# Plot numeric distributions by cluster
ggplot(final_movies_with_clusters, aes(x = production_budget_usd, fill = cluster)) +
  geom_density(alpha = 0.5) +
  ylab("Density") +
  xlab("Production Budget (USD)") +
  scale_x_log10() +  # if budget has a wide range
  ggtitle("Distribution of Production Budget by Cluster") +
  theme_light() +
  theme(plot.title = element_text(size = 14, hjust = 0.5)
  )

ggsave("figures/density_by_budget.png", width = 8, height = 6, dpi = 300)

ggplot(final_movies_with_clusters, aes(x = vote_average, fill = cluster)) +
  geom_density(alpha = 0.5) +
  ylab("Density") +
  xlab("IMDb Vote Average") +
  scale_x_log10() +  # if budget has a wide range
  ggtitle("Distribution of IMDb Vote Average by Cluster") +
  theme_light() +
  theme(plot.title = element_text(size = 14, hjust = 0.5)
  )

ggsave("figures/density_by_vote.png", width = 8, height = 6, dpi = 300)

ggplot(final_movies_with_clusters, aes(x = revenue, fill = cluster)) +
  geom_density(alpha = 0.5) +
  ylab("Density") +
  xlab("Revenue") +
  scale_x_log10() +  # if budget has a wide range
  ggtitle("Distribution of Revenue by Cluster") +
  theme_light() +
  theme(plot.title = element_text(size = 14, hjust = 0.5)
  )

ggsave("figures/density_by_revenue.png", width = 8, height = 6, dpi = 300)

### END OF PROGRAM ###