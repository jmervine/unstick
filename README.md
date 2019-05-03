# Unstick

Simple HTTP Listener that removes a cookie and redirects, or not.

## Configs

All configurations are set via envrionment variables.

 env var      | description                           | default   | required
 ---          | ---                                   | ---       | ---
 COOKIE\_NAME | The name of the cookie to be deleted. | none      | yes
 REDIRECT     | The target location for redirection.  | none      | no
 PORT         | Port to listen on.                    | 8000      | no
 BIND         | The bind address.                     | 127.0.0.1 | no
