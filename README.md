# Centralized Alert Management System with User Notifications and CloudWatch

Centralized alert management system using AWS User Notifications, CloudWatch alarms, and S3 monitoring.

<img width="624" height="282" alt="0308b86c1986f514cc7ac98748f9c85c_kix g4x8cy4yvhun" src="https://github.com/user-attachments/assets/382462f9-de0e-4677-9fea-cb7409d11892" />

## Problem

Enterprise organizations struggle with alert fatigue and scattered notifications across multiple AWS services, making it difficult to respond promptly to critical infrastructure issues. Traditional notification systems send alerts to various channels without central coordination, resulting in missed alerts, delayed incident response, and operational inefficiencies that can impact business continuity.

## Solution

AWS User Notifications provides a centralized notification management system that consolidates CloudWatch alarms and other AWS service alerts into a unified dashboard with configurable delivery channels. This solution creates a single pane of glass for monitoring S3 storage metrics, enabling teams to manage notification preferences, filter alerts by priority, and ensure critical issues receive immediate attention through multiple delivery methods.

## Architecture Diagram

<img width="724" height="762" alt="image-10" src="https://github.com/user-attachments/assets/1980673b-8daf-4559-afd2-477bd4d51dcb" />

## Tools & Services Used

- Amazon S3
- Amazon CloudWatch
- AWS User Notifications
- AWS EventBridge
- Terraform
- AWS CLI

---

## Terraform Deployment

This project was deployed entirely using Terraform. All AWS resources were defined as code, planned, and applied without manually clicking through the AWS Console.

| File | Purpose |
|---|---|
| `main.tf` | Defines all AWS resources |
| `variables.tf` | Declares all input variables |
| `outputs.tf` | Displays resource info after deployment |
| `versions.tf` | Specifies Terraform and provider versions |
| `terraform.tfvars` | Personal values — excluded from GitHub |

---

### 1. Create S3 Bucket with CloudWatch Metrics

The S3 bucket is the resource being monitored. Alongside it, versioning, encryption, public access blocking, and CloudWatch metrics are all configured as separate Terraform resources:

<img width="806" height="725" alt="image-11" src="https://github.com/user-attachments/assets/0542b416-224f-49a6-b946-6295dc5bb2b8" />


### 2. Upload Sample Files to Generate Metrics

Instead of manually uploading files, Terraform creates 4 sample objects automatically. 3 small JSON files and 1 larger file to help trigger size-based alarms:

<img width="814" height="524" alt="image-12" src="https://github.com/user-attachments/assets/ed4675cc-10df-4913-b777-7d1b537acb22" />

<img width="794" height="584" alt="image-13" src="https://github.com/user-attachments/assets/ed1680ae-3621-4aeb-931b-d32ce338e961" />


### 3. CloudWatch Alarms Configuration for Bucket Monitoring

CloudWatch alarms provide intelligent monitoring by evaluating metric thresholds and triggering notifications when storage patterns indicate potential issues. Two alarms are created — one for bucket size and one for object count. Both evaluate daily to match the frequency of S3 storage metric updates:

**S3 bucket size alarm:**

<img width="802" height="560" alt="image-14" src="https://github.com/user-attachments/assets/460ea754-d01d-4d2d-97b4-d4c729496ac9" />


**S3 object count alarm:**

<img width="844" height="482" alt="image-15" src="https://github.com/user-attachments/assets/5fc7c9ac-6187-4936-b2e0-b05b3865f878" />


### 4. Register User Notifications Hub

The notification hub is the central processing engine for all alerts in a region. It must exist before any notification configurations can be created:

<img width="677" height="189" alt="image-16" src="https://github.com/user-attachments/assets/0c7ff848-5d83-42b9-887b-756dcd27943d" />


### 5. Create Email Contact for Notifications

The email contact is managed by a separate AWS sub-service called `notificationscontacts`. It stores and verifies the email address that will receive alerts:

<img width="749" height="115" alt="image-17" src="https://github.com/user-attachments/assets/aa6ab2c9-5e45-4abc-8697-09250c792164" />


### 6. Create Notification Configuration and Associate Email

The notification configuration ties everything together. It defines how alerts are grouped and links the email contact as a delivery channel:

<img width="829" height="122" alt="image-18" src="https://github.com/user-attachments/assets/ef0f914e-d51b-4ac8-a679-2d72e4476dde" />

<img width="864" height="111" alt="image-19" src="https://github.com/user-attachments/assets/b6a7a37e-5b85-41c5-97f4-790d905c1d07" />

### 7. Create EventBridge Event Rule

The event rule is the smart filter that watches for CloudWatch alarm state changes and routes only the relevant ones to the notification hub. It catches both `ALARM` and `OK` transitions so you know when an issue starts and when it resolves:

<img width="866" height="476" alt="image-20" src="https://github.com/user-attachments/assets/8489b910-7885-40c8-b031-79cadd23dbd9" />

## Validation & Testing

Validating the complete notification workflow ensures reliable alert delivery and proper system integration.

### 1. Confirm CloudWatch alarm status

Expected output: Alarm in OK state with threshold of 5000000 bytes

<img width="620" height="132" alt="image-21" src="https://github.com/user-attachments/assets/7f8867cf-2f03-4404-8971-bb63f30da825" />


### 2. Test full notification pipeline
```bash
# Trigger alarm manually
aws cloudwatch set-alarm-state \
  --alarm-name alert-mgmt-s3-bucket-size-alarm-4990e7 \
  --state-value ALARM \
  --state-reason 'Manual test' \
  --region us-west-2
```

**Result:**
- Alarm state changed to ALARM
- EventBridge detected the state change
- User Notifications processed the event
- Email notification delivered to inbox
- Alert visible in AWS Console Notifications Center

<img width="1216" height="440" alt="image-22" src="https://github.com/user-attachments/assets/fb2544c1-2f94-403d-b904-f8d71f8c33e7" />

<img width="1370" height="471" alt="image-23" src="https://github.com/user-attachments/assets/58095b27-8efb-4b7f-b990-e3bfaa77c9aa" />

---

## Cleanup

After testing, all resources were destroyed using Terraform to avoid ongoing charges:

```bash
terraform destroy
```

---

## Links

- **GitHub:** [centralized-alert-management-system-aws](https://github.com/Ismaeldugg25/centralized-alert-management-system-aws)
