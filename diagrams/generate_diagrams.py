from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.network import ELB, CloudFront, VPC, NATGateway, InternetGateway
from diagrams.aws.storage import S3
from diagrams.aws.management import Cloudwatch
from diagrams.aws.integration import SNS
from diagrams.aws.security import IAMRole
from diagrams.onprem.client import Users

# Configure diagram settings
graph_attr = {
    "fontsize": "16",
    "bgcolor": "white",
    "pad": "0.5"
}

# Full System Architecture
with Diagram(
    "Staff Absence Request System - Architecture", 
    filename="output/architecture",
    outformat="png",
    show=False,
    graph_attr=graph_attr,
    direction="TB"  # Top to Bottom
):
    
    # Users
    teachers = Users("Teachers")
    principal = Users("Principal")
    
    # Frontend Layer
    with Cluster("Frontend (Static Content)"):
        s3_frontend = S3("HTML Form\nStorage")
        cloudfront = CloudFront("CDN\nDistribution")
        
        s3_frontend >> cloudfront
    
    # Network Layer
    with Cluster("VPC (10.0.0.0/16)"):
        igw = InternetGateway("Internet\nGateway")
        
        with Cluster("Public Subnets"):
            nat = NATGateway("NAT\nGateway")
            alb = ELB("Application\nLoad Balancer\n(HTTPS)")
        
        with Cluster("Private Subnet"):
            ec2 = EC2("n8n Server\n(Docker)")
            
        # Network flow
        igw >> alb
        alb >> ec2
        ec2 >> nat >> igw
    
    # Security & Access
    with Cluster("Security & Monitoring"):
        iam = IAMRole("EC2 IAM Role\n(SSM, CloudWatch)")
        cw_alarms = Cloudwatch("CloudWatch\nAlarms")
        sns = SNS("SNS Alerts\nEmail")
        
        cw_alarms >> sns
    
    # User flows
    teachers >> cloudfront >> Edge(label="Submit Form") >> alb
    alb >> Edge(label="Webhook") >> ec2
    ec2 >> Edge(label="Approval Email") >> principal
    principal >> Edge(label="Approve/Deny") >> ec2
    
    # Monitoring
    ec2 >> Edge(label="Metrics", style="dashed") >> cw_alarms
    alb >> Edge(label="Metrics", style="dashed") >> cw_alarms
    cloudfront >> Edge(label="Metrics", style="dashed") >> cw_alarms
    
    # IAM
    iam - Edge(style="dotted") - ec2

print("✅ Architecture diagram generated: output/architecture.png")

# ========================================
# Network Topology Diagram
# ========================================
with Diagram(
    "Network Topology - VPC Design",
    filename="output/network_topology",
    outformat="png",
    show=False,
    graph_attr=graph_attr,
    direction="TB"
):
    
    internet = Users("Internet")
    
    with Cluster("VPC (10.0.0.0/16)"):
        igw = InternetGateway("Internet Gateway")
        
        with Cluster("Availability Zone: us-east-1a"):
            with Cluster("Public Subnet\n(10.0.1.0/24)"):
                alb1 = ELB("ALB\n(AZ-1a)")
                nat = NATGateway("NAT Gateway\n(Elastic IP)")
            
            with Cluster("Private Subnet\n(10.0.10.0/24)"):
                ec2 = EC2("n8n Server\n(No Public IP)")
        
        with Cluster("Availability Zone: us-east-1b"):
            with Cluster("Public Subnet\n(10.0.2.0/24)"):
                alb2 = ELB("ALB\n(AZ-1b)")
        
        # Routing
        internet >> igw >> Edge(label="Public Route Table") >> alb1
        internet >> igw >> Edge(label="Public Route Table") >> alb2
        alb1 >> Edge(label="Port 5678", color="blue") >> ec2
        alb2 >> Edge(label="Port 5678", color="blue") >> ec2
        ec2 >> Edge(label="Outbound\n(API Calls)", color="green") >> nat >> igw

print("✅ Network topology diagram generated: output/network_topology.png")

# ========================================
# Monitoring & Observability Flow
# ========================================
with Diagram(
    "Monitoring & Observability",
    filename="output/monitoring_flow",
    outformat="png",
    show=False,
    graph_attr=graph_attr,
    direction="LR"  # Left to Right
):
    
    # Infrastructure Components
    with Cluster("Infrastructure"):
        ec2_mon = EC2("EC2 Instance")
        alb_mon = ELB("ALB")
        cloudfront_mon = CloudFront("CloudFront")
    
    # CloudWatch Layer
    with Cluster("CloudWatch Monitoring"):
        with Cluster("Metrics"):
            ec2_metrics = Cloudwatch("EC2 Metrics\n(CPU, Status)")
            alb_metrics = Cloudwatch("ALB Metrics\n(Targets, 5xx)")
            cf_metrics = Cloudwatch("CF Metrics\n(Error Rate)")
        
        with Cluster("Alarms"):
            alarm_ec2 = Cloudwatch("EC2 Status\nCheck Alarm")
            alarm_alb = Cloudwatch("Unhealthy\nTarget Alarm")
            alarm_slo = Cloudwatch("Response Time\nSLO Alarm")
    
    # Alerting
    sns_alert = SNS("SNS Topic")
    admin = Users("Admin\nEmail")
    
    # Flow
    ec2_mon >> Edge(label="Status Checks\n(60s)", style="dashed") >> ec2_metrics
    alb_mon >> Edge(label="Health Checks\n(60s)", style="dashed") >> alb_metrics
    cloudfront_mon >> Edge(label="Error Rate\n(300s)", style="dashed") >> cf_metrics
    
    ec2_metrics >> Edge(label="Threshold: ≥1") >> alarm_ec2
    alb_metrics >> Edge(label="Threshold: ≥1") >> alarm_alb
    alb_metrics >> Edge(label="p95 > 2s") >> alarm_slo
    
    alarm_ec2 >> sns_alert
    alarm_alb >> sns_alert
    alarm_slo >> sns_alert
    
    sns_alert >> Edge(label="Email\nNotification") >> admin

print("✅ Monitoring flow diagram generated: output/monitoring_flow.png")

print("\n" + "="*50)
print("All diagrams generated successfully!")
print("="*50)
print("\nGenerated files:")
print("  - output/architecture.png")
print("  - output/network_topology.png")
print("  - output/monitoring_flow.png")