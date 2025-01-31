# Build the Docker image
docker build . -t indstudy 

# Run the Docker container
docker run -e PASSWORD=yourpassword -v $(pwd):/home/rstudio/work -p 8787:8787 -it indstudy
