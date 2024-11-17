# DevOpsStats
To retrieve an organization's devops repositories stats, like commits, changes per commit

Key points

Infrastructure as Code (Terraform)
Azure Cloud (Azure Container Apps)
Fast endpoints
RabbitMQ

Terraform Folder Structure for Backend and Main Resources
This project separates backend infrastructure (e.g., resource group, storage account, and blob container for Terraform state) from main application resources to ensure a clean and modular approach to managing infrastructure.

Folder Structure
plaintext
Copy code
├── backend/
│   ├── backend.tf            # Defines backend resources (e.g., resource group, storage account)
│   ├── variables.tf          # Variables used for backend resources
├── main/
│   ├── main.tf               # Defines main application resources (e.g., Log Analytics, RabbitMQ app)
│   ├── backend.tf            # Specifies the backend configuration for Terraform state
│   ├── variables.tf          # Variables used for main resources
├── terraform.tfvars          # Shared variable values (e.g., subscription ID, RabbitMQ credentials)

Backend Folder
The backend folder is responsible for managing:

<ul> <li>Resource Group for all infrastructure (<code>rabbitmq-resource-group</code>)</li> <li>Storage Account (<code>rabbitmqtfstate</code>) and Blob Container (<code>tfstate</code>) for Terraform state</li> </ul>
Steps:
<ol> <li>Initialize Terraform in the <code>backend/</code> folder:</li> </ol>
bash
Copy code
cd backend
terraform init
terraform apply
<ol start="2"> <li>This will create the required backend infrastructure. The storage account and blob container will store the Terraform state for the <code>main/</code> folder.</li> </ol>
Main Folder
The main folder defines the application-specific resources:

<ul> <li>Log Analytics Workspace</li> <li>Container App Environment</li> <li>RabbitMQ Container App</li> </ul>
The backend state from the backend folder is referenced using the backend "azurerm" block.

Steps:
<ol> <li>Initialize Terraform in the <code>main/</code> folder:</li> </ol>
bash
Copy code
cd main
terraform init
<ol start="2"> <li>Apply the configuration:</li> </ol>
bash
Copy code
terraform apply
Shared Variables
A single terraform.tfvars file is shared across both folders to centralize variable values. For example:

<pre><code>terraform.tfvars subscription_id = "your-subscription-id" rabbitmq_default_user = "admin" rabbitmq_default_pass = "securepassword" </code></pre>
To use this file, pass it during commands:

bash
Copy code
terraform plan -var-file=../terraform.tfvars
terraform apply -var-file=../terraform.tfvars
Alternatively, create symbolic links (ln -s) in each folder for easier access.

Advantages of Folder Splitting
<ul> <li><strong>Modularity:</strong> Separates backend state management from application-specific resources. Prevents accidental modification of critical backend infrastructure.</li> <li><strong>Reusability:</strong> The backend resources can be shared across multiple projects or environments.</li> <li><strong>Simplicity:</strong> Main resources can focus on application infrastructure without managing state-related dependencies.</li> </ul>
