diff --git a/scripts/generate-activity.sh b/scripts/generate-activity.sh
new file mode 100755
index 0000000000000000000000000000000000000000..660bb66bbf8fe7220c66217a3a5492c1b1f9ab95
--- /dev/null
+++ b/scripts/generate-activity.sh
@@ -0,0 +1,41 @@
+#!/usr/bin/env bash
+set -euo pipefail
+
+RESOURCE_GROUP="${RESOURCE_GROUP:-rg-sentinel-lab}"
+LOCATION="${LOCATION:-eastus}"
+STORAGE_NAME="${STORAGE_NAME:-sentsalab$RANDOM$RANDOM}"
+
+if ! command -v az >/dev/null 2>&1; then
+  echo "Azure CLI (az) not found. Please install it before running this script."
+  exit 1
+fi
+
+if ! az account show >/dev/null 2>&1; then
+  echo "Azure CLI is not authenticated. Run: az login"
+  exit 1
+fi
+
+echo "Ensuring resource group exists: ${RESOURCE_GROUP}"
+az group create --name "${RESOURCE_GROUP}" --location "${LOCATION}" >/dev/null
+
+echo "Creating storage account to generate Azure Activity logs: ${STORAGE_NAME}"
+az storage account create \
+  --name "${STORAGE_NAME}" \
+  --resource-group "${RESOURCE_GROUP}" \
+  --location "${LOCATION}" \
+  --sku Standard_LRS >/dev/null
+
+echo "Waiting 10 seconds to ensure activity is recorded..."
+sleep 10
+
+echo "Deleting storage account: ${STORAGE_NAME}"
+az storage account delete \
+  --name "${STORAGE_NAME}" \
+  --resource-group "${RESOURCE_GROUP}" \
+  --yes >/dev/null
+
+cat <<EOF
+Activity generation complete.
+Check Microsoft Sentinel Logs with KQL:
+AzureActivity | where OperationNameValue has "Microsoft.Storage/storageAccounts"
+EOF
