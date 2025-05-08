### MAKEFILE ###
# Author: Celeste O'Brien

# Clean directory
clean:
	rm -rf data/* figures/*

# Clean data
data/cleaned_movie_data.csv: netflix_titles.csv top_movies.csv imdb.csv clean.R
	Rscript clean.R

# Figures
figures/hist_date_diff.png: data/cleaned_movie_data.csv ggplot.R
	Rscript ggplot.R

figures/box_vote_by_production.png: data/cleaned_movie_data.csv ggplot.R
	Rscript ggplot.R

figures/box_vote_by_rating.png: data/cleaned_movie_data.csv ggplot.R
	Rscript ggplot.R

figures/bar_genre_freq.png: data/cleaned_movie_data.csv ggplot.R
	Rscript ggplot.R

figures/bar_actor_freq.png: data/cleaned_movie_data.csv ggplot.R
	Rscript ggplot.R

figures/scatter_budget_revenue.png: data/cleaned_movie_data.csv ggplot.R
	Rscript ggplot.R

figures/heatmap.png: data/cleaned_movie_data.csv ggplot.R
	Rscript ggplot.R

figures/year_released.png: data/cleaned_movie_data.csv ggplot.R
	Rscript ggplot.R

figures/year_added_netflix.png: data/cleaned_movie_data.csv ggplot.R
	Rscript ggplot.R

figures/cumvar_scree.png: data/cleaned_movie_data.csv pca.R
	Rscript pca.R

figures/scatter_pca.png: data/cleaned_movie_data.csv pca.R
	Rscript pca.R

figures/clusers.png: data/cleaned_movie_data.csv pca.R
	Rscript pca.R

figures/density_by_budget.png: data/cleaned_movie_data.csv pca.R
	Rscript pca.R

figures/density_by_vote.png: data/cleaned_movie_data.csv pca.R
	Rscript pca.R

figures/density_by_revenue.png: data/cleaned_movie_data.csv pca.R
	Rscript pca.R

figures/roc_curve.png: data/cleaned_movie_data.csv roc.R
	Rscript roc.R

# Report generation
report.pdf: figures/hist_date_diff.png figures/box_vote_by_production.png figures/box_vote_by_rating.png \
	figures/bar_genre_freq.png figures/bar_actor_freq.png figures/scatter_budget_revenue.png \
	figures/heatmap.png figures/year_released.png figures/year_added_netflix.png \
	figures/cumvar_scree.png figures/scatter_pca.png figures/clusers.png \
	figures/density_by_budget.png figures/density_by_vote.png figures/density_by_revenue.png \
	figures/roc_curve.png data/cleaned_movie_data.csv
	R -e "rmarkdown::render('report.Rmd', output_format = 'pdf_document')"

.PHONY: clean