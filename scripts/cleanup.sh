diff --git a/scripts/cleanup.sh b/scripts/cleanup.sh
new file mode 100755
index 0000000000000000000000000000000000000000..b462c1e38e420698585c7afcffe7b89faa129748
--- /dev/null
+++ b/scripts/cleanup.sh
@@ -0,0 +1,19 @@
+#!/usr/bin/env bash
+set -euo pipefail
+
+RESOURCE_GROUP="${RESOURCE_GROUP:-rg-sentinel-lab}"
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
+echo "Deleting resource group: ${RESOURCE_GROUP}"
+az group delete --name "${RESOURCE_GROUP}" --yes --no-wait
+
+echo "Cleanup initiated. Resources will be deleted asynchronously."
