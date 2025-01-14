# Variables
IMAGE_NAME = python-package-builder
OUTPUT_DIR = output

# Default target
all: build

# Build target
build:
	docker buildx build --progress=plain --output type=local,dest=$(OUTPUT_DIR) -t $(IMAGE_NAME) .

# Clean target to remove the output directory
clean:
	rm -rf $(OUTPUT_DIR) && mkdir $(OUTPUT_DIR) && touch $(OUTPUT_DIR)/keep
