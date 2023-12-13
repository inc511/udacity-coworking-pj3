
# Coworking Space Service Extension
The Coworking Space Service is a set of APIs that enables users to request one-time tokens and administrators to authorize access to a coworking space. This service follows a microservice pattern and the APIs are split into distinct services that can be deployed and managed independently of one another.

For this project, you are a DevOps engineer who will be collaborating with a team that is building an API for business analysts. The API provides business analysts basic analytics data on user activity in the service. The application they provide you functions as expected locally and you are expected to help build a pipeline to deploy it in Kubernetes.

## Getting Started

### Dependencies
#### Local Environment
1. Python Environment - run Python 3.6+ applications and install Python dependencies via `pip`
2. Docker CLI - build and run Docker images locally
3. `kubectl` - run commands against a Kubernetes cluster
4. `helm` - apply Helm Charts to a Kubernetes cluster

#### Setup AWS services
1. `EKS` and its `node group` double check all the policies
2. `ECR` to store the docker image after build the project
3. Setup `Codebuild` and link it with your `github` account, remember to config the webhook event to trigger your build based on action.

#### Setup workspace
1. Configure aws account
    `aws configure`
    Remember you can insert the session token with
    `aws configure set aws_session_token <YOUR_AWS_SESSION_TOKEN>`
2. Install `postgres` with `helm` chart
   ```bash
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update
    helm install coworking-space bitnami/postgresql --set primary.  persistence.enabled=false
   ```
    Export your password and replace the db-secret with it after encode base64
    ```bash
    export POSTGRES_PASSWORD=$(kubectl get secret --namespace default coworking-space-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
    ```
    Connect with your DB
    ```bash
    kubectl port-forward --namespace default svc/coworking-space-postgresql 5432:5432 & PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432
    ```
    Install `psql`
    ```bash
    pip install --upgrade pip
    sudo apt update
    sudo apt install postgresql-client
    sudo apt-get install build-essential libpq-dev
    ```
    Init the db with
    ```bash
    kubectl port-forward --namespace default svc/coworking-space-postgresql 5432:5432 & PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432 < db/1_create_tables.sql
    psql --host 127.0.0.1 -U postgres -d postgres -p 5432 < db/2_seed_users.sql
    psql --host 127.0.0.1 -U postgres -d postgres -p 5432 < db/3_seed_tokens.sql
    ```
3. Double check the deployment config and run
   ```bash
   kubectl apply -f ./deployment/
   ```
4. Run your app local
   ```bash
   cd analytics
   pip install -r requirements.txt
    pip install --upgrade wheel
    DB_USERNAME=postgres DB_PASSWORD=KbRnvMoeX6 python app.py
   ```
5. Setup `CloudWatch`, remember to attach CloudWatch policy to EKS role. After that, run
   ```bash
   ClusterName=thanhnd2
    RegionName=us-east-1
    FluentBitHttpPort='2020'
    FluentBitReadFromHead='Off'
    [[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
    [[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
    curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-    fluent-bit-quickstart.yaml | sed 's/{{cluster_name}}/'${ClusterName}'/;s/{{region_name}}/'${RegionName}'/;s/{{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'${FluentBitHttpPort}'"/;s/{{read_from_head}}/"'${FluentBitRead    FromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl apply -f -
   ```
