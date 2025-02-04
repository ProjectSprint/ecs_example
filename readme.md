# ProjectSprint ECS example
This repo contains example on how to interact with ProjectSprint ECS
## Prerequisite
- [make](https://www.google.com/search?q=install+make)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [AWS Copilot CLI](https://aws.github.io/copilot-cli/docs/getting-started/install/)
- AWS Account (given in the ProjectSprint Discord Server)

## Setup
- Make sure you already tell the administrator at the discord server about:
    - team app name
    - team services names

  To be allowed to be created by your account
- Set your environment variables
    ```bash
    export AWS_ACCESS_KEY=""
    export AWS_SECRET_KEY=""
    export AWS_REGION=""
    ```
- Set your copilot app
    ```bash
    # Run this only once
    copilot app init your-ecs-service-name
    ```
- Set your env (this is for creating a env called `staging`)
    ```bash
    # Run this only once, this command will not override `./copilot/environments/staging/manifest.yml` if it's exists
    copilot env init -n staging
    ```
    ```bash
    # Run this only once, or run in again if you change something in `./copilot/environments/staging/manifest.yml`
    copilot env deploy
    ```
- Set your app (this is for creating a service called `example-1`)
    ```bash
    # Run this only once, this command will not override `./copilot/example-1/manifest.yml` if it's exists
    copilot svc init -n example-1
    ```

## Push & Deploy
To compile, push and deploy all at once, you can run 
```bash
# Run each deploy
make deploy
```
Or see more available commands at the (makefile)[./makefile]
