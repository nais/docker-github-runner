# docker-github-runner

Docker image with Github actions runner

:warning: **Don't use this on public repos** :warning:  
[Self-hosted runner security with public repositories](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners#self-hosted-runner-security-with-public-repositories)

## Envvars needed to run
`GITHUB_PAT=<token to authenticate with to register the runner>`

`GITHUB_REPO=<the repo you are going to use the runner with eg. navikt/your-repo-here>`

## Example of NAIS deployment
[NAIS application definition](./example/self-hosted-runner-nais.yaml)

## Build and release image on GPR

Push a new numeric tag
