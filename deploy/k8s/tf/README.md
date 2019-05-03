# Deploy to Kube via Terraform

```
terraform init
terraform deploy
```

### Or include as a module

```
module "unstick" {
  source = "https://github.com/jmervine/unstick//deploy/k8s/tf"

  cookie_name = "MY_COOKIE_NAME"
  redirect    = "https://www.example.com/"

  # Optional new namespace.
  make_namespace = "1"
  namespace      = "mynamespace"
}
```

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cookie\_name | The name of the cookie to be deleted. | string | `"SESSION_AFFINITY"` | no |
| make\_namespace | Create namespace if set to 1 | string | `"0"` | no |
| namespace | Namespace to deploy to. | string | `"default"` | no |
| redirect | The name of the cookie to be deleted. Empty doesn't redirect. | string | `""` | no |
| service\_cluster\_ip | The IP address of the service. See Kube docs. | string | `"None"` | no |
| service\_type | Determines how the service is exposed. See Kube docs. | string | `"ClusterIP"` | no |
| version | Unstick image version tag. | string | `"latest"` | no |

