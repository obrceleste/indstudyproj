# Build the Docker image
docker build -t biosproject .

# Run the Docker container
docker run -it biosproject /bin/bash
