project location: /Users/celesteobrien/indstudy/project


Dockerfile contents: 
FROM alectries/univr
RUN echo Hello World


start.sh contents:
# Build the Docker image
docker build . -t indstudy 
# Run the Docker container
docker run -it indstudy /bin/bash


README.md contents: For my project, I intend to . . .


Rules for our evaluator to explain result: _____
