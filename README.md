# Serverless Event-Driven File Processing System

## Project Overview

This project demonstrates how to build a serverless event-driven architecture on AWS using Terraform.

When a file is uploaded to Amazon S3, an AWS Lambda function is automatically triggered. The Lambda function extracts file metadata and stores it in a DynamoDB table, while also sending a notification through Amazon SNS.

The infrastructure is fully deployed using Infrastructure as Code (Terraform).

Architecture

Workflow:

User uploads file → S3 bucket
S3 event triggers Lambda
Lambda processes metadata
Metadata stored in DynamoDB
Notification sent via SNS