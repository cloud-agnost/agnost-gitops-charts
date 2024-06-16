# Agnost GitOps installation via Helm Chart

Work in progres!

Add config parameters for nginx-ingress for AKS and EKS through a custom values.yaml file
helm install my-release nginx-ingress -f custom-values.yaml

custom-values.yaml example for EKS below:

ingress-nginx:
  controller:
    service:
      annotations:
        # AWS Elastic Kubernetes Service (EKS) - Uncomment below lines to add EKS specific annotations
        service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "tcp"
        service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
        service.beta.kubernetes.io/aws-load-balancer-type: "nlb"



