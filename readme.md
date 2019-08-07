# Spring Boot Service Template

This is a Spring Boot application minimally configured as a REST service.
It's intended as a starting point, to speed up the creation of new applications.

## Running the service

From the project root, run `./gradlew bootRun`

The running version may be verified at the Actuator Info endpoint: 
[`http://localhost:5150/actuator/info`](http://localhost:5150/actuator/info).

## Example controller

_To be documented_

## Build automation

A number of files have been added to support build and deployment automation.

- [`Dockerfile`](./Dockerfile): Describes a Docker container into which the application will be deployed.
- [`docker-scripts/*`](./docker-scripts): 3 scripts to: build and tag Docker images, log in to the Amazon ECR, and push tagged images to it.
- [`buildspec.yml`](./buildspec.yml): Instructions for building the application, used by AWS CodeBuild.

## New section just to cause a deployment
