# rundeck-oauth
Provide a Rundeck CE container which allows authentication with OAuth.
This will use the open source Rundeck CE with [OAuth-Proxy](https://github.com/oauth2-proxy/oauth2-proxy) and NGinx to
make OIDC, OAuth with Rundeck possible.

## Build Locally

```sh
    docker build -t rundeck-oauth rundeck/.
```

## Test Locally

Start minimal

```sh
    docker run --rm --name rundeck-oauth -p 4440:4440 -e RUNDECK_GRAILS_URL=http://localhost:4440 rundeck-oauth
```

Get into the container

```sh
    docker exec -it rundeck-outh bash
```

## Preauthenticated Mode

```sh
    docker pull ghcr.io/geraldhansen/rundeck-oauth:latest  
    docker run -it --rm --name rundeck-oauth -p 8080:80
    -e RUNDECK_GRAILS_URL=http://localhost:8080
    -e RUNDECK_PREAUTH_ENABLED=true
    -e RUNDECK_OAUTH_CLIENT_ID="xxxxxx"
    -e RUNDECK_OAUTH_CLIENT_SECRET="gloas-xxxx"
    -e RUNDECK_OAUTH_COOKIE_SECRET="xxxx"
    -e RUNDECK_OAUTH_OIDC_URL="<url OIDC provider url>"
    -e RUNDECK_OAUTH_ADMIN_GROUP="<your group which will be the admin>"
    ghcr.io/geraldhansen/rundeck-oauth
```

