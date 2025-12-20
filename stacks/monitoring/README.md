# Server Monitoring Stack

> For **Prometheus** + **Grafana** + **Node Exporter**

A lightweight, production-ready observability stack based on **Docker**. Designed to monitor Linux VPS instances (Hetzner, DigitalOcean, AWS) with minimal setup.

![Dashboard Preview](/.github/assets/monitor-dashboard.webp)

## Overview

This repository provides a pre-configured `docker-compose` setup to spin up a complete monitoring solution in minutes. It includes:

* **Prometheus**: For metrics collection and storage.
* **Node Exporter**: For hardware and OS metrics (CPU, RAM, Disk I/O, Network).
* **Grafana**: For visualizing metrics with beautiful dashboards.

It is optimized for solo developers and small teams managing self-hosted infrastructure.

## Features

* **One-Command Setup**: Spin up the entire stack with `docker-compose up`.
* **Persistent Storage**: Metrics and dashboards are preserved across restarts.
* **Pre-configured Dashboards**: Includes standard setups for Node Exporter.
* **Resource Efficient**: Tuned to run smoothly on low-resource VPS (e.g., 2vCPU/4GB RAM).

## Configuration

You can customize the scraping intervals and targets in the `prometheus/prometheus.yml` file.

```yaml
global:
  scrape_interval: 15s
  scrape_timeout: 10s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['prometheus:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
```

Example above is my personal (and currently used) choice.