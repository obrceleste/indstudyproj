# Build the Docker image
docker build . -t indstudy 

# Run the Docker container
docker run -it indstudy /bin/bash
