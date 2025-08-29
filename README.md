
My public gitHub repository URL: https://github.com/erezshamai/JobAppTask using aviram code branch

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


- Items/Tasks where developed build and tested on my windows 11 laptop using Docker Desktop
- docker/jenkins/Dockerfile use to build myjenkins docker image and container
 -e DOCKER_HOST=tcp://host.docker.internal:2375 docker flag added to its docker run command to support connection with my local laptop docker 
 command to run: 
 docker network create --driver bridge my-cotainerTest-network
 docker run -d --name my2jenkins --network my-cotainerTest-network -p 8080:8080 -p 50000:50000 -e DOCKER_HOST=tcp://host.docker.internal:2375  -v jenkins_home:/var/jenkins_home erezshamai707/myjenkinsjdk17:latest
 my-dockerhub-credentials-id credential created in jenkins server

 - Item one  jenkins job file = ci-cd/jenkins/webJenkinsFile 
 - Item two  jenkins job file = ci-cd/jenkins/nginxJenkinsFile
 - Item three jenkins job file = ci-cd/jenkins/testContainersJenkinsFile
 - Item fourth yml files are under  k8s folder
 Keda installed using helo and hey for simple nginx app scaling test
 powerShell commands used during testing:
 hey -n 100000 -c 100  http://localhost:80
 kubectl get deployments
 while ($true) { kubectl top pods; Start-Sleep -Seconds 2; Clear-Host }





