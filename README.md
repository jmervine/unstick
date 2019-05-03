# Unstick

Simple HTTP Listener that removes a cookie and redirects, or not.

## Configs

All configurations are set via envrionment variables.

 env var      | description                                        | default   | required
 ---          | ---                                                | ---       | ---
 COOKIE\_NAME | Semicolon seperated list of cookies to be deleted. | none      | yes
 REDIRECT     | The target location for redirection.               | none      | no
 PORT         | Port to listen on.                                 | 8000      | no
 BIND         | The bind address.                                  | 127.0.0.1 | no
 USE\_SSL     | Enable SSL Handling.                               | false     | no
 SERVER\_KEY  | SSL server.key file path. Requires USE\_SSL=true.  | none      | no
 SERVER\_CRT  | SSL server.crt file path. Requires USE\_SSL=true.  | none      | no
 DEBUG        | Enable debug messages.                             | false     | no

## Docker examples

```
docker run -e COOKIE_NAME=SESSION_AFFINITY jmervine/unstick:latest
```

**With SSL**
```
# Default self signed certs
docker run -e COOKIE_NAME=SESSION_AFFINITY -e USE_SSL=true -e PORT=443 jmervine/unstick:latest

# Custom certs
docker run -e COOKIE_NAME=SESSION_AFFINITY -e USE_SSL=true -e PORT=443 \
    -e SERVER_KEY=/usr/share/ssl/server.key -e SERVER_CRT=/usr/sahre/ssl/server.crt \
    -v /path/to/ssl:/usr/share/ssl \
    jmervine/unstick:latest
```
