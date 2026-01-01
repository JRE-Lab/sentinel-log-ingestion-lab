diff --git a/LAB_GUIDE.md b/LAB_GUIDE.md
new file mode 100644
index 0000000000000000000000000000000000000000..4b9a37d9cc090ca110d7a5512b7e76fcf18be23c
--- /dev/null
+++ b/LAB_GUIDE.md
@@ -0,0 +1,144 @@
+# Microsoft Sentinel Log Ingestion & KQL Queries Lab (Markdown Guide)
+
+This lab walks you through provisioning a Log Analytics workspace, enabling Microsoft Sentinel, ingesting Azure Activity logs, and running KQL queries to validate ingestion and detect suspicious behavior.
+
+> **Audience:** Security analysts, SOC engineers, or students learning Microsoft Sentinel.
+>
+> **Time estimate:** 45–90 minutes.
+
+---
+
+## 1) Prerequisites
+
+- An Azure subscription with permission to create resources.
+- Azure CLI installed and authenticated (`az login`).
+- Bash shell (macOS/Linux/WSL). PowerShell users can still follow the manual steps.
+
+Optional:
+- Access to Microsoft Sentinel (typically via Log Analytics Workspace permissions).
+
+---
+
+## 2) Lab Topology
+
+You will create:
+
+- **Resource Group**
+- **Log Analytics Workspace**
+- **Microsoft Sentinel on the workspace**
+- **Azure Activity data ingestion**
+
+Then you will generate test activity so Azure Activity logs appear in Sentinel.
+
+---
+
+## 3) Provisioning (Automated)
+
+The repo includes scripts under `scripts/`. You can run the automated setup from the repo root.
+
+1. **Set environment variables (optional but recommended):**
+
+   ```bash
+   export LOCATION="eastus"
+   export RESOURCE_GROUP="rg-sentinel-lab"
+   export WORKSPACE_NAME="law-sentinel-lab-$RANDOM"
+   ```
+
+2. **Run the provisioning script:**
+
+   ```bash
+   ./scripts/provision-workspace.sh
+   ```
+
+   The script installs the `sentinel` Azure CLI extension if it is missing.
+
+3. **Enable Microsoft Sentinel (if automation is blocked):**
+
+   Some tenants require manual enablement. If the script reports a permission/preview error, use:
+
+   - Azure Portal → Microsoft Sentinel → Create → Select your Log Analytics workspace → Add.
+
+---
+
+## 4) Connect Azure Activity Logs
+
+1. Open **Microsoft Sentinel** in the Azure Portal.
+2. Choose your workspace.
+3. Go to **Content Hub** → search for **Azure Activity**.
+4. Install the **Azure Activity** solution if not already installed.
+5. Go to **Data connectors** → **Azure Activity** → **Open connector page**.
+6. Click **Connect** and ensure **Subscription** is selected.
+
+> It can take 5–15 minutes for activity to appear.
+
+---
+
+## 5) Generate Sample Activity
+
+Run the included script to generate standard Azure Activity logs by creating and deleting a storage account.
+
+```bash
+./scripts/generate-activity.sh
+```
+
+This creates activity events such as:
+
+- `Microsoft.Storage/storageAccounts/write`
+- `Microsoft.Storage/storageAccounts/delete`
+
+---
+
+## 6) Validate Ingestion with KQL
+
+Open **Logs** in the Sentinel workspace and run the queries from `queries/README.md`, or use these examples:
+
+```kusto
+AzureActivity
+| take 10
+```
+
+```kusto
+AzureActivity
+| where OperationNameValue has "Microsoft.Storage/storageAccounts"
+| project TimeGenerated, Caller, OperationNameValue, ActivityStatusValue, ResourceGroup
+| sort by TimeGenerated desc
+```
+
+```kusto
+AzureActivity
+| summarize count() by ActivityStatusValue
+```
+
+---
+
+## 7) Optional: Create a Simple Analytics Rule
+
+1. Sentinel → **Analytics** → **Create** → **Scheduled query rule**.
+2. Name: `Storage Account Deletion`
+3. Query:
+
+   ```kusto
+   AzureActivity
+   | where OperationNameValue == "Microsoft.Storage/storageAccounts/delete"
+   ```
+
+4. Schedule: every 5 minutes, lookback 1 hour.
+5. Create.
+
+---
+
+## 8) Cleanup
+
+To remove all created resources:
+
+```bash
+./scripts/cleanup.sh
+```
+
+---
+
+## Troubleshooting
+
+- **No logs in AzureActivity table:** ensure the Azure Activity data connector is connected, and wait up to 15 minutes.
+- **Permission errors:** confirm you have `Contributor` + `Log Analytics Contributor` or workspace-level access.
+- **Sentinel not enabling via script:** use the Azure Portal and confirm the workspace region supports Sentinel.
