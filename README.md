# Quick Links

- [Repo Overview](#jenkins-cicd-pipeline-for-wordpress)
- [Screenshots](#screenshots)
  - [Logging](#logging-elastic-stack)
  - [Monitoring](#monitoring-prometheus-and-grafana)
  - [Azure DevOps](#azure-devops)
  - [SonarQube](#sonarqube)
  - [Trivy](#trivy)
- [Usage](#how-to-use-it)

# Azure DevOps Pipeline for Wordpress

- This repo contains the source for a Azure DevOps CI/CD Pipeline that integrates and deploys WordPress on AWS EKS with **monitoring**, **logging**, **static application security testing**, and **container vulnerability scanning**
- The pipeline script builds a container image of our custom WordPress installation using Docker.
- Then it pushes the image to Docker Hub.
- Then it provisions an EKS Kubernetes cluster on AWS using Terraform.
- After that, it creates a Let's Encrypt SSL Certificate still using Terraform.
- Sensitive data are passed to the cluster by converting Ansible Jinja2 template files to regular files while passing secrets to them from Ansible Vault
- Then it provisions an AWS load balancer controller on AWS using Terraform and Helm
- Afterwards, it deploys Prometheus and Grafana for monitoring using Terraform and Helm charts.
- Using Terraform and Helm again, it deploys the Elastic Stack (Elasticsearch, Logstash, Kibana, and Filebeat)
- Next, it scans the docker image for vulnerabilities using Trivy.
- Then it deploys WordPress.

# Screenshots

## The Content Management System (WordPress)

![Screenshot (263)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/66a3339f-df48-4e9b-b5f8-a6dba8ff7a76)

## Logging (Elastic Stack)

![Log Overview](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/333f57ab-c60e-4ad7-a48b-835acb25fa09)
![Log Stream](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/bf703a20-f3ab-4f53-9463-55c90f30a524)

## Monitoring (Prometheus and Grafana)

![Screenshot (266)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/412a6599-7757-4b9f-9295-3c0b0414299d)
![Screenshot (267)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/559fe6b4-8623-4407-8185-3fa3f22d592b)
![Screenshot (268)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/0b13c3a8-2b37-4c01-8115-fffa56ceb1a5)
![Screenshot (269)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/2d1db83e-1c2f-42a2-ac39-48e1a93d2e8a)
![Screenshot (270)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/03fdc87e-ec91-4a11-bec6-d381ddceb1f4)
![Screenshot (271)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/9532d2dd-9b2b-469b-927f-7fd9e2deb1f9)
![Screenshot (272)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/a62db27c-3625-4e60-9b5f-6f00f330d32e)
![Screenshot (274)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/f867d9a1-f405-479a-a7db-fc407d86a693)

## Azure DevOps

![Screenshot (279)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/0d2abb56-a6e2-4924-b76e-a0d9535d3ecc)
![Screenshot (280)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/ea157a9a-bcb8-4827-a727-82b7921cd0ca)

## SonarQube

![Screenshot (264)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/e7c32cd2-15f9-4651-9800-79dac567dbdc)
![Screenshot (265)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/a52c0b93-3ac1-4511-8f4f-78d33f6f1a60)

## Trivy

![Screenshot (277)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/cb0f7621-495f-47af-a8d5-86adc4507c52)
![Screenshot (278)](https://github.com/Adeyomola/cms-azure-pipeline/assets/44479277/29b203cb-dda3-4c00-8fd1-cfa5184f7246)

# How to Use It

## ANSIBLE VARIABLES

Create the following variables in a file called secrets.yml

- db_user
- db_password
- dp_port
- email
- email_password
- mail_server
- slack_api

Then encrypt the secrets.yml file with ansible vault.

## CREATING THE S3 AND DYNAMO DB BACKEND FOR TERRAFORM

- Once the variables and sensitive information are in place, `cd` into the backend directory and adjust the `variables.tf`.
- Open the `s3.tf` file and comment out `force_destroy = true` in the `aws_s3_bucket` resource block.
- Then run `terraform init && terraform apply -auto-approve`

## SET UP A PIPELINE ON YOUR AZURE DEVOPS SERVER

- Install SonarQube extension and Trivy extension from Visual Studio Marketplace

## PROVISION AND DEPLOY

### AZURE DEVOPS VARIABLES

- Create a file - `.pass` - containing your ansible vault password.
- Upload the file to the secure files library of your Azure DevOps project.
- Create a variable group with the following variable names:
  - access_key_id
  - account_id
  - arn
  - db_name
  - docker_password
  - docker_username
  - email
  - password
  - region
  - secret_access_key
  - username

### Values for the Variables

- Value of `access_key_id` should be AWS access key ID
- Value of `secret_access_key` should be AWS secret access key
- Value of `account_id` should be AWS Account ID
- Value of `docker_password` should be your Docker password
- Value of `docker_username` should be your Docker username
- Value of `username` should be database username
- Value of `password` should be database password
- Value of `db_name` should be database name
- Value of `arn` should be your AWS ARN
- Value of `email` should be email address for SSL certificate
- Value of `region` should be the AWS region you're working in

* Then Build.
