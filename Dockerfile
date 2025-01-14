# Use a base image with Python 3.11.7
FROM python:3.11.7-slim as build

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy project files into the container
COPY . /app

# Install Python build tools
RUN pip install --no-cache-dir build

# Build the Python package
RUN python -m build

# Use a final step to copy the dist folder to an output location
RUN mkdir -p /output && cp -r dist /output

FROM scratch
COPY --from=build /app/dist /
