diff --git a/scripts/README.md b/scripts/README.md
new file mode 100644
index 0000000000000000000000000000000000000000..ed342abaf8e66df16ddfa64829c148f3952b1fcb
--- /dev/null
+++ b/scripts/README.md
@@ -0,0 +1,30 @@
+# Scripts
+
+These helper scripts automate common lab tasks.
+
+The provisioning script will install the `sentinel` Azure CLI extension if it is missing.
+
+## Provision the workspace
+
+```bash
+./scripts/provision-workspace.sh
+```
+
+Optional environment variables:
+
+- `LOCATION` (default: `eastus`)
+- `RESOURCE_GROUP` (default: `rg-sentinel-lab`)
+- `WORKSPACE_NAME` (default: `law-sentinel-lab-$RANDOM`)
+- `SUBSCRIPTION_ID` (optional)
+
+## Generate activity logs
+
+```bash
+./scripts/generate-activity.sh
+```
+
+## Cleanup
+
+```bash
+./scripts/cleanup.sh
+```
