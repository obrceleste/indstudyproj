### CLEAN ###
# Author: Celeste O'Brien

# I know this is bad practice, but a quick fix is a quick fix
install.packages("tidyverse")
install.packages("lubridate")
install.packages("janitor")

# Load required libraries
library(tidyverse)
library(lubridate)
library(janitor)

# Read and clean Netflix, IMDB, and Movies data
netflix <- read_csv("netflix_titles.csv") %>%
  clean_names() %>%
  filter(!is.na(date_added) & !is.na(release_year)) %>%
  mutate(
    date_netflix = mdy(date_added),
    date_released = as.Date(paste0(release_year, "-01-01")),
    date_diff = round(difftime(date_netflix, date_released, units = "weeks"))
  )

top_movies <- read_csv("top_movies.csv") %>%
  clean_names()

imdb <- read_csv("imdb.csv") %>%
  clean_names() %>%
  mutate(release_date = as.Date(release_date, format = "%m/%d/%Y"))

# Merge datasets
# Standardize title strings for merging (preserving original case elsewhere)
netflix <- netflix %>%
  mutate(title_clean = trimws(tolower(title)))

top_movies <- top_movies %>%
  mutate(movie_name_clean = trimws(tolower(movie_name)))

imdb <- imdb %>%
  mutate(title_clean = trimws(tolower(title)))

# Merge in steps
merged1 <- merge(netflix, top_movies, by.x = "title_clean", by.y = "movie_name_clean")
final_merged <- merge(merged1, imdb, by = "title_clean")

# Drop the duplicate title_clean column
final_merged <- final_merged %>%
  select(-title_clean)

# De-duplicate by IMDb vote count
final_cleaned <- final_merged %>%
  group_by(title.x) %>%
  slice_max(order_by = vote_count, n = 1, with_ties = FALSE) %>%
  ungroup()

# Filter to only include movies (drop TV shows)
final_movies <- final_cleaned %>%
  filter(type == "Movie")

# Check for duplicate titles - there are none!
final_movies %>%
  count(title.x) %>%
  filter(n > 1) %>%
  arrange(desc(n)) %>%
  print()

# Check missing values
missing_summary <- final_movies %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(cols = everything(), names_to = "column", values_to = "na_count") %>%
  filter(na_count > 0)

print(missing_summary, n = Inf, width = Inf)

# Drop unnecessary or redundant columns, or those with significant missing
final_movies <- final_movies %>%
  select(
    -c(
      title.y, id.x, id.y, release_date.x, release_date.y, show_id, type,
      keywords.x, keywords.y, production_countries.x, production_countries.y,
      genres, genre, franchise, est_domestic_blu_ray_sales_usd, duration,
      est_domestic_dvd_sales_usd, international_releases, runtime, mpaa_rating,
      total_est_domestic_video_sales_usd, theater_counts, legs, movie_name,
      infl_adj_dom_bo_usd, international_box_office_usd, adult, budget,
      worldwide_box_office_usd, opening_weekend_usd, video_release,
      tagline, production_financing_companies, description, overview,
      domestic_releases, status, domestic_share_percentage,imdb_id,
      spoken_languages, original_title, movie_url, original_language
    )
  ) %>%
  rename(title = title.x)

# Write cleaned data to file for analysis steps
write_csv(final_movies, "cleaned_movie_data.csv")

### END OF PROGRAM ###