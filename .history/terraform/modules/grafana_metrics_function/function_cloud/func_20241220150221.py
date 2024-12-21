import requests

# Configuration
SERVICES = {
    "mlflow": "http://localhost:5000/metrics",
    "qdrant": "http://localhost:6333/metrics"
}
GRAFANA_CLOUD_URL = "https://prometheus-blocks-prod-us-central1.grafana.net/api/v1/write"
GRAFANA_CLOUD_USERNAME = "your_grafana_cloud_username"
GRAFANA_CLOUD_API_KEY = "your_grafana_cloud_api_key"

def handler(ctx, data=None):
    headers = {"Authorization": f"Basic {GRAFANA_CLOUD_USERNAME}:{GRAFANA_CLOUD_API_KEY}"}

    for service_name, metrics_url in SERVICES.items():
        try:
            # Scrape metrics
            response = requests.get(metrics_url, timeout=5)
            response.raise_for_status()
            metrics = response.text

            # Send metrics to Grafana Cloud
            grafana_response = requests.post(
                GRAFANA_CLOUD_URL, headers=headers, data=metrics
            )
            grafana_response.raise_for_status()

            print(f"Metrics from {service_name} sent successfully!")
        except Exception as e:
            print(f"Error sending metrics for {service_name}: {e}")

    return "Metrics scraping and forwarding complete."