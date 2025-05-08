FROM rocker/verse

RUN R -e "install.packages(c('tidyverse', 'lubridate', 'dplyr', 'stringr', 'ggplot2', 'pROC', 'ggcorrplot', 'janitor'), repos='http://cran.us.r-project.org')"

