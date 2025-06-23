Infrastructure & Deployment of the AWS GroceryMate App
---

##  Table of Contents 

- [📋 Overview](#-overview)
- [🏢 Visualization of architecture](#-visualization-of-architecture-)
- [⚙️ Components of Infrastructure](#-components-of-infrastructure-)
- [🔩 Terraform configuration](#-terraform-configuration)
- [🧩 Terraform modules](#-terraform-modules-)
  - [⚖️ ALB](#-alb)
  - [📈 ASG](#-asg-)
  - [💻 EC2](#-ec2-)
  - [🚌 EventBridge](#-eventbridge-)
  - [🥷🏼 IAM](#-iam-)
  - [💡 Lambda](#-lambda-)
  - [🌐 Network](#-network-)
  - [🗄 RDS](#-rds-)
  - [🪣 S3](#-s3-)
  - [🔐 Security](#-security-)
- [⚡️Event Trigger & Lambda Function](#event-trigger--lambda-function)
- [🔧 Deployment & Installation](#-deployment--installation)
- [💸 Cost Monitoring](#-cost-monitoring)
- [🧠 Ideas & Enhancements for the Future](#-ideas--enhancements-for-the-future)

## 📋 Overview
This project is part of the Cloud Track program of Masterschool's Software Engineering Bootcamp. An e-commerce application called GroceryMate was developed by one of our mentors and tutors [Alejandro Roman Ibanez](https://github.com/AlejandroRomanIbanez/AWS_grocery). *"GroceryMate is a modern, full-featured e-commerce platform designed for seamless online grocery shopping."* 

The app served as the foundation for exploring various deployment scenarios in the AWS cloud. Throughout the course, we incrementally built a complete cloud architecture using Terraform to define infrastructure as code.

This forked repository focuses on the infrastructure aspects of the GroceryMate application — including modular components such as ALB, ASG, Lambda, RDS, and more — all orchestrated and provisioned through Terraform.

## 🏢 Visualization of architecture 
The following diagram shows the architecture of the GroceryMate application, including core AWS services and their interactions.

## 🔩 Components of Infrastructure 
**Networking & Security**

🔹 A dedicated Virtual Private Cloud (VPC) with clearly separated public and private subnets

🔹 Internet Gateway to control outbound internet access from private resources

🔹 Security Groups and IAM roles defined to enforce the principle of least privilege, including roles for EC2 and Lambda

**Compute & Load Balancing**

🔹 An Auto Scaling Group (ASG) dynamically manages EC2 instances running the GroceryMate frontend/backend

🔹 An Application Load Balancer (ALB) distributes incoming HTTP traffic across available instances

🔹 The EC2 application server is deployed in a public subnet and can be accessed securely via SSH, restricted by IP-based Security Group rules

**Database & Storage**

🔹 Amazon RDS (PostgreSQL) is provisioned in private subnets for secure and persistent data storage

🔹 Amazon S3 is used for two purposes: storing product and user images, and managing invoice files processed by Lambda functions

**Serverless & Event-Driven Architecture**

🔹 An AWS Lambda function is triggered by events (e.g. order completion) to handle invoice generation and storage

🔹 Amazon EventBridge connects application events to the Lambda function, enabling a decoupled, event-driven workflow

## ⚙️ Terraform Configuration
![Architecture](infrastructure/assets/terraform-modules.png)
## 🧩 Terraform modules 
The infrastructure was built using a modular Terraform structure to ensure scalability, reusability, and maintainability. Each module  encapsulates a specific component of the system, allowing for clear separation of concerns.

I went modular because it just makes life easier! Breaking the infrastructure into focused pieces means you can update, debug, or even reuse parts without messing with the whole setup. It’s like having LEGO blocks instead of one giant monolith.
### ⚖️ ALB
Deploys an Application Load Balancer (ALB).
Configures listeners and target groups for routing traffic.
The Load Balancer distributes traffic efficiently and supports automatic scaling, which is crucial for handling varying e-commerce traffic loads.
### 📈 ASG 
Manages the Auto Scaling Group (ASG) for EC2 instances.
The Auto Scaling Group keeps the app running smoothly by automatically adjusting the number of EC2 instances based on demand — so you get reliable performance without wasting resources or paying for idle servers.

### 💻 Ec2 
Creates and configures EC2 instances used by the application.
Assigns security groups and IAM roles.

Why EC2 and not fully serverless? Well, EC2 with an Auto Scaling Group gives you full control over the app servers. For an e-commerce app like GroceryMate, this means we can handle stateful processes, customize the environment exactly how we want it, and troubleshoot more easily. Plus, with ASG and the Application Load Balancer, the app scales smoothly with demand — whether it’s a quiet day or a shopping spree.

### 🚌 EventBridge 
Sets up EventBridge rules to trigger Lambda functions based on events.

Here I didn’t ignore serverless completely. EventBridge and Lambda functions are perfect for smaller, event-driven tasks like processing invoices. They keep the app lean by only running when needed, saving costs and complexity.

### 🥷🏼 IAM 
Defines IAM roles and policies for EC2 and Lambda permissions.

Defining fine-grained IAM roles and Security Groups enforces the principle of least privilege and protects resources.

### 💡 Lambda
Deploys Lambda functions, including roles and access permissions.

### 🌐 Network 
Creates the VPC, public and private subnets, Internet Gateway, and routing.

On the networking side, I set up a VPC with public and private subnets to keep things secure. The database (PostgreSQL on RDS) lives safely in the private subnet, away from the public internet, so the customer data stays protected.
### 🗄 RDS 
Deploys the PostgreSQL RDS instance in private subnets with security groups.

Using RDS (PostgreSQL) provides a reliable, managed relational database suitable for the complex transactions and relationships in an e-commerce app.

### 🪣 S3 
Creates S3 buckets for static assets and Terraform state storage.

S3 buckets handle static assets and store Terraform state, giving us scalable and reliable storage that plays nicely with the rest of AWS.

### 🔐 Security 
Defines security groups for EC2, RDS, ALB, and other components.

On the security side, I’ve set up dedicated Security Groups for each major component: EC2, RDS, and the Application Load Balancer. This way, each resource only accepts the network traffic it really needs. For example, EC2 instances only allow incoming connections from the ALB, keeping direct access tightly controlled. The RDS database lives in a private subnet and only accepts traffic from the EC2 Security Group, so it’s locked down from everything else.

***
This mix of serverless and infrastructure gives us the best of both worlds: keeping costs down, boosting performance, and making everything easier to maintain for a real-life e-commerce app.

## ⚡️Event Trigger & Lambda Function

## 🔧 Deployment & Installation

## 💸 Cost Monitoring

## 🧠 Ideas & Enhancements for the Future






