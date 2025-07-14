Infrastructure & Deployment of the AWS GroceryMate App
---

##  Table of Contents 

- [📋 Overview](#-overview)
- [⚙️ Terraform configuration](#-terraform-configuration)
- [🏢 Visualization of architecture](#-visualization-of-architecture-)
- [🔩 Terraform Architecture](#-terraform-architecture)
- [💡 Ideas and improvements for the future](#-ideas-and-improvements-for-the-future)
- [🔧 Deployment & Installation](#-deployment--installation)

## 📋 Overview
This project is part of the Cloud Track program of Masterschool's Software Engineering Bootcamp. An e-commerce application called GroceryMate was developed by one of our mentors and tutors [Alejandro Roman Ibanez](https://github.com/AlejandroRomanIbanez/AWS_grocery). *"GroceryMate is a modern, full-featured e-commerce platform designed for seamless online grocery shopping."* 

The app served as the foundation for exploring various deployment scenarios in the AWS cloud. Throughout the course, we incrementally built a complete cloud architecture using Terraform to define infrastructure as code.

This forked repository focuses on the infrastructure aspects of the GroceryMate application — including modular components such as ALB, ASG, Lambda, RDS, and more — all orchestrated and provisioned through Terraform.

Since I am still learning, this repo mainly focuses on exactly that. This is why I commented my code. A lot. I want to explain what I did and share this with others who want to learn as well. 

## 🏢 Visualization of architecture 

The following diagram shows the architecture of the GroceryMate application, including core AWS services and their interactions.

![Architecture](https://github.com/Kati-Sauder/AWS_grocery/blob/version2/Infrastructure/assets/Grocery%20Mate%20App%20Architektur.png)

## 🔩 Terraform Architecture

🧠 **Why This Architecture?**

When building the infrastructure for GroceryMate, I wanted something that wasn’t just functional — it had to be secure, scalable, cost-conscious, and easy to manage in the long run. So I went with a modular Terraform setup, where each piece of the infrastructure lives in its own module. Think of it like LEGO bricks: clean, reusable, and easy to rearrange when needed.

🚦 **Scalability & Availability**

To keep the app responsive no matter the traffic, I used an Auto Scaling Group for EC2 instances, fronted by an Application Load Balancer (ALB). The ALB smartly routes traffic to healthy instances, while the ASG automatically spins up or down servers based on demand. That way, the app can handle anything from one shopper to a full-on Black Friday rush — without overspending on idle capacity.

🧰 **Why EC2?**

For the core application, I went with EC2 because of having full control. EC2 lets me configure the environment exactly the way I want, handle stateful processes more easily, and dig deep when debugging. Combined with ASG and ALB, it still scales smoothly while giving flexibility.

🔐 **Security**

Security wasn’t an afterthought. I set up dedicated Security Groups for each major component — EC2, RDS, ALB — and tightly controlled who can talk to what. For example, EC2 only accepts traffic from the ALB. RDS sits safely in a private subnet, only accessible by EC2. IAM roles are finely tuned for least-privilege access, so resources only do what they’re supposed to — and nothing more.

🌐 **Networking**

The app lives in a VPC with public and private subnets. Public-facing parts (like the ALB) go into the public subnet, while sensitive stuff (like the database) stays tucked away in the private one. There’s also routing and gateways in place to ensure secure, controlled access to the outside world.

💾 **Storage & State**

I’m using an S3 bucket to store static assets (like user avatars) and manage Terraform state. It’s reliable and integrates beautifully with the rest of the AWS ecosystem.

🧱 **In Short**

This architecture is solid — tight security with high availability, and cost-efficiency with flexibility. It's built for the real-world demands of an e-commerce app, while staying clean, modular, and ready for future tweaks.

## 💡 Ideas and improvements for the future
One feature I’d like to add in the future is automated invoice creation using Amazon EventBridge and AWS Lambda. The idea was to trigger an event (e.g. after a successful checkout or order confirmation), which would invoke a Lambda function to generate an invoice and then store it in an S3 bucket.

This event-driven architecture would help decouple responsibilities, make the system more modular, and allow for future extensions like sending email receipts or tracking user activity. While this setup wasn’t fully implemented in this version of the project, it remains on my roadmap as a next step to explore more serverless patterns in AWS.

## 🔧 Deployment & Installation

**Prerequisites**

🔹 Python (at least version 3.11) – For the backend 

🔹 PostgreSQL – Database

🔹 Terraform – Infrastructure 

🔹 AWS CLI – Interact with AWS services using commands in your terminal or shell


**Clone Repository**
```bash
git clone https://github.com/Kati-Sauder/AWS_grocery/tree/version2

cd AWS_grocery
```
**Install AWS CLI**
```bash
brew install awscli
```
Verify installation with
```bash
aws --version
```
**Configure AWS CLI for SSO Authentication**
```bash
aws configure sso
```
Please read https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html for further information.

**Logging in to AWS SSO**
```bash
aws sso login
```
**Verify Your AWS Credentials**
```bash
aws sts get-caller-identity
```
Since your AWS credentials are temporary, you may need to re-authenticate periodically by running aws sso login again.

**Deploy Cloud Infrastructure**
```bash
cd infrastructure

terraform init

terraform plan

terraform apply 
```

**Connect to the Instance**
```bash
ssh -i /path/to/your-key.pem ec2-user@your-ec2-public-ip
```
**Update the System & install essential Software**
```bash
sudo yum update -y
sudo yum install -y git python3 python3-pip postgresql15 postgresql15-server postgresql15-contrib
```
**Verify installation**
```bash
git --version
python3 --version
pip --version
psql --version
```
**Configure PostgreSQL**

Create database and user:
```bash
psql -U postgres -c "CREATE DATABASE grocerymate_db;"
psql -U postgres -c "CREATE USER grocery_user WITH ENCRYPTED PASSWORD '<your_secure_password>';"  # Replace <your_secure_password> with a strong password of your choice
psql -U postgres -c "ALTER USER grocery_user WITH SUPERUSER;"
```
**Populate Database**
```bash
psql -U grocery_user -d grocerymate_db -c "SELECT * FROM users;"
psql -U grocery_user -d grocerymate_db -c "SELECT * FROM products;"
```

**Set up Python environment**

Install dependencies in an activated virtual environment:
```bash
cd backend
pip install -r requirements.txt
```
**Set up environment variables**

Create a secure JWT key and safe it:
```bash
python3 -c "import secrets; print(secrets.token_hex(32))"
```
**Create an .env file**
```bash
touch .env
```
Then, populate it with the required environment variables (make sure to replace the passwords <grocery_test> with your own):

```bash
echo "JWT_SECRET_KEY="your-key-here >> .env
echo "POSTGRES_USER=grocery_user" >> .env
echo "POSTGRES_PASSWORD=<grocery_test>" >> .env
echo "POSTGRES_DB=grocerymate_db" >> .env
echo "POSTGRES_HOST=localhost" >> .env
echo "POSTGRES_URI=postgresql://grocery_user:<grocery_test>@localhost:5432/grocerymate_db" >> .env
```
**Application Configuration**

Since the application is running inside Docker, we must pass the environment variables dynamically (replace placeholders):
```bash
docker run --network host \
  -e S3_BUCKET_NAME=bucket_name \
  -e S3_REGION=region_name \
  -e USE_S3_STORAGE=true \
  -e POSTGRES_USER=grocery_user \
  -e POSTGRES_PASSWORD=your_password \
  -e POSTGRES_DB=db_name \
  -e POSTGRES_HOST=grocery-mate-db.czyueaksagjt.eu-central-1.rds.amazonaws.com \
  -e POSTGRES_URI=postgresql://<your_psql_user>:<your_psql_password>@$<your-rds-endpoint>:5432/$<your_psql_db> \
  -e JWT_SECRET_KEY=your_secret_key \
  -e SECRET_KEY=your_secret_key \
  -p 5000:5000 grocerymate
```

**Access the Application**
```bash
http://<EC2_PUBLIC_IP>:5000
```