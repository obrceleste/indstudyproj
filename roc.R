### ROC CURVE ###
# Author: Celeste O'Brien

# I know this is bad practice, but a quick fix is a quick fix
install.packages("tidyverse")
install.packages("pROC")
install.packages("ggplot2")

# Load required libraries
library(pROC)
library(ggplot2)
library(tidyverse)

# Read in data set
final_movies <- read.csv("cleaned_movie_data.csv")

# Create binary outcome: 1 if vote_average >= 7, else 0
final_movies$critically_successful <- ifelse(final_movies$vote_average >= 7, 1, 0)

# Select relevant predictors and remove NAs
model_data <- final_movies %>%
  select(critically_successful, production_budget_usd, domestic_gross_usd,
         worldwide_gross_usd, running_time_minutes, popularity, revenue) %>%
  drop_na()

# Fit logistic regression
logit_model <- glm(critically_successful ~ ., data = model_data, family = binomial)

# Get predicted probabilities
model_data$predicted_prob <- predict(logit_model, type = "response")

# Generate ROC object
roc_obj <- roc(model_data$critically_successful, model_data$predicted_prob)

# Convert ROC object to a data frame
roc_df <- data.frame(
  FalsePositiveRate = 1 - roc_obj$specificities,
  TruePositiveRate = roc_obj$sensitivities
)

# Plot ROC curve
ggplot(roc_df, aes(x = FalsePositiveRate, y = TruePositiveRate)) +
  geom_line(color = "steelblue", size = 1.2) +
  geom_abline(linetype = "dashed", color = "gray") +
  coord_equal() +
  labs(
    title = "ROC Curve for Predicting Critical Success of Netflix Movies",
    subtitle = paste("AUC =", round(auc(roc_obj), 3)),
    x = "False Positive Rate (1 - Specificity)",
    y = "True Positive Rate (Sensitivity)"
  ) +
  theme_light() +
  theme(
    plot.title = element_text(size = 14, hjust = 0.5),  
    plot.subtitle = element_text(size = 12, hjust = 0.5) 
  )

# Save plot
ggsave("figures/roc_curve.png", width = 8, height = 6, dpi = 300)

### END OF PROGRAM ###