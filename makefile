# Required environment variables check
REQUIRED_VARS := AWS_ACCESS_KEY AWS_SECRET_KEY AWS_REGION
$(foreach var,$(REQUIRED_VARS),$(if $(value $(var)),,$(error $(var) is undefined)))

# AWS CLI configuration
export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY)
export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_KEY)
export AWS_DEFAULT_REGION=$(AWS_REGION)

# Get git commit hash for tagging
COMMIT_HASH := $(shell git rev-parse --short HEAD)

# Build configuration
BINARY_NAME=echo-server
GOOS=linux
GOARCH=arm64

.PHONY: build
build:
	@echo "Building application..."
	CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o $(BINARY_NAME)

.PHONY: docker
docker: build
	@echo "Building Docker image..."
	docker build -t echo-server:$(COMMIT_HASH) .

.PHONY: deploy
deploy: docker
	@echo "Deploying with Copilot..."
	copilot deploy --tag $(COMMIT_HASH)

.PHONY: status
status:
	@echo "Checking deployment status..."
	copilot svc status

.PHONY: logs
logs:
	@echo "Fetching logs..."
	copilot svc logs

.PHONY: rollback
rollback:
	@echo "Rolling back to previous deployment..."
	copilot svc rollback

.PHONY: clean
clean:
	@echo "Cleaning up..."
	rm -f $(BINARY_NAME)

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build        - Build the application locally"
	@echo "  docker       - Build Docker image"
	@echo "  deploy       - Build and deploy the application"
	@echo "  status       - Check deployment status"
	@echo "  logs         - View service logs"
	@echo "  rollback     - Rollback to previous deployment"
	@echo "  clean        - Clean up build artifacts"
	@echo "  help         - Show this help message"
