# 🏢 DCIM / BMS — Data Center Infrastructure Management System

> Enterprise-grade Building Management System built on Node-RED, InfluxDB, and Grafana
> Deployed on Proxmox VM (Ubuntu 24.04) via Docker Compose
> Secured with Cloudflare Zero Trust Tunnel
> Live: **[bms.mtechlabs.cloud](https://bms.mtechlabs.cloud)**

## 📐 Architecture

\```
Internet
   │ HTTPS (no open ports)
Cloudflare Zero Trust (bms.mtechlabs.cloud)
   │ Encrypted Tunnel
Proxmox VM — datacenter-bms (192.168.1.50)
   │ Docker Compose
   ├── Node-RED  :1880  (Automation + Dashboard + API)
   ├── InfluxDB  :8086  (Time-series database)
   ├── Grafana   :3000  (Analytics + Visualization)
   └── Cloudflared      (Zero Trust tunnel agent)
\```

## 🔐 Security
- RBAC: Admin (full control) / User (read-only)
- Session token 256-bit, 15 min auto-logout
- bcrypt password hashing
- Audit log for all admin actions
- Cloudflare Zero Trust (no open firewall ports)

## 📊 Monitoring
- **Power**: UPS status, IT load, PDU-A/B, PUE calculation
- **Cooling**: CRAC x2, inlet/return temp, humidity (ASHRAE A2)
- **Safety**: Water leak, fire alarm, smoke, rack doors

## 🚀 Stack
| Component | Technology | Version |
|-----------|-----------|---------|
| Automation | Node-RED | 3.1.9 |
| Time-Series DB | InfluxDB | 2.7 |
| Visualization | Grafana | 10.4.0 |
| Tunnel | Cloudflare cloudflared | Latest |
| Container | Docker Compose | V2 |
| Virtualization | Proxmox VE | 8.x |

## 🛠️ Deploy

\```bash
git clone git@github.com:marcellbima/datacenter-bms.git
cd datacenter-bms/docker
cp .env.example .env && nano .env
docker compose up -d
\```

## 👤 Author
**Marcell Bima** — Infrastructure & Cloud Engineer
Domain: [mtechlabs.cloud](https://mtechlabs.cloud)
GitHub: [marcellbima](https://github.com/marcellbima)
