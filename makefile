# Required environment variables check
REQUIRED_VARS := AWS_ACCESS_KEY AWS_SECRET_KEY AWS_REGION
$(foreach var,$(REQUIRED_VARS),$(if $(value $(var)),,$(error $(var) is undefined)))

# AWS CLI configuration
export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY)
export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_KEY)
export AWS_DEFAULT_REGION=$(AWS_REGION)

# Get git commit hash for tagging
COMMIT_HASH := $(shell git rev-parse --short HEAD)

.PHONY: deploy
deploy:
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

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  init         - Initialize Copilot app (run once)"
	@echo "  deploy       - Deploy the application"
	@echo "  status       - Check deployment status"
	@echo "  logs         - View service logs"
	@echo "  rollback     - Rollback to previous deployment"
	@echo "  help         - Show this help message"
