diff --git a/queries/README.md b/queries/README.md
new file mode 100644
index 0000000000000000000000000000000000000000..ef6d33f4a2898bd7b781d5cbf2f6dc2aaad35d69
--- /dev/null
+++ b/queries/README.md
@@ -0,0 +1,36 @@
+# KQL Queries for the Sentinel Lab
+
+Use these queries in Microsoft Sentinel → Logs.
+
+## Verify ingestion
+
+```kusto
+AzureActivity
+| take 10
+```
+
+## Activity by status
+
+```kusto
+AzureActivity
+| summarize count() by ActivityStatusValue
+```
+
+## Storage account activity (creation/deletion)
+
+```kusto
+AzureActivity
+| where OperationNameValue has "Microsoft.Storage/storageAccounts"
+| project TimeGenerated, Caller, OperationNameValue, ActivityStatusValue, ResourceGroup
+| sort by TimeGenerated desc
+```
+
+## Who deleted resources
+
+```kusto
+AzureActivity
+| where OperationNameValue endswith "/delete"
+| project TimeGenerated, Caller, OperationNameValue, ResourceGroup, ActivityStatusValue
+| sort by TimeGenerated desc
+```
+
