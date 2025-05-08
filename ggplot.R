### GGPLOT ###
# Author: Celeste O'Brien

# Load required libraries
library(ggplot2)
library(ggcorrplot)
library(lubridate)
library(tidyverse)

# Create figures folder if it doesn't already exist
if (!dir.exists("figures")) {
  dir.create("figures")
}

# Read in data set
final_movies <- read.csv("cleaned_movie_data.csv")

# Histogram of date_diff (time from release to Netflix)
ggplot(final_movies, aes(x = as.numeric(date_diff))) +
  geom_histogram(binwidth = 100, fill = "steelblue", color = "black") +
  labs(title = "Time Between Release and Netflix Addition", x = "Weeks", y = "Number of Movies") +
  theme_light() +
  theme(plot.title = element_text(size = 14, hjust = 0.5))

ggsave("figures/hist_date_diff.png", width = 8, height = 6, dpi = 300)

# Boxplot of vote_average by production method
final_movies %>%
  filter(production_method != "NA") %>%
  ggplot(aes(x = production_method, y = vote_average)) +
  geom_boxplot() +
  labs(title = "IMDb Score by Production Method", x = "Production Method", y = "Vote Average") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme_light() +
  theme(plot.title = element_text(size = 14, hjust = 0.5))

ggsave("figures/box_vote_by_production.png", width = 8, height = 6, dpi = 300)

# Boxplot of vote_average by rating
final_movies %>%
  filter(rating %in% c("G", "PG", "PG-13", "R", "NR")) %>%
  ggplot(aes(x = rating, y = vote_average)) +
  geom_boxplot() +
  labs(title = "IMDb Score by Rating", x = "Rating", y = "Vote Average") +
  theme_light() +
  theme(plot.title = element_text(size = 14, hjust = 0.5))

ggsave("figures/box_vote_by_rating.png", width = 8, height = 6, dpi = 300)

# Bar plot of genre frequency (after splitting listed_in with separate_rows)
final_movies %>%
  separate_rows(listed_in, sep = ",\\s*") %>%
  count(listed_in, sort = TRUE) %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(listed_in, -n), y = n)) +
  geom_col(fill = "steelblue") +
  labs(title = "Top 10 Genres on Netflix", x = "Genre", y = "Count") +
  theme_light() +
  theme(plot.title = element_text(size = 14, hjust = 0.5))

ggsave("figures/bar_genre_freq.png", width = 8, height = 6, dpi = 300)

# Bar plot of actor frequency (after splitting cast with separate_rows)
final_movies %>%
  separate_rows(cast, sep = ",\\s*") %>%
  count(cast, sort = TRUE) %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(cast, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Top 10 Actors on Netflix", x = "Actor", y = "Count") +
  theme_light() +
  theme(plot.title = element_text(size = 14, hjust = 0.5))

ggsave("figures/bar_actor_freq.png", width = 8, height = 6, dpi = 300)

# Scatter plot of budget vs. revenue
ggplot(final_movies, aes(x = production_budget_usd, y = revenue)) +
  geom_point(alpha = 0.6, color = "steelblue") +
  scale_x_log10() +
  scale_y_log10() +
  labs(title = "Production Budget vs Revenue", 
       x = "Production Budget (log scale)", 
       y = "Revenue (log scale)") +
  theme_light() +
  theme(plot.title = element_text(size = 14, hjust = 0.5))

ggsave("figures/scatter_budget_revenue.png", width = 8, height = 6, dpi = 300)

# Correlation heat map of select numeric variables
# Select and rename a few select numeric variables
cor_vars <- final_movies %>%
  select(
    Budget = production_budget_usd,
    Runtime = running_time_minutes,
    IMDb_Score = vote_average,
    Vote_Count = vote_count,
    Revenue = revenue,
    Popularity = popularity
  )

# Compute correlation matrix (excluding NA values)
cor_matrix <- cor(cor_vars, use = "complete.obs")

# Keep only correlations > 0.1 (there is only one near-zero negative corr)
cor_matrix_thresh <- cor_matrix
cor_matrix_thresh[cor_matrix_thresh < -0.1] <- NA

# Plot the correlation matrix
ggcorrplot(cor_matrix_thresh, 
           lab = TRUE, 
           type = "lower", 
           tl.cex = 10, 
           lab_size = 3,
           colors = c("white", "lightskyblue1", "steelblue4"),
           title = "Correlation Matrix of Key Movie Metrics") +
  theme_light() +
  theme(plot.title = element_text(hjust = 0.5, size = 14))

ggsave("figures/heatmap.png", width = 8, height = 6, dpi = 300)

# Number of releases per year
final_movies %>%
  count(release_year) %>%
  ggplot(aes(x = release_year, y = n)) +
  geom_line(color = "steelblue") +
  geom_point() +
  labs(title = "Number of Movies Released by Year", 
       x = "Release Year", y = "Count") +
  theme_light() +
  theme(plot.title = element_text(size = 14, hjust = 0.5))

ggsave("figures/year_released.png", width = 8, height = 6, dpi = 300)

# Extract year from date_netflix
final_movies <- final_movies %>%
  mutate(year_added = year(ymd(date_netflix)))

# Number of additions per year
final_movies %>%
  count(year_added) %>%
  ggplot(aes(x = year_added, y = n)) +
  geom_line(color = "steelblue") +
  geom_point() +
  labs(title = "Number of Movies Added to Netflix by Year", 
       x = "Year Added to Netflix", 
       y = "Count") +
  theme_light() +
  theme(plot.title = element_text(size = 14, hjust = 0.5))

ggsave("figures/year_added_netflix.png", width = 8, height = 6, dpi = 300)

### END OF PROGRAM ###