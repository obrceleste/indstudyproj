FROM rocker/verse

# Install TinyTeX
RUN R -e "install.packages('tinytex'); tinytex::install_tinytex()"

# Install R packages
RUN R -e "install.packages(c('tidyverse', 'lubridate', 'dplyr', 'stringr', 'ggplot2', 'pROC', 'ggcorrplot', 'janitor'), repos='http://cran.rstudio.com')"

