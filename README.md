# docker-github-runner

Docker image with Github actions runner

## Envvars needed to run
`GITHUB_PAT=<token to authenticate with to register the runner>`

`GITHUB_REPO=<the repo you are going to use the runner with eg. navikt/your-repo-here>`

## Example of NAIS deployment
[NAIS application definition](./self-hosted-runner-nais.yaml)

## Build and release image on GPR

Push a new numeric tag
