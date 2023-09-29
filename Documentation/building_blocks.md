## DEVOPTYMIZE COMPONENTS 

| Infrastructure Accelerator | DevSecops Accelerator | Observability Accelerator | 
| -------- | -------- | -------- |
| IaC having ability to spin up the entire microservices infrastructure on EKS | Framework to build DevSecops pipeline with minimal work.| Gains visibility of complex ecosystem  and understand any planned/unplanned changes.| 
| Accelerator to ease engineers work on Terraform and CFT through standard templates adhering to industry best practices. | Reduce Cluster setup time and up to 30% cost saving. |Building Helm Chart using best tools available to ensure us to unify 3 pillars of Observability.  | 
| We have customer onboarding seed-job workflow. Based on clients requirements, the code can be decoupled from framework and delivered to client at any time.  |One click deployment solution into K8s cluster using HelmChart.  | Helps building reliable infrastructure which is Secure and Compliance. | 





### Infrastructure accelerator - Terraform/CFT

- Framework to create IaC which has the ability to spin up the client's entire infrastructure on AWS.
- Deploy the desired set of resources on the client environment by just giving the required inputs.
- This component of the framework helps to create a robust AWS multi-account architecture, which includes the necessary components such as VPCs, Subnets etc. It can also deliver an automated multi-stage Kubernetes (EKS) or ECS platform solution. 
- We have Cloudform and Terraform templates that can easily create, deploy and manage.
- Templates that can easily create the EKS cluster and make it easier to deploy your K8s workloads.

![](https://gitlab.cloudifyops.com/devoptymize/documentation/-/raw/main/images/15.png)

### DevSecOps Accelerator - K8s

-  A fully automated and operational open source platform that includes some of the best tools available in the Kubernetes space.
- We have a Master Shell Script ( inception.sh) controlling the ArgoCD deployments. We can deploy required K8s components into the EKS cluster with the help of shell script.
- We have configured the entire cluster setup using industry security best practices with minimal time. 
- Reduced cluster setup time and 30% cost savings. 
- Integrated Observability monitoring tools, SecOps tools, and K8s Add-on components installation and configuration into the framework.


![](https://gitlab.cloudifyops.com/devoptymize/documentation/-/raw/main/images/14.png)


### Observability Accelerator 

- Helm Chart using the best observability tools available to ensure “Logs”, “Metrics” and “Traces” are collected and visualized in one single platform to unify the Three Pillars Of Observability. 
- Reusable assets for deploying and configuring observability tools; to gain visibility of the complex application ecosystem, understand any planned or unplanned changes and stay ahead of the curve.
- Able to deploy and configure the observability and monitoring tools into the client's EKS cluster by using the reusable Helmcharts.
- Reusable Helm Charts w.r.t Observability monitoring tools like Falco, LGMT stack, Jaeger, Trivy, etc.