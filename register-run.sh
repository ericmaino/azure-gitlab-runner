#!/bin/bash
X_SHELL="/usr/bin/dumb-init /entrypoint"
_LOCKED="true"
_UNTAGGED="true"

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

if [ -n "${AGENT_LOCKED}" ]; then
    _LOCKED=${AGENT_LOCKED}
fi

if [ -n "${ALLOW_UNTAGGED}" ]; then
    _UNTAGGED=${ALLOW_UNTAGGED}
fi

if [ -n "${GITLAB_CLIENT_KEY}" ]; then
    echo "${GITLAB_CLIENT_KEY}" > /etc/gitlab-runner/client-key.pem
    export CI_SERVER_TLS_KEY_FILE="/etc/gitlab-runner/client-key.pem"
fi  

if [ -n "${GITLAB_CRT}" ]; then
    echo "${GITLAB_CRT}" > /etc/gitlab-runner/gitlab-crt.pem
    export CI_SERVER_TLS_CERT_FILE="/etc/gitlab-runner/gitlab-crt.pem"
fi

if [ ! -f ~/REGISTERED ]; then
    echo . > ~/REGISTERED
    ${X_SHELL} register --non-interactive \
    --executor "shell" \
    --url "${GITLAB_URL}" \
    --registration-token "${TOKEN}" \
    --description "${DESCRIPTION}" \
    --tag-list "${TAG_LIST}" \
    --run-untagged="${_UNTAGGED}" \
    --locked="${_LOCKED}" 
fi

${X_SHELL} run --user=gitlab-runner --working-directory=/home/gitlab-runner