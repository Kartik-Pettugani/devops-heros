# Lecture 12

# SECTION 2: Detailed Workflow, Instructions, Commands & Screenshot Requirements

Navigate to the Session 12 directory in the course repository:

```bash
cd session-12-ingress-configmaps-secrets
```

---

### Task 1: Non-Sensitive Configuration Decoupling via ConfigMaps

- **Short Description:** Decouple environment-specific runtime configurations (log levels, ports, currency settings) from container images by storing them in a declarative `ConfigMap`.
- **Workflow:**
    1. Review `01-configmap/app-config.yaml`.
    2. Apply the manifest to the cluster.
    3. Inspect the stored keys and verify the payload using `describe` and JSONPath queries.
- **Commands to Run:**
    
    ```bash
    kubectl apply -f 01-configmap/app-config.yaml
    kubectl get configmap yatri-app-config
    kubectl describe configmap yatri-app-config
    kubectl get configmap yatri-app-config -o jsonpath='{.data.ENVIRONMENT}' && echo ""
    kubectl get configmap yatri-app-config -o jsonpath='{.data.LOG_LEVEL}' && echo ""
    ```
- **Output:**
![Screenshot](./screenshots/1.png)
---

### Task 2: ConfigMap Live Update & Pod Immobility Verification Drill

- **Short Description:** Demonstrate that updating a `ConfigMap` does **not** retroactively update environment variables inside active running containers, and use `kubectl rollout restart` to trigger a zero-downtime rolling update.
- **Workflow:**
    1. Patch the active `yatri-app-config` ConfigMap to change `ENVIRONMENT` from `production` to `staging`.
    2. Query the running pod's environment directly using `kubectl exec` to show that the variable did not change.
    3. Perform a rolling restart on the deployment.
    4. Verify the new pod instances picked up `ENVIRONMENT=staging`.
- **Commands to Run:**
    
    ```bash
    # Step 1: Patch ConfigMap live
    kubectl patch configmap yatri-app-config --type merge -p '{"data":{"ENVIRONMENT":"staging"}}'
    
    # Step 2: Check running pod env (assuming backend pod from 04-full-demo is running)
    kubectl exec -it deploy/yatri-backend -- env | grep ENVIRONMENT
    
    # Step 3: Trigger rolling restart
    kubectl rollout restart deployment/yatri-backend
    kubectl rollout status deployment/yatri-backend
    
    # Step 4: Re-check pod env
    kubectl exec -it deploy/yatri-backend -- env | grep ENVIRONMENT
    
    # Step 5: Revert patch for subsequent labs
    kubectl patch configmap yatri-app-config --type merge -p '{"data":{"ENVIRONMENT":"production"}}'
    kubectl rollout restart deployment/yatri-backend
    ```

---

### Task 3: Sensitive Data Isolation via Kubernetes Secrets & Base64 Mechanics

- **Short Description:** Implement credential isolation using an `Opaque` Kubernetes `Secret`, illustrating that Base64 is merely an encoding scheme (not encryption) that can be decoded on the CLI.
- **Workflow:**
    1. Review `02-secret/db-secret.yaml`.
    2. Apply the manifest to store database user and password credentials.
    3. Verify that `kubectl describe secret` masks the values for security.
    4. Imperatively extract and decode the password to confirm the plaintext value.
- **Commands to Run:**
    
    ```bash
    kubectl apply -f 02-secret/db-secret.yaml
    kubectl get secret yatri-db-secret
    kubectl describe secret yatri-db-secret
    kubectl get secret yatri-db-secret -o jsonpath='{.data.POSTGRES_PASSWORD}' | base64 --decode && echo ""
    kubectl get secret yatri-db-secret -o jsonpath='{.data.POSTGRES_USER}' | base64 --decode && echo ""
    ```
- **Output:**
![Screenshot](./screenshots/3.png)
---

### Task 4: The Trailing Newline Secret Gotcha & Authentication Failure Analysis

- **Short Description:** Analyze the common authentication bug where encoding with standard `echo` appends an invisible ASCII newline (`\n` / `0x0A`), corrupting passwords sent to backend databases.
- **Workflow:**
    1. Encode a test string with standard `echo` and inspect its hexadecimal binary representation using `xxd` or `hexdump`.
    2. Encode the test string with `echo -n` to demonstrate suppression of the newline byte.
    3. Decode both strings to document the payload corruption.
- **Commands to Run:**
    
    ```bash
    # Broken pattern: appends 0x0a (\n)
    echo "secretpassword" | xxd
    echo "secretpassword" | base64
    
    # Correct pattern: exact byte stream
    echo -n "secretpassword" | xxd
    echo -n "secretpassword" | base64
    
    # Visual comparison
    echo "Wrong (with newline): $(echo "secretpassword" | base64)"
    echo "Right (no newline):   $(echo -n "secretpassword" | base64)"
    ```
- **Output:**
![Screenshot](./screenshots/4.png)
---

### Task 5: Enterprise Secret Management & Pipeline Integration

### The Vulnerability

    Kubernetes Secret values are Base64-encoded, not encrypted simply because they are Base64.

    Committing Secret YAML files to Git creates security risks:

    - **Git history retention:** Even if a secret is later removed, it may remain in previous commits.
    - **RBAC exposure:** Anyone with access to the repository or Kubernetes Secret resources may potentially access credentials.
    - **Difficult rotation:** Credentials stored directly in manifests require changes to configuration and redeployment.
    - **Repository exposure:** A compromised repository can expose credentials to unauthorized users.

    Therefore, production systems should avoid committing plaintext credentials or Base64-encoded Secret values to application repositories.

### External Secret Management

    Enterprise environments commonly store sensitive credentials in dedicated secret-management systems such as:

    - AWS Secrets Manager
    - Azure Key Vault
    - HashiCorp Vault

    Tools such as **External Secrets Operator (ESO)** can synchronize credentials from an external secret manager into Kubernetes Secrets.

    ```text
    ┌──────────────────────────┐
    │ AWS Secrets Manager      │
    │ Azure Key Vault          │
    │ HashiCorp Vault          │
    └────────────┬─────────────┘
                │
                │ Secure retrieval
                ▼
    ┌──────────────────────────┐
    │ External Secrets         │
    │ Operator (ESO)           │
    └────────────┬─────────────┘
                │
                │ Synchronizes
                ▼
    ┌──────────────────────────┐
    │ Kubernetes Secret        │
    └────────────┬─────────────┘
                │
                ├──────────────► Pod Environment Variable
                │
                └──────────────► Pod Volume


---

### Task 6: Combined ConfigMap and Secret Pod Injection Architecture

- **Short Description:** Deploy a backend pod that simultaneously consumes configuration from both a `ConfigMap` and a `Secret`, verifying that both sources merge cleanly into the container's environment.
- **Workflow:**
    1. Review `04-full-demo/backend.yaml` to observe `envFrom.configMapRef` and `env.valueFrom.secretKeyRef`.
    2. Deploy the backend application and its corresponding `ClusterIP` Service.
    3. Execute `env` inside the running container to verify the coexistence of both datasets.
- **Commands to Run:**
    
    ```bash
    kubectl apply -f 04-full-demo/configmap.yaml
    kubectl apply -f 04-full-demo/secret.yaml
    kubectl apply -f 04-full-demo/backend.yaml
    kubectl rollout status deployment/yatri-backend
    
    # Verify injection inside pod
    kubectl exec -it deploy/yatri-backend -- env | grep -E "ENVIRONMENT|LOG_LEVEL|POSTGRES|DEFAULT_CURRENCY"
    ```
- **Output:**
![Screenshot](./screenshots/6.png)

---

### Task 7: Architectural Comparative Study — Ingress Resource vs. Ingress Controller

- **Short Description:** Provide a conceptual and technical breakdown of the division of responsibilities between an `Ingress` rule manifest and an `Ingress Controller`.
- **Workflow:**
    1. Document the comparison table in your report:
        - **Ingress Resource:** Declarative Kubernetes Layer 7 API specification (contains hostnames, paths, TLS cert references, target service names). Does nothing by itself.
        - **Ingress Controller:** Active reverse proxy pod (NGINX, Traefik, HAProxy, Envoy) that runs a control loop, monitors the API Server for `Ingress` objects, dynamically generates proxy configuration (e.g., `nginx.conf`), and reloads its engine to route real network traffic.
- **Commands to Run:**
    
    ```bash
    # Show that Ingress API exists natively
    kubectl api-resources | grep -i ingress
    ```
    
| Aspect | Ingress Resource | Ingress Controller |
|---|---|---|
| **Role** | Declarative Layer 7 routing specification | Active reverse-proxy implementation |
| **Type** | Kubernetes API object | Running controller/application |
| **Contains** | Hosts, paths, TLS references, target Services | Proxy configuration and routing logic |
| **Examples** | `Ingress` YAML manifest | NGINX, Traefik, HAProxy, Envoy |
| **Traffic Handling** | Does not handle traffic itself | Receives and routes actual network traffic |
| **Control Loop** | No control loop | Watches Kubernetes API for Ingress changes |
| **Configuration** | Defines desired routing rules | Converts rules into proxy configuration |
| **Example** | `/api → backend-service` | NGINX/Traefik implements `/api → backend-service` |
| **Works Alone?** | No | Requires routing configuration such as Ingress resources |
                 Kubernetes API Server
                         │
                         │
                         ▼
                 ┌─────────────────┐
                 │ Ingress Resource│
                 │                 │
                 │ host/path rules │
                 │ TLS references  │
                 │ target Services │
                 └────────┬────────┘
                          │
                          │ watches
                          ▼
                 ┌────────────────────┐
                 │ Ingress Controller │
                 │                    │
                 │ NGINX / Traefik /  │
                 │ HAProxy / Envoy    │
                 └─────────┬──────────┘
                           │
                           │ routes traffic
                           ▼
                ┌─────────────────────┐
                │ Kubernetes Services │
                └──────────┬──────────┘
                           │
                           ▼
                         Pods
- **Output:**
![Screenshot](./screenshots/7.png)
---

### Task 8: NGINX Ingress Controller Activation & Lifecycle Verification

- **Short Description:** Enable and verify the NGINX Ingress Controller daemon on Minikube, validating the pod lifecycle within the `ingress-nginx` namespace.
- **Workflow:**
    1. Enable the Minikube Ingress addon.
    2. Observe the creation of the Ingress Controller deployment, pods, and admission webhooks.
    3. Wait until the controller pod reaches a healthy `Running` and `Ready` state.
- **Commands to Run:**
    
    ```bash
    minikube addons enable ingress
    kubectl get pods -n ingress-nginx
    kubectl wait --namespace ingress-nginx \
      --for=condition=ready pod \
      --selector=app.kubernetes.io/component=controller \
      --timeout=120s
    kubectl get service -n ingress-nginx
    ```
- **Output:**
![Screenshot](./screenshots/8.png)
---

### Task 9: Local DNS Resolution & System Hosts File Mapping

- **Short Description:** Configure host-level local DNS name resolution by binding the Minikube VM/Docker IP to the custom domain `yatri.local` in `/etc/hosts`.
- **Workflow:**
    1. Retrieve the Minikube cluster IP address.
    2. Append the hostname mapping to your local workstation's `/etc/hosts` file.
    3. Ping or query the domain locally to confirm resolution.
- **Commands to Run:**
    
    ```bash
    MINIKUBE_IP=$(minikube ip)
    echo "Minikube IP is: ${MINIKUBE_IP}"
    
    # Append to /etc/hosts if not already present
    if ! grep -q "yatri.local" /etc/hosts; then
      echo "${MINIKUBE_IP}  yatri.local" | sudo tee -a /etc/hosts
    fi
    
    # Verify entry
    grep "yatri.local" /etc/hosts
    ```
- **Output:**
![Screenshot](./screenshots/9.png)
---

### Task 10: Layer 7 Path-Based Routing Implementation

- **Short Description:** Implement path-based Layer 7 traffic routing using an Ingress resource, directing `/` to the frontend Nginx service and `/api/*` to the backend Python API service.
- **Workflow:**
    1. Review `04-full-demo/ingress.yaml` and verify the `rewrite-target: /$2` and regex annotations.
    2. Deploy `frontend.yaml` and apply `ingress.yaml`.
    3. Send HTTP requests to both paths and verify traffic lands on the correct microservice.
- **Commands to Run:**
    
    ```bash
    kubectl apply -f 04-full-demo/frontend.yaml
    kubectl apply -f 04-full-demo/backend.yaml
    kubectl apply -f 04-full-demo/ingress.yaml
    
    kubectl get ingress yatri-ingress
    kubectl describe ingress yatri-ingress
    
    # Test Frontend path (Root /)
    curl -s <http://yatri.local/> | grep -i "<title>"
    
    # Test Backend path (/api/)
    curl -s <http://yatri.local/api/>
    ```
- **Output:**
![Screenshot](./screenshots/10a.png)
![Screenshot](./screenshots/10b.png)
![Screenshot](./screenshots/10c.png)
---

### Task 11: Virtual Host-Based Routing (Subdomain Routing)

- **Short Description:** Deploy an Ingress configuration that routes incoming requests based on virtual hostnames (`portal.campus.local` vs. `api.campus.local`) targeting the same external IP.
- **Workflow:**
    1. Inspect `03-ingress/ingress-tls.yaml` rules section (focusing on the separate `host:` declarations).
    2. Add `portal.campus.local` and `api.campus.local` to `/etc/hosts`.
    3. Use `curl -H "Host: <domain>"` or configure DNS to verify host-isolated routing.
- **Commands to Run:**
    
    ```bash
    MINIKUBE_IP=$(minikube ip)
    echo "${MINIKUBE_IP}  portal.campus.local api.campus.local" | sudo tee -a /etc/hosts
    
    # Verify routing by Host Header
    curl -s -H "Host: portal.campus.local" <http://$>{MINIKUBE_IP}/ | grep -i "<title>"
    curl -s -H "Host: api.campus.local" <http://$>{MINIKUBE_IP}/api/
    ```
- **Output:**
![Screenshot](./screenshots/11a.png)
![Screenshot](./screenshots/11b.png)
---

### Task 12: Hybrid Ingress Routing Architecture

- **Short Description:** Construct and validate an Ingress resource that merges both multi-tenant virtual host routing and path-based routing in a single configuration.
- **Workflow:**
    1. Review `03-ingress/ingress-tls.yaml`.
    2. Verify that `portal.campus.local` routes to the frontend on `/` while `api.campus.local` routes to the backend on `/api` and other paths.
    3. Apply and describe the resource to verify the routing table.
- **Commands to Run:**
    
    ```bash
    kubectl apply -f 03-ingress/ingress-tls.yaml
    kubectl get ingress campus-ingress-tls
    kubectl describe ingress campus-ingress-tls
    ```
- **Output:**
![Screenshot](./screenshots/12.png)
---

### Task 13: Ingress TLS/HTTPS Termination & Secret Binding

- **Short Description:** Configure SSL/TLS termination on an Ingress by generating a self-signed certificate, creating a `kubernetes.io/tls` secret, and serving traffic securely over HTTPS port `443`.
- **Workflow:**
    1. Generate an RSA private key and self-signed X.509 certificate using `openssl`.
    2. Create an `Opaque` TLS secret with `kubectl create secret tls`.
    3. Attach the `tls:` block in `ingress-tls.yaml`.
    4. Test secure HTTPS termination using `curl -k` on port 443.
- **Commands to Run:**
    
    ```bash
    # Step 1: Generate TLS Keypair
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout tls.key \
      -out tls.crt \
      -subj "/CN=campus.local/O=CampusDevOps"
    
    # Step 2: Store in Kubernetes Secret
    kubectl create secret tls campus-tls-cert --cert=tls.crt --key=tls.key
    kubectl get secret campus-tls-cert
    
    # Step 3: Apply TLS Ingress
    kubectl apply -f 03-ingress/ingress-tls.yaml
    kubectl get ingress campus-ingress-tls
    
    # Step 4: Verify HTTPS handshake over port 443
    INGRESS_IP=$(minikube ip)
    curl -k -v --resolve portal.campus.local:443:${INGRESS_IP} <https://portal.campus.local/> 2>&1 | grep -E "Server certificate|HTTP/|SSL connection"
    ```
- **Output:**
![Screenshot](./screenshots/13a.png)
![Screenshot](./screenshots/13b.png)
![Screenshot](./screenshots/13c.png)
![Screenshot](./screenshots/13d.png)
---

### Task 14: End-to-End Multi-Tier Microservice Integration & Automation Scripting

- **Short Description:** Execute the comprehensive full-lifecycle automation scripts (`run-demo.sh` and `cleanup.sh`), analyzing multi-document YAML manifests (`--`) and verifying complete infrastructure cleanup.
- **Workflow:**
    1. Inspect `04-full-demo/backend.yaml` and `04-full-demo/frontend.yaml` to analyze multi-document YAML syntax (`--`) co-locating Deployments and Services.
    2. Run `run-demo.sh` to execute the full automated build.
    3. Validate all components with a single `kubectl get` command.
    4. Run `cleanup.sh` and verify all lab resources are deleted.
- **Commands to Run:**
    
    ```bash
    # Execute full automated deployment
    bash 04-full-demo/run-demo.sh
    
    # Audit entire stack state
    kubectl get configmap,secret,ingress,deploy,svc,pods -l app=yatri-app
    
    # Execute automated teardown
    bash 04-full-demo/cleanup.sh
    
    # Confirm clean state
    kubectl get ingress yatri-ingress || echo "Ingress deleted"
    kubectl get deployment yatri-backend yatri-frontend || echo "Deployments deleted"
    ```
- **Output:**
![Screenshot](./screenshots/14a.png)
![Screenshot](./screenshots/14b.png)

---