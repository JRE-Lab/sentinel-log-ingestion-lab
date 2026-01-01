diff --git a/scripts/provision-workspace.sh b/scripts/provision-workspace.sh
new file mode 100755
index 0000000000000000000000000000000000000000..2132d5d2966abb656ba8281966a6115184157ba5
--- /dev/null
+++ b/scripts/provision-workspace.sh
@@ -0,0 +1,53 @@
+#!/usr/bin/env bash
+set -euo pipefail
+
+LOCATION="${LOCATION:-eastus}"
+RESOURCE_GROUP="${RESOURCE_GROUP:-rg-sentinel-lab}"
+WORKSPACE_NAME="${WORKSPACE_NAME:-law-sentinel-lab-$RANDOM}"
+SUBSCRIPTION_ID="${SUBSCRIPTION_ID:-}"
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
+if [[ -n "${SUBSCRIPTION_ID}" ]]; then
+  az account set --subscription "${SUBSCRIPTION_ID}"
+fi
+
+if ! az extension show --name sentinel >/dev/null 2>&1; then
+  echo "Installing Azure CLI Sentinel extension..."
+  az extension add --name sentinel >/dev/null
+fi
+
+echo "Creating resource group: ${RESOURCE_GROUP} (${LOCATION})"
+az group create --name "${RESOURCE_GROUP}" --location "${LOCATION}" >/dev/null
+
+echo "Creating Log Analytics workspace: ${WORKSPACE_NAME}"
+az monitor log-analytics workspace create \
+  --resource-group "${RESOURCE_GROUP}" \
+  --workspace-name "${WORKSPACE_NAME}" \
+  --location "${LOCATION}" >/dev/null
+
+echo "Attempting to enable Microsoft Sentinel..."
+if az sentinel create --resource-group "${RESOURCE_GROUP}" --workspace-name "${WORKSPACE_NAME}" >/dev/null 2>&1; then
+  echo "Microsoft Sentinel enabled."
+else
+  cat <<EOF
+Unable to enable Microsoft Sentinel via CLI.
+Please enable it manually:
+Azure Portal -> Microsoft Sentinel -> Create -> Select workspace -> Add.
+EOF
+fi
+
+cat <<EOF
+Provisioning complete.
+Resource Group: ${RESOURCE_GROUP}
+Workspace:      ${WORKSPACE_NAME}
+Location:       ${LOCATION}
+EOF
