# How to Import Grafana Dashboards

By default, a fresh Grafana installation comes with no dashboards. To visualize your metrics, you need to import a layout.

I recommend (for the sake of time) using the standard **Node Exporter Full** dashboard, which provides the best overview for Linux servers.

## Setup

### 1. Access Grafana
* Open your browser and go to your monitor configured domain
* Login with the default credentials (what you defined in `.env`)

### 2. Add Data Source (If not auto-provisioned)
1. Go to **Connections** (or Configuration gear icon) > **Data Sources**
2. Click **Add data source**
3. Select **Prometheus**
4. In the URL field, enter: `http://prometheus:9090` (internal Docker address)
5. Scroll down and click **Save & Test**

### 3. Import the Dashboard
1. On the left menu, click **Dashboards** > **Import**
2. In the "Import via grafana.com" field, enter the ID: `11074` or `1860`
   * ID 1860 is the "Node Exporter Full" dashboard, widely used by the community. I preffer 11074.
3. Click **Load**
4. In the next screen:
   * **Name:** You can keep "Node Exporter Full" or rename it
   * **Prometheus Data Source:** Select the Prometheus source you added in Step 2
5. Click **Import**

You should now see CPU, RAM, Disk, and Network metrics populating instantly.

### Other Recommended Dashboards
* **Docker Container Monitoring:** ID `893` _(Requires cAdvisor)_
* **NGINX / Traefik:** _(Depends on your specific proxy setup)_
