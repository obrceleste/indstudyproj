# Build
docker build --platform linux/amd64 . -t indstudy

# Run your custom image
docker run --rm -ti -e PASSWORD=yourpassword -v $(pwd):/home/rstudio/work -p 8787:8787 indstudy

