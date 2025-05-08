### Author: Celeste O'Brien
### Date: May 8, 2025
### Course: BIOS 611 Independent Study

## Purpose of Project
This project merged three data sets containing information on movies with the intention to analyze
the characteristics of top Netflix movies. 

## Data Sources
Netflix: https://www.kaggle.com/datasets/anandshaw2001/netflix-movies-and-tv-shows?resource=download
Movies: https://www.kaggle.com/datasets/michaelmatta0/movies-ultimate-metrics-features-and-metadata
IMDB: https://www.kaggle.com/datasets/anandshaw2001/imdb-data?resource=download

## Analysis
The code provided performs the following tasks:
	- clean.R: Clean and merge the three data sets for upcoming analysis
	- ggplot.R: Explore the data with basic visualizations
	- pca.R: Perform Principal Component Analysis (PCA) on selected numeric features
		- Use the first two principal components for K-means clustering
		- Visualize the variance explained and clusters
		- Analyze how movie attributes vary across clusters
	- roc.R: Fit a logistic regression model
		- Predict whether a movie is commercially successful based on metrics
		- Visualize the model's performance using an ROC curve and AUC

## Usage

#### 1. Ensure you have access to Docker
If you do not have access to Docker, visit https://www.docker.com/. If you do have Docker available, open the application.

#### 2. Clone the GitHub Repository
Using your Docker terminal, run these lines in order:

```bash
git clone https://github.com/obrceleste/indstudyproj.git
cd indstudyproject
```

This will clone the GitHub repository from https://github.com/obrceleste/indstudyproj.git and move into the project directory.

#### 3. Start the Docker Container
Using your Docker terminal, run this line:

```bash
./start.sh
```

#### 4. Open RStudio Server in Browser
Open your browser and type the following into your address bar:

```bash
http://localhost:8787
```

Login to RStudio using the following credentials:
	username: rstudio
	password: yourpassword

#### 5. Create the Report
Using your RStudio terminal, run the following code:

```bash
make clean
make report.pdf
```

This will automatically execute the code and generate the final report.


# FIN
