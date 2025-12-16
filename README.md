# Microsoft Sentinel Log Ingestion & KQL Queries Lab

This repository contains a step-by-step lab guide for deploying a Microsoft Sentinel environment, ingesting Azure Activity logs and other data sources, and running Kusto Query Language (KQL) queries to detect suspicious activity.

The lab walks through:

- Creating a Log Analytics workspace and enabling Microsoft Sentinel.
- Connecting the Azure Activity data connector (and optionally SecurityEvent logs).
- Generating sample activity and verifying log ingestion.
- Using KQL to query logs (e.g., `AzureActivity | take 10`) and interpret results.
- (Optional) Creating analytic rules for brute force sign‭fan-ins and other anomalies.

See the Word document [`sentinel_log_ingestion_guide.docx`](sentinel_log_ingestion_guide.docx) for detailed instructions and click by click guidance.

## Project Structure

```
sentinel-log-ingestion-lab/
├ sentinel_log_ingestion_guide.docx – Detailed lab guide.
└ README.md – Overview of the project.
```

## Getting Started

1. Sign in to the Azure portal and create a Log Analytics workspace (workspace name, subscription, resource group and region).
2. Enable Microsoft Sentinel on the workspace from the Azure portal.
3. Ingest data by connecting the **Azure Activity** data connector or install sample content from the Content hub.
4. Explore log data using KQL queries such as:

   ```
   AzureActivity
   | take 10
   ```

5. Optionally, create analytic rules in Sentinel to alert on suspicious patterns.

For full instructions, refer to the guide in this repository.
