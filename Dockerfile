# Use a base image
FROM ubuntu:rolling

# Set the working directory inside the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Run a command when the container starts
CMD ["bash"]
