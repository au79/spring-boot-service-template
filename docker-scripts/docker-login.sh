#!/usr/bin/env bash

if [[ -z "${AWS_DEFAULT_REGION}" ]]
then
    echo "The AWS_DEFAULT_REGION environment variable must be set to a valid region."
    exit 1
fi

echo Logging in to Amazon ECR in region: \"${AWS_DEFAULT_REGION}\"
$(aws ecr get-login --no-include-email --region "${AWS_DEFAULT_REGION}") 2> /dev/null
LOGIN_EXIT_STATUS=$?
if [[ ${LOGIN_EXIT_STATUS} -ne 0 ]]
then
    echo LOGIN FAILED!
fi
