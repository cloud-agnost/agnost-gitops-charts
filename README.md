# agnost-gitops base helm chart

[agnost-gitops](https://github.com/cloud-agnost/agnost-gitops) is an open source GitOps platform running on Kubernetes clusters. It provides a complete CD solution for building, deploying, and managing applications. In short, you connect your [GitHub](https://github.com), [GitLab](https://gitlab.com) or [Bitbucket](https://bitbucket.com) repository and Agnost takes care of building and deploying your app to your Kubernetes cluster when you push new code.

![Version: 0.1.22](https://img.shields.io/badge/Version-0.1.22-informational?style=flat-square) ![AppVersion: v0.0.43](https://img.shields.io/badge/AppVersion-v0.0.43-informational?style=flat-square)

This chart bootstraps an agnost-gitops deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

This chart will install following components together with Agnost software:

- **MongoDB** to store Agnost configuration, your container definitions and git repository settings
- **Redis** to use as a cache to speed up data retrieval and authentication
- **MinIO** to store data on S3 compatible buckets
- **Registry** to store container images and other data in an OCI Registry
- **Tekton Pipelines** as CD pipeline to build, push, and deploy your applications.
- **NGINX Ingress Controller** to use as Ingress controller. You can skip installing this if you already have `ingress-nginx` running in the cluster. However, you need to specify the existing ingress controller installation namespace in helm values.yaml file. See [NGINX Ingress Controller troubleshooting](#ingress-nginx) section for more details.
- **Cert Manager** to generate TLS certificates for your domain. You can skip installing this if you already have `cert-manager` running in the cluster. However, you need to overwrite several default values in values.yaml file. See [Cert Manager troubleshooting](#cert-manager) section for more details.

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../webhook | agnost-webhook | 1.0.0 |
| https://charts.jetstack.io | cert-manager | 1.14.5 |
| https://kubernetes.github.io/ingress-nginx | ingress-nginx | 4.10.1 |

To install and run Agnost on your Kubernetes cluster, you need and up an running Kubernetes cluster. We highly recommend at least 4CPUs and 8GB of memory for the cluster. As you add more containers and connect your repositories, you may need more resources to build, deploy and run your applications.

Please make sure that you have also installed [Helm](https://helm.sh/docs/intro/install/) and [kubectl](https://kubernetes.io/docs/tasks/tools/) command line tool.

## Get Agnost Chart
The first step is to add the Agnost Helm repository to your local Helm client. You can do this by running the following command:

```console
helm repo add agnost-gitops https://cloud-agnost.github.io/agnost-gitops-charts/
helm repo update
```

## Install Chart
The next step is to install the Agnost chart on your Kubernetes cluster. You can do this by running the following command.

**Important:** only helm3 is supported

```console
helm upgrade --install [RELEASE_NAME] agnost-gitops/base \
  --namespace agnost --create-namespace
```

The command deploys agnost-gitops on the Kubernetes cluster in the default configuration.

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Setting up Agnost
You can check the status of the installtion by running the following command. If all the pods are running, you can proceed to setting up the Agnost. It may take 5-10 minutes for all the pods to be up and running.

```console
kubectl get pods -n agnost
```

Please note that if you have installed agnost to a different namespace, you need to replace `agnost` with your namespace.

Following installation, you need to complete your setup by creating your user account through Agnost Studio. To launch Agnost Studio, type the URL or IP address of your cluster on your browser (e.g., http(s)://<your cluster URL or IP>/studio). If you have installed Agnost locally you can access Agnost Studio at http://localhost/studio

Please note that besides the owner of the Agnost cluster, other users cannot create their own accounts. The owner of the Agnost cluster needs to specifically create invitation links for other users to join the cluster through Agnost Studio.

## Uninstall Chart

```bash
helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Upgrading Chart

```bash
helm upgrade [RELEASE_NAME] [CHART] --install
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). To see all configurable options with detailed comments, visit the chart's [values.yaml](https://github.com/cloud-agnost/agnost-gitops-charts/blob/main/base/values.yaml), or run these configuration commands:

```bash
helm show values agnost-gitops/base
```

### Minikube Installation

Create a Minikube cluster, and install the chart:

```bash
minikube start --cpus=4 --memory=8192

helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace
```

> Please refer to [Minikube Documentation](https://minikube.sigs.k8s.io/docs/start/) for more information.

### GKE Installation (Google Kubernetes Engine)

This chart installs `ingress-nginx` by default.

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace
```

 If you already have `ingress-nginx` running on your cluster, you can add `--set ingress-nginx.enabled=false` parameter. Please note that you need to specify the existing ingress controller installation namespace in helm values.yaml file under "ingress-nginx" and "namespaceOverride".

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  --set ingress-nginx.enabled=false
```

> Please refer to [GCP documentation](https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters) to learn more about GKE cluster creation and maintenance.

### EKS Installation (AWS Elastic Kubernetes Service)

This chart installs `ingress-nginx` by default.

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  -f https://raw.githubusercontent.com/cloud-agnost/agnost-gitops-charts/main/custom-values/eks-values.yaml
```

If you already have `ingress-nginx` running on your cluster, you can add `--set ingress-nginx.enabled=false` parameter. Please note that you need to specify the existing ingress controller installation namespace in helm values.yaml file under "ingress-nginx" and "namespaceOverride".

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  --set ingress-nginx.enabled=false
```

> Please refer to [AWS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html) to learn more about EKS cluster creation and maintenance.

### AKS Installation (Azure Kubernetes Service)

This chart installs `ingress-nginx` by default.

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  -f https://raw.githubusercontent.com/cloud-agnost/agnost-gitops-charts/main/custom-values/aks-values.yaml
```

If you already have `ingress-nginx` running on your cluster, you can add `--set ingress-nginx.enabled=false` parameter. Please note that you need to specify the existing ingress controller installation namespace in helm values.yaml file under "ingress-nginx" and "namespaceOverride".

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  --set ingress-nginx.enabled=false
```

> Please refer to [Azure Documentation](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli) to learn more about AKS cluster creation and maintenance.

### DOKS Installation (Digital Ocean Kubernetes Service)

This chart installs `ingress-nginx` by default.

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  -f https://raw.githubusercontent.com/cloud-agnost/agnost-gitops-charts/main/custom-values/doks-values.yaml
```

If you already have `ingress-nginx` running on your cluster, you can add `--set ingress-nginx.enabled=false` parameter. Please note that you need to specify the existing ingress controller installation namespace in helm values.yaml file under "ingress-nginx" and "namespaceOverride".

```bash
helm upgrade --install agnost-gitops agnost-gitops/base \
  --namespace agnost --create-namespace \
  --set ingress-nginx.enabled=false
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
# you can access to the Redis cache from `localhost:6379` after running this:
kubectl port-forward svc/redis 6379:6379 -n agnost

# get password:
export REDIS_PASS=$(kubectl get secret redis -o jsonpath='{.data.password}' -n agnost | base64 -d)

# connect to redis:
redis-cli -h localhost -p 6379 --pass ${REDIS_PASS}
```

### MinIO Console

```bash
# http://localhost:9001
kubectl port-forward svc/minio-console 9001:9001 -n agnost

# username:
kubectl get secret minio -o jsonpath='{.data.accessKey}' -n agnost | base64 -d

# password:
kubectl get secret minio -o jsonpath='{.data.secretKey}' -n agnost | base64 -d
```

### Docker Registry

```bash
kubectl port-forward svc/registry 5000:5000 -n agnost

curl -s http://localhost:5000/v2/_catalog | jq
{
  "repositories": [
    "myimage1",
    "myimage1-cache"
  ]
}

curl -s http://localhost:5000/v2/myimage1/tags/list | jq
{
  "name": "myimage1",
  "tags": [
    "a2bb139"
  ]
}
```

### Tekton Pipelines

```bash
# http://localhost:9097/#/taskruns
kubectl port-forward svc/tekton-dashboard 9097:9097 -n tekton-pipelines
```

More information can be found [here](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/)

## Troubleshooting
We recommend installing Nginx Ingress Controller and Cert Manager using the default values of Agnost helm chart. However, if your Kubernetes cluster has already have any one of these components installed then you need to set couple of parameters in your installation command.

### ingress-nginx
If Nginx Ingress Controller has already been installed in your Kubernetes cluster. Please make sure you set the following values in your helm values.yaml file.

| Key | Value |
|-----|-------|
| ingress-nginx.enabled | Set this value to `false` to that Agnost helm chart does not try to install nginx-ingress controller |
| ingress-nginx.namespaceOverride | Set this value to the namespace where you have installed the nginx-ingress  |

### cert-manager
If Cert Manager has already been installed in your Kubernetes cluster. Please make sure you set the following values in your helm values.yaml file.

| Key | Value |
|-----|-------|
| cert-manager.enabled | Set this value to `false` to that Agnost helm chart does not try to install cert-manager |
| cert-manager.namespace | Set this value to the namespace where you have installed the cert-manager  |
| agnost-webhook.certManager.namespace | Set this value to the namespace where you have installed the cert-manager  |
| agnost-webhook.certManager.serviceAccountName | Set this value to the service account name of the cert-manager  |

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
