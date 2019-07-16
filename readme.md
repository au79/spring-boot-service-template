# Spring Boot Service Template

This is a Spring Boot application minimally configured as a REST service.
It's intended as a starting point, to speed up the creation of new applications.

## Build automation

A number of files have been added to support build and deployment automation.

- [`Dockerfile`](./Dockerfile): Describes a Docker container into which the application will be deployed.
- [`docker-scripts/*`](./docker-scripts): 3 scripts to: build and tag Docker images, log in to the Amazon ECR, and push tagged images to it.
- [`buildspec.yml`](./buildspec.yml): Instructions for building the application, used by AWS CodeBuild.


