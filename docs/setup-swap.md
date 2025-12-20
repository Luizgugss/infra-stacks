# How to Setup Swap Memory on your Linux Server

> **For note:** I'm using Ubuntu 24.

Many cloud providers (like **Hetzner**, DigitalOcean, or Linode) provision servers without Swap memory by default to maximize disk space usage.

However, running Docker containers without Swap is risky. If your RAM usage hits 100%, the Linux **OOM Killer** (Out of Memory Killer) will terminate processes to save the system, causing downtime for your database or application.

This guide creates a **4GB Swap file**, which acts as a safety net.

## Setup guide

### 1. Check Current Swap Status
Before starting, check if you already have swap enabled:

```bash
sudo swapon --show
# If the output is empty, you have no swap.
```

### 2. Create the Swap File
We will create a 4GB file _(adjust 4G if you need a different size)_.

```bash
# Allocate the file
sudo fallocate -l 4G /swapfile

# If fallocate fails, use dd:
# sudo dd if=/dev/zero of=/swapfile bs=1M count=4096
```

### 3. Secure the Swap File
For security reasons, swap should only be readable by the root user.

```bash
sudo chmod 600 /swapfile
```

### 4. Enable Swap
Format the file as swap space and enable it.

```bash
# Mark the file as swap space
sudo mkswap /swapfile

# Enable it
sudo swapon /swapfile
```

### 5. Make it Permanent
By default, the swap setting is lost after a reboot. To make it permanent, add it to the fstab file

```bash
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### 6. Optimization: Adjust Swappiness (Optional but Recommended)
The swappiness parameter controls how often the system uses swap.

- *Value 0:* The kernel will avoid swapping unless absolutely necessary (good for latency).
- *Value 60 (Default):* The kernel swaps out processes relatively often.
- *Value 100:* The kernel swaps aggressively.

For a web server/Docker host, a value of 10 is usually recommended. We want to use RAM as much as possible and only touch the SSD (Swap) when RAM is nearly full.

Check current value...

```bash
cat /proc/sys/vm/swappiness
```

...and change it to 10

```bash
sudo sysctl vm.swappiness=10
```

*Make it permanent:* Open the configuration file...

```bash
sudo nano /etc/sysctl.conf
```

...and add this line at the end:

```bash
vm.swappiness=10
```

## Verification

Run `htop` or `free -h` to confirm the Swap is active and available.

```bash
free -h
```

You should see:

```bash
total        used        free      shared  buff/cache   available
Mem:        7.7Gi       2.4Gi       235Mi       1.0Mi       5.1Gi       5.1Gi
Swap:       4.0Gi          0B       4.0Gi
```

```bash
```

```bash
```

```bash
```