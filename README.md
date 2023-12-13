
# Coworking Space Service Extension
The Coworking Space Service is a set of APIs that enables users to request one-time tokens and administrators to authorize access to a coworking space. This service follows a microservice pattern and the APIs are split into distinct services that can be deployed and managed independently of one another.

For this project, you are a DevOps engineer who will be collaborating with a team that is building an API for business analysts. The API provides business analysts basic analytics data on user activity in the service. The application they provide you functions as expected locally and you are expected to help build a pipeline to deploy it in Kubernetes.

## Getting Started

### Dependencies
#### Local Environment
1. `Python Environment`: Ensure compatibility with `Python 3.8+` to run applications and install Python dependencies using pip.
2. `Docker CLI`: Utilize the Docker command-line interface for building and running Docker images locally.
3. `kubectl`: Use the Kubernetes command-line tool for executing commands against a Kubernetes cluster.
4. `helm`: Apply Helm Charts to a Kubernetes cluster for efficient management and deployment.

#### Setup AWS services
1. Amazon EKS and Node Groups:
   Verify the policies associated with EKS and its node groups to ensure proper configuration
2. Amazon ECR:
   Configure Amazon Elastic Container Registry (ECR) to store Docker images after project builds.
3. AWS CodeBuild Setup:
   Set up AWS CodeBuild and integrate it with your GitHub account. Configure webhook events to trigger builds based on GitHub actions.

#### Setup workspace
1. Configure aws account, make sure you have correct role and permission
2. Install `postgres` with `helm` chart
3. Double check the deployment config and apply it for deployment, using port forward to run SQL; remember to init the DB with dummy data
4. Setup `CloudWatch`, remember to attach CloudWatch policy to EKS role and setup CloudWatch for it
   ```bash
      ClusterName=thanhnd2
      RegionName=us-east-1
      FluentBitHttpPort='2020'
      FluentBitReadFromHead='Off'
      [[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
      [[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
      curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/ k8s-deployment-manifest-templates/     deployment-mode/daemonset/container-insights-monitoring/quickstart/   cwagent-fluent-bit-quickstart.yaml | sed 's/{{cluster_name}}/'$    {ClusterName}'/;s/{{region_name}}/'${RegionName}'/;s/   {{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'$ {FluentBitHttpPort}'"/;s/{{read_from_head}}/"'$ {FluentBitReadFromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl      apply -f -
   ```
6. How to deploy?
   Push your updated code to `github` -> github will trigger webhook event to CodeBuile. It will run the build and push the Docker image to ECR. You can change the deployment image based on the new image by change the `thanhnd-coworking-api.yml`

