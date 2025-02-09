repository structure
-----------------------------
JOBAPPTASK/
├── terraform/        # Terraform code for infrastructure
├── app/             # Web application source code
├── docker/          # Dockerfile and related scripts
├── ci-cd/           # GitHub Actions workflows
├── k8s/             # Kubernetes manifests or Helm charts
├── docs/            # Documentation (README, architecture, decisions)
├── .github/workflows/ # GitHub Actions pipelines
├── README.md
└── .gitignore


Hi Erez

Please find attached:

 

User_Name: Erez1@2bcloudsandbox.onmicrosoft.com

Password: 2bAzureCandidate2024 -- Feb#2025#Feb

Display_Name: Erez Shamai

Resource_Group: Erez1-Candidate

Resource_Group_Access_Level: Owner

Subscription_Access_Level: Contributor

No     Subscription name    Subscription ID                       Tenant
-----  -------------------  ------------------------------------  ---------------
[1] *  sandbox19/11/2024    2fa0e512-f70e-430f-9186-1b06543a848e  2bcloud Sandbox

The default is marked with an *; the default tenant is '2bcloud Sandbox' and subscription is 'sandbox19/11/2024' (2fa0e512-f70e-430f-9186-1b06543a848e).


Install Terraform:

Download Terraform from the official website.
Extract the downloaded zip file and move the terraform.exe to a directory included in your system's PATH


Create resource in azure subscription
-----------------------------------------
az login
cd path\to\your\terraform\directory
terraform init

- Import the Resource Group: terraform import azurerm_resource_group.devops /subscriptions/2fa0e512-f70e-430f-9186-1b06543a848e/resourceGroups/Erez1-Candidate

- manually create Erez AKS Admins security group
az ad group show --group "Erez AKS Admins" --query "id" --output tsv (to get id=147084b4-5625-4f92-afd9-e90ce49064e2)


terraform apply



