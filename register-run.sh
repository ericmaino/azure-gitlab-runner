#!/bin/bash
X_SHELL="/usr/bin/dumb-init /entrypoint"

if [ -z "${TOKEN}" ]; then
    echo "ERROR: TOKEN has not been set"
    exit 1
fi

if [ -z "${DESCRIPTION}" ]; then
    echo "ERROR: DESCRIPTION has not been set"
    exit 1
fi

if [ -z "${GITLAB_URL}" ]; then
    echo "ERROR: GITLAB_URL has not been set"
    exit 1
fi

if [ -z "${TAG_LIST}" ]; then
    echo "ERROR: TAG_LIST has not been set"
    exit 1
fi

if [ ! -f ~/REGISTERED ]; then
    echo . > ~/REGISTERED
    ${X_SHELL} register --non-interactive \
    --executor "shell" \
    --url "${GITLAB_URL}" \
    --registration-token "${TOKEN}" \
    --description "${DESCRIPTION}" \
    --tag-list "${TAG_LIST}" \
    --run-untagged="false" \
    --locked="false" 
fi

${X_SHELL} run --user=gitlab-runner --working-directory=/home/gitlab-runner