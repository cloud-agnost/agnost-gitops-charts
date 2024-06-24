# Agnost GitOps installation via Helm Chart

Work in progress!

Add config parameters for nginx-ingress for AKS and EKS through a custom `values.yaml` file

```bash
helm install my-release nginx-ingress -f custom-values.yaml
```

`custom-values.yaml` example for EKS below:

```yaml
ingress-nginx:
  controller:
    service:
      annotations:
        # AWS Elastic Kubernetes Service (EKS) - Uncomment below lines to add EKS specific annotations
        service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "tcp"
        service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
        service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
```
