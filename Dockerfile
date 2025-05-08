FROM rocker/verse

# Install TinyTeX
RUN R -e "install.packages('tinytex'); tinytex::install_tinytex()"

ENV R_LIBS_USER=/home/rstudio/work/Rlibs

# Install R packages
RUN mkdir -p /home/rstudio/work/Rlibs && \
    Rscript -e "install.packages(c('tidyverse', 'lubridate', 'dplyr', 'stringr', 'ggplot2', 'pROC', 'ggcorrplot', 'janitor'), repos='http://cran.rstudio.com')"


# Install R packages
# RUN R -e "install.packages(c('tidyverse', 'lubridate', 'dplyr', 'stringr', 'ggplot2', 'pROC', 'ggcorrplot', 'janitor'), repos='http://cran.rstudio.com')"

