# Serverless Event-Driven File Processing System

## Project Overview

A growing digital media company needs an automated system to process files uploaded by users. Previously, employees manually monitored uploads and recorded file information in spreadsheets. This process was inefficient, error-prone, and could not scale with increasing user activity.
To address this challenge, a serverless event-driven architecture was designed and deployed using AWS and Terraform. The system automatically processes uploaded files, stores metadata, and notifies the operations team in real time.
The entire infrastructure is deployed using Infrastructure as Code (Terraform) to ensure consistency, repeatability, and easier maintenance.

## Business Problem

The company faced several operational challenges:

**1. Manual File Tracking**

Staff had to manually review uploaded files and document metadata such as file name, size, and upload time.

**2. Lack of Real-Time Notifications**

The operations team was not immediately aware when new files were uploaded.

**3. Scalability Issues**

As the number of users increased, manual monitoring became impractical and time-consuming.

**4. Risk of Data Loss**

Without centralized metadata storage, important information about uploaded files could be lost or misrecorded.

## Solution

A **serverless event-driven architecture** was implemented using AWS services to automate file processing.

When a user uploads a file:

1. The file is stored in an **Amazon S3 bucket.**

2. The upload event automatically triggers an **AWS Lambda function.**

3. The Lambda function extracts file metadata.

4. Metadata is stored in **Amazon DynamoDB.**

5. A notification is sent to the operations team through **Amazon SNS.**

This architecture removes manual work and ensures that file uploads are automatically processed in real time.


## Architecture Diagram


![alt text](<Screenshots/Serverless file processing architecture diagram.PNG>)


**Workflow Summary:**

User → S3 Upload → Lambda Trigger → DynamoDB Storage + SNS Notification

## AWS Services Used

**• Amazon S3** - File storage and event trigger

**• AWS Lambda** - Serverless processing of uploaded files

**• Amazon DynamoDB** - NoSQL database for storing file metadata

**• Amazon SNS** - Notification service for alerting the operations team

**• AWS IAM** - Securte permissions between services

**• Terraform** - Infrastructure as Code for automated deployment


## Key Benefits of the Solution

**• Automation:** File processing is fully automated with no manual intervention required.

**• Scalability:** Serverless architecture automatically scales based on the number of file uploads

**• Real-Time Notifications:** The operations team receives immediate alerts when files are uploaded.

**• Centralized Metadata Storage:** File information is stored reliably in DynamoDB for auditing and analytics.

**• Infrastructure as Code:** Terraform ensures the environment can be deployed consistently across different environments.


## Example Metadata Stored

When a file is uploaded, the Lambda function stores metadata such as:

file_id

bucket

file_name

file_size

uploaded_at

This enables the company to track and audit all file uploads efficiently.

## Future Improvements

Several improvements could be implemented to enhance this architecture:

**1. File Type Validation**

Lambda could validate file types (e.g., only allow CSV, images, or PDFs).

**2. Dead Letter Queue (DLQ)**

Use Amazon SQS to capture failed Lambda executions for troubleshooting.

**3. CloudWatch Monitoring**

Add CloudWatch alarms and metrics to monitor failures and performance.

**4. Security Enhancements**

Enable encryption for:

• S3 objects

• DynamoDB tables

• SNS messages

**5. Data Processing Pipeline**

The Lambda function could perform additional tasks such as:

• Image processing

• Data transformation

• File scanning for malware

**6. CI/CD Automation**

Implement a CI/CD pipeline using GitHub Actions to automatically deploy Terraform infrastructure.