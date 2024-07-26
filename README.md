# agnost-gitops base helm chart

[agnost-gitops](https://github.com/cloud-agnost/agnost-gitops) is an open source GitOps platform running on Kubernetes clusters

![Version: 0.0.17](https://img.shields.io/badge/Version-0.0.17-informational?style=flat-square) ![AppVersion: v0.0.12](https://img.shields.io/badge/AppVersion-v0.0.12-informational?style=flat-square)

This chart bootstraps an agnost-gitops deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../webhook | agnost-webhook | 1.0.0 |
| https://charts.jetstack.io | cert-manager | 1.14.5 |
| https://kubernetes.github.io/ingress-nginx | ingress-nginx | 4.10.1 |

## Get Repo Info

```console
helm repo add agnost-gitops https://cloud-agnost.github.io/agnost-gitops-charts/
helm repo update
```

## Install Chart

**Important:** only helm3 is supported

```console
helm install [RELEASE_NAME] agnost-gitops/base
```

The command deploys agnost-gitops on the Kubernetes cluster in the default configuration.

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Uninstall Chart

```console
helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Upgrading Chart

```console
helm upgrade [RELEASE_NAME] [CHART] --install
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). To see all configurable options with detailed comments, visit the chart's [values.yaml](https://github.com/cloud-agnost/agnost-gitops-charts/blob/main/base/values.yaml), or run these configuration commands:

```console
helm show values agnost-gitops/base
```

## Minikube Installation

Create a Minikube cluster with `ingress-nginx` addon enabled, and install the chart:

```bash
minikube start --cpus=4 --memory=8192

helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace
```

> Please refer to [Minikube Documentation](https://minikube.sigs.k8s.io/docs/start/) for more information.

## GKE Installation (Google Kubernetes Engine)

This chart installs `ingress-nginx` by default. If you already have it running on your cluster, you can add `--set ingress-nginx.enabled=false` parameter:

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  --set ingress-nginx.enabled=false
```

Otherwise, install it with default options:

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace
```

> Please refer to [GCP documentation](https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters) to learn more about GKE cluster creation and maintenance.

## EKS Installation (AWS Elastic Kubernetes Service)

This chart installs `ingress-nginx` by default. If you already have it running on your cluster, you can add `--set ingress-nginx.enabled=false` parameter:

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  --set ingress-nginx.enabled=false
```

Otherwise, please use the custom values file for EKS:

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  -f https://raw.githubusercontent.com/cloud-agnost/agnost-gitops-charts/main/custom-values/eks-values.yaml
```

> Please refer to [AWS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html) to learn more about EKS cluster creation and maintenance.

## AKS Installation (Azure Kubernetes Service)

This chart installs `ingress-nginx` by default. If you already have it running on your cluster, you can add `--set ingress-nginx.enabled=false` parameter:

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  --set ingress-nginx.enabled=false
```

Otherwise, please use the custom values file for AKS:

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  -f https://raw.githubusercontent.com/cloud-agnost/agnost-gitops-charts/main/custom-values/aks-values.yaml
```

> Please refer to [Azure Documentation](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli) to learn more about AKS cluster creation and maintenance.

## DOKS Installation (Digital Ocean Kubernetes Service)

This chart installs `ingress-nginx` by default. If you already have it running on your cluster, you can add `--set ingress-nginx.enabled=false` parameter:

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  --set ingress-nginx.enabled=false
```

Otherwise, please use the custom values file for DOKS:

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  -f https://raw.githubusercontent.com/cloud-agnost/agnost-gitops-charts/main/custom-values/doks-values.yaml
```

> Please refer to [Digital Ocean Documentation](https://docs.digitalocean.com/products/kubernetes/how-to/create-clusters/) to learn more about DOKS cluster creation and maintenance.

## Post Installation

As a next step, you need to complete your setup by creating your user account through Agnost Studio.

>To launch Agnost Studio, type the URL or IP address of your cluster on your browser (e.g., http(s)://<your cluster URL or IP>/studio).
>
>If you have installed Agnost locally you can access Agnost Studio at http://localhost/studio

## Accessing Services

If you need to access to the services running on Kubernetes, you need to run `kubectl port-forward` command.

> [!WARNING]
>
> Below commands run on the `agnost` namespace, if you installed the chart to other namespace, then you should update `-n <NAMESPACE>`

### MongoDB

```bash
# you can access to the database from `localhost:27017` after running this:
kubectl port-forward mongodb-0 27017:27017 -n agnost

# username:
kubectl get secret mongodb -o jsonpath='{.data.username}' -n agnost | base64 -d

# password:
kubectl get secret mongodb -o jsonpath='{.data.password}' -n agnost | base64 -d
```

### Redis

```bash
# you can access to the database from `localhost:6379` after running this:
kubectl port-forward svc/redis 6379:6379 -n agnost

# password:
kubectl get secret redis -o jsonpath='{.data.password}' -n agnost | base64 -d
```

### MinIO Console

```bash
# http://localhost:9001
kubectl port-forward svc/minio-storage-console 9001:9001 -n agnost

# username:
kubectl get secret minio -o jsonpath='{.data.rootUser}' -n agnost | base64 -d

# password:
kubectl get secret minio -o jsonpath='{.data.rootPassword}' -n agnost | base64 -d
```

### Zot Registry

```bash
# http://localhost:5000
kubectl port-forward svc/zot 5000:5000 -n agnost
```

### Tekton Pipelines

```bash
# http://localhost:9097/#/taskruns
kubectl port-forward svc/tekton-dashboard -n tekton-pipelines 9097:909 -n agnost
```

More information can be found [here](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress-nginx.enabled | bool | `true` | Install ingress-nginx |
| ingress-nginx.controller.autoscaling.enabled | bool | `true` | Enable/Disable autoscaling for ingress-nginx |
| ingress-nginx.controller.autoscaling.minReplicas | int | `1` | Minimum ingress-nginx replicas when autoscaling is enabled |
| ingress-nginx.controller.autoscaling.maxReplicas | int | `5` | Maximum ingress-nginx replicas when autoscaling is enabled |
| ingress-nginx.controller.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU Utilization for ingress-nginx replicas when autoscaling is enabled |
| ingress-nginx.controller.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory Utilization for ingress-nginx replicas when autoscaling is enabled |
| cert-manager.enabled | bool | `true` | Install cert-manager |
| cert-manager.namespace | string | `"cert-manager"` | Namespace for cert-manager. Even if you do not install the cert-manager through Agnost helm chart, please make sure that the cert-manager is running in the same namespace |
| cert-manager.fullnameOverride | string | `"cert-manager"` | Do not allow cert-manager resource names to be prefixed with the release name |
| cert-manager.startupapicheck.enabled | bool | `false` | No need for pre checks |
| agnost-webhook.nameOverride | string | `""` | Please do not change nameOverride parameter value of the agnost-webhook |
| agnost-webhook.fullnameOverride | string | `"agnost-webhook"` | Please do not change fullnameOverride parameter value of the agnost-webhook |
| agnost-webhook.certManager.namespace | string | `"cert-manager"` | The namespace cert-manager is running in, this is used to allow cert-manager to discover the agnost DNS01 solver webhook |
| agnost-webhook.certManager.serviceAccountName | string | `"cert-manager"` | The name of the service account of the cert-manager, this is used to allow cert-manager to discover the agnost DNS01 solver webhook |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
