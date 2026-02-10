**Here's INTERVIEW_QUICK_REF.md - Your Interview Cheat Sheet:**

```markdown
# Interview Quick Reference - Keep This Handy!

## 🎯 Your 30-Second Elevator Pitch

"I've built an enterprise-grade absence tracking system demonstrating Infrastructure as Code with Terraform, configuration management with Ansible, and SRE principles with CloudWatch monitoring. The architecture uses modular Terraform design with remote state management, security best practices including private subnets and least-privilege IAM, and SLO-based monitoring tracking 99.9% workflow reliability. The system is fully automated from deployment to configuration, with proper Git workflow and documentation."

---

## 📊 Key Numbers to Remember

- **SLOs:**
  - Form availability: 99% (7.2 hours downtime/month allowed)
  - Submission success: 99.5%
  - Workflow execution: 99.9%
  - Notification latency: 95% under 2 minutes

- **Cost optimization:** 40% infrastructure cost reduction (from resume)
- **Incident reduction:** 70% fewer incidents (from resume)
- **Uptime achieved:** 99.9% (from resume)

---

## 🏗️ Architecture Components (Memorize This Order)

1. **Frontend:** S3 + CloudFront (static HTML form)
2. **Networking:** VPC with public/private subnets, security groups
3. **Compute:** EC2 instance running n8n in Docker
4. **Load Balancing:** ALB with health checks
5. **Monitoring:** CloudWatch dashboards + alarms
6. **State Management:** S3 + DynamoDB backend

---

## 💬 Common Questions & Concise Answers

### "Walk me through your bootstrap process"
"Bootstrap solves the chicken-and-egg problem of remote state. I use a separate Terraform config with local state to create the S3 bucket and DynamoDB table. These resources have prevent_destroy lifecycle rules. The bucket has versioning and encryption. DynamoDB provides distributed locking. After creation, main infrastructure uses this backend for team collaboration and state safety."

### "Why modules instead of monolithic config?"
"Modules provide reusability, maintainability, and testability. Each module has a single responsibility. Changes are isolated. The networking module is reusable across projects. Modules can be tested independently before integration. This matches production best practices for team collaboration."

### "How does state locking prevent conflicts?"
"When terraform apply runs, it writes a lock item to DynamoDB with the state file path. Other operations see the lock and wait or fail. When apply completes, lock is released. This prevents concurrent modifications from corrupting state. DynamoDB provides strong consistency for distributed locking."

### "Why Ansible instead of Terraform provisioners?"
"Provisioners break Terraform's declarative model and can't be tested easily. Ansible is purpose-built for configuration management. It's idempotent, has better error handling, and can be run independently for configuration drift correction. Separation of concerns: Terraform for infrastructure, Ansible for application config."

### "How do you measure your SLOs?"
"Multi-layer approach: CloudFront metrics for form availability, ALB success rate for submission completion, n8n API/webhooks publishing custom CloudWatch metrics for workflow execution. I set alarms at 90% of error budget consumption for proactive alerts before SLO breach. Monthly reports track error budget usage."

### "Your approach to secrets management?"
"Never commit to Git. Use AWS Secrets Manager for production. Environment variables for local dev. Terraform references secrets via data sources, never hardcoded. IAM roles limit access. Secrets rotation automated. CI/CD injects secrets at runtime from secure vaults."

### "Describe your Git workflow"
"Feature branches for all changes. Pull requests required for main branch. PR includes terraform plan output for review. Peer review catches issues before deployment. After merge, CI/CD runs terraform apply. This ensures infrastructure changes are validated before production."

### "How do you handle Terraform state file security?"
"Remote state in S3 with encryption at rest. Versioning enabled for recovery. Public access blocked. IAM policies restrict access to infrastructure team only. DynamoDB locking prevents concurrent modifications. Bootstrap state is special case - committed to Git because it rarely changes and aids disaster recovery."

---

## 🔧 Technical Details to Drop Naturally

- "I use `data.aws_caller_identity` to dynamically generate unique bucket names"
- "Implemented prevent_destroy lifecycle rules on critical resources"
- "Multi-AZ deployment for high availability"
- "Zero-trust security with private subnets and security group restrictions"
- "Error budgets track acceptable failure rate: 99.9% SLO = 0.1% error budget"
- "Immutable infrastructure approach with AMI baking for production"
- "Observability strategy: metrics, logs, traces with CloudWatch"

---

## ⚠️ Tradeoffs to Acknowledge

**Good engineers acknowledge limitations:**

- "For this demo, I used provisioners for speed. Production would use Packer AMIs or ECS."
- "Currently single EC2 instance. Production would use Auto Scaling Group."
- "Using default VPC for demo. Production would have custom VPC with proper CIDR planning."
- "Monitoring is basic CloudWatch. Production would add Prometheus/Grafana."
- "Currently us-east-1 only. Production would be multi-region with Route53 failover."

---

## 🎤 Questions to Ask Them

**Technical:**
1. "What's your current state of infrastructure automation maturity?"
2. "How do you handle multi-cloud or hybrid cloud complexity with Terraform?"
3. "What's your approach to error budgets and balancing reliability vs velocity?"
4. "How does your SRE team collaborate with development on reliability requirements?"

**Role-Specific:**
5. "What are the biggest automation challenges the team faces currently?"
6. "What does success look like in this role during the first 90 days?"
7. "How do you approach on-call rotation and incident response?"

---

## 🚀 Power Phrases

- "I take an SRE approach to infrastructure reliability"
- "Security is built-in from the start, not bolted on"
- "I believe in infrastructure as code for repeatability and version control"
- "Error budgets help balance reliability with feature velocity"
- "Observability is key - you can't improve what you don't measure"
- "I prefer immutable infrastructure over configuration drift management"
- "Automation should be idempotent and handle failure gracefully"

---

## 🎯 Your Unique Selling Points

1. **Teaching background:** "I can mentor team members effectively"
2. **Business acumen:** "PhD + PMP candidate shows I understand ROI and stakeholder management"
3. **Proven results:** "40% cost reduction, 70% fewer incidents, 99.9% uptime"
4. **Learning agility:** "Built this entire demo while studying for Terraform Associate"
5. **Production mindset:** "I think about security, cost, and maintainability from day one"

---

## 🧠 Mental Models

**When stuck, use this framework:**

"Let me think through this systematically:
1. What problem are we solving?
2. What are the constraints?
3. What are the tradeoffs?
4. How would I validate this works?
5. How would I monitor/maintain it?"

---

## ⏰ Time Management During Demo

- **First 2 minutes:** Architecture overview (high-level)
- **Next 5 minutes:** Walk through code/modules
- **Next 3 minutes:** Show CloudWatch monitoring
- **Last 2 minutes:** Discuss tradeoffs and production considerations
- **Reserve time:** Questions from them

---

## 🎬 Demo Flow

1. Open GitHub repo - show clean structure
2. Explain bootstrap process (briefly)
3. Show modules directory - explain each
4. Open CloudWatch dashboard - live metrics
5. Show terraform output - infrastructure deployed
6. Discuss SLOs and monitoring strategy
7. Talk about next steps for production

**Practice this 3 times before the interview!**

