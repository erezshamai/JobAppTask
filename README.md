
My public gitHub repository URL: https://github.com/erezshamai/JobAppTask using main code branch

repository structure
-----------------------------
JOBAPPTASK/
├── terraform/         # Terraform code for infrastructure
├── app/              # Web application source code
├── docker/           # Dockerfile and related scripts
├── ci-cd/            # GitHub Actions workflows
├── k8s/              # Kubernetes manifests or Helm charts
├── ansible/          # 🔹 New directory for Ansible
│   ├── playbook.yml  # 🔹 Ansible playbook
│   ├── inventory.ini # 🔹 Inventory file (target hosts)
│   ├── roles/        # (Optional) Ansible roles for modular deployment
├── docs/             # Documentation (README, architecture, decisions)
├── .github/workflows/ # GitHub Actions pipelines
├── README.md
└── .gitignore


 - Terraform apply using my windows workstasiom under terraform folder

 - Erez AKS Admins security group was manually create
   az ad group show --group "Erez AKS Admins" --query "id" --output tsv (to get id=147084b4-5625-4f92-afd9-e90ce49064e2)
 - aks-cluster Networking Authorized IP ranges was disabled manually to enable testing and other problem handling 
 - Application Gateway was attached to  aks-cluster manually (after unsuccesful via main.tf file)
 - Contributor role assignment added to created service principal to list the admin credentials for the AKS cluster. done to bypass the interactive login flow and let deployment run without manual intervention
 - Erez AKS Admins group created
 - following needed gitHub Repository secrets created: ACR_PASSWORD, ACR_USERNAME, AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, AZURE_CREDENTIALS, AZURE_TENANT_ID
 
 - After every repo push build and deploy pipeline will start automaticly runnig .github/workflows/main.yml file commands
 - run az aks update --name aks-cluster --resource-group Erez1-Candidate --attach-acr erezcontainerregistry
   to fix 
   erezcontainerregistry.azurecr.io/webapp:latest": failed to authorize: failed to fetch anonymous token 