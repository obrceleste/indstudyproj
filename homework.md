project location: /Users/celesteobrien/indstudy/project


Dockerfile contents: 
FROM alectries/univr
RUN echo Hello World


start.sh contents:
# Build the Docker image
docker build . -t indstudy 
# Run the Docker container
docker run --rm -ti -e PASSWORD=yourpassword -v $pwd:/home/rstudio/work -p 8787:8787 rocker/rstudio


README.md contents: 
For my project, I intend to merge two data sets to analyze the characteristics
of top Netflix movies. One of the data sets contains budget, sales, and production
data, while the other contains Netflix-specific information, including when the 
film was added to Netflix, the genres it is listed under, and cast details. My
goal is to examine how production and financial factors influence may influence 
the length of time after the film's release before it is added to Netflix. I
also intend to identify and analyze trends in budget allocation, genre success,
casting choices, etc. I would also like to find data on the film's critical success
and Netflix viewer ratings, if possible.


Rules for our evaluator to explain result:
Like an ENV variable, aliases in bash replace some input with something else and are often used to make typing
some command easier. The command "ls -a" outputs all files stored in the wd, including hidden files (the point
of the "-a"). When you assign "ls -a" to the alias "la", typing "la" in the terminal also outputs all files
stored in the wd including hidden files, because "la" is essentially replaced by whatever it was defined as
("ls -a") before it is run. Similarly, an ENV variable is a value that is stored somewhere and is an easier,
quicker way to get the value that you want. The ENV variable $HOME returns the home directory and is quicker
to type in the terminal than listing the actual path of the home directory. When you call "$PATH" in your
terminal command line, the variable is replaced by its stored value when the command is executed.
