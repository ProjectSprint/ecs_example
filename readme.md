# ProjectSprint ECR & ECS Example
This repo contains example on how to interact with ProjectSprint ECR & ECS
## Prerequisite
- [make](https://www.google.com/search?q=install+make)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- AWS Account (given in the ProjectSprint Discord Server)

## Setup
- Set your environment variables
    ```bash
    export ECR_ENDPOINT=""
    export ECR_NAME=""
    export ECS_CLUSTER_NAME=""
    export ECS_SERVICE_NAME=""
    export AWS_ACCESS_KEY=""
    export AWS_SECRET_KEY=""
    export AWS_REGION=""
    ```
- Check is your environment variables ready by running `make check-env`


## Push & Deploy
To compile, push and deploy all at once, you can run `make all`
Or, you can run it one by one, sequentionally by:
```bash
# compile and build the docker image locally
make build
```
```bash
# authenticate to AWS & push the image to the AWS ECR while:
# - removing the previous `latest` tag that already exists in ECR
# - push the newest image and give the `latest` tag
make push
```
```bash
# force AWS ECS to take new image from the ECR and deploy it
make build
```
