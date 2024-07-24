#!/bin/bash
set -euo pipefail

# Start NginX webserver if preauth headers are enabled
if [ "${RUNDECK_PREAUTH_ENABLED:-}" = "true" ]; then
    # if RUNDECK_OAUTH_ADMIN_GROUP is set, replace this in the admin.aclpolicy file
    if [ -n "${RUNDECK_OAUTH_ADMIN_GROUP:-}" ]; then
        sed -i "s/- group-get-by-environment/- ${RUNDECK_OAUTH_ADMIN_GROUP}/g" /home/rundeck/etc/admin.aclpolicy
    else
        sed -i "/- group-get-by-environment/d" /home/rundeck/etc/admin.aclpolicy
    fi
    sudo /etc/init.d/nginx start
    /usr/local/bin/oauth2-proxy \
        --provider="gitlab" \
        --redirect-url="${RUNDECK_GRAILS_URL}/oauth2/callback" \
        --client-id="${RUNDECK_OAUTH_CLIENT_ID}" \
        --client-secret="${RUNDECK_OAUTH_CLIENT_SECRET}" \
        --cookie-secret="${RUNDECK_OAUTH_COOKIE_SECRET}" \
        --oidc-issuer-url="${RUNDECK_OAUTH_OIDC_URL}" \
        --email-domain=* \
        --cookie-csrf-per-request=true \
        --cookie-csrf-expire=5m \
        --reverse-proxy=true \
        --session-store-type=cookie \
        --cookie-samesite=lax \
        --cookie-secure=false \
        --set-xauthrequest=true > /var/log/oauth2-proxy.log 2>&1 &
fi
