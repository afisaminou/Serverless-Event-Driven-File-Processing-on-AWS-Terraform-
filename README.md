# Serverless Event-Driven File Processing System

## Project Overview

This project demonstrates how to build a serverless event-driven architecture on AWS using Terraform.

When a file is uploaded to Amazon S3, an AWS Lambda function is automatically triggered. The Lambda function extracts file metadata and stores it in a DynamoDB table, while also sending a notification through Amazon SNS.

The infrastructure is fully deployed using Infrastructure as Code (Terraform).

## Architecture

Workflow:

User uploads file → S3 bucket

S3 event triggers Lambda

Lambda processes metadata

Metadata stored in DynamoDB

Notification sent via SNS

## AWS Services Used

• Amazon S3
• AWS Lambda
• Amazon DynamoDB
• Amazon SNS
• AWS IAM
• Terraform (Infrastructure as Code)

## Features

• Fully serverless architecture
• Event-driven processing
• Infrastructure deployed with Terraform
• Metadata persistence in DynamoDB
• Real-time notifications with SNS

## Repository Structure

serverless-file-processing-terraform

architecture/
    architecture-diagram.png

lambda/
    lambda_function.py
    lambda_function.zip

terraform/
    main.tf
    variables.tf
    outputs.tf
    terraform.tfvars.example

## Deployment Instructions

1. Clone the repository

git clone https://github.com/YOUR_GITHUB_USERNAME/serverless-file-processing-terraform.git
cd serverless-file-processing-terraform

2. Configure AWS credentials

aws configure

Provide:

AWS Access Key
AWS Secret Key
Region

3. Configure Terraform variables

Copy the example file:
cp terraform/terraform.tfvars.example terraform/terraform.tfvars

Edit the file and add your values.

Example:

bucket_name = "your-unique-bucket-name"
dynamodb_table_name = "file_metadata_table"
sns_topic_name = "file-upload-notification-topic"

4. Initialize Terraform
cd terraform
terraform init
5. Deploy Infrastructure
terraform plan
terraform apply

Type:

yes

Terraform will create:

S3 bucket

Lambda function

DynamoDB table

SNS topic

IAM roles

S3 event trigger

## Testing the System

1. Upload a file to the S3 bucket.

2. The Lambda function will automatically process the file.

3. File metadata will be stored in DynamoDB.

4. A notification will be sent through SNS.