#!/bin/bash
# DCIM/BMS Deploy Script
# github.com/marcellbima/datacenter-bms

set -euo pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

log()  { echo -e "${CYAN}[DCIM]${NC} $1"; }
ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; exit 1; }

PROJECT_DIR="/opt/datacenter-bms"
MODE=${1:-help}

case "$MODE" in
  start)
    log "Starting DCIM/BMS stack..."
    cd $PROJECT_DIR/docker
    docker compose up -d
    docker compose ps
    ok "Stack started!"
    ;;
  stop)
    log "Stopping stack..."
    cd $PROJECT_DIR/docker
    docker compose down
    ok "Stack stopped."
    ;;
  restart)
    log "Restarting stack..."
    cd $PROJECT_DIR/docker
    docker compose restart
    docker compose ps
    ;;
  status)
    cd $PROJECT_DIR/docker
    docker compose ps
    ;;
  logs)
    cd $PROJECT_DIR/docker
    docker compose logs -f ${2:-node-red}
    ;;
  backup)
    BACKUP="$PROJECT_DIR/backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p $BACKUP
    log "Backing up InfluxDB..."
    docker exec dcim-influxdb influx backup /tmp/bkp 2>/dev/null
    docker cp dcim-influxdb:/tmp/bkp $BACKUP/influxdb
    log "Backing up Node-RED flows..."
    docker cp dcim-nodered:/data/flows.json $BACKUP/flows.json 2>/dev/null
    ok "Backup saved: $BACKUP"
    ;;
  export-flows)
    log "Exporting Node-RED flows..."
    docker cp dcim-nodered:/data/flows.json \
      $PROJECT_DIR/node-red-flows/dcim_flows.json
    cd $PROJECT_DIR
    git add node-red-flows/dcim_flows.json
    git commit -m "chore: export flows from Node-RED $(date +%Y-%m-%d)"
    git push
    ok "Flows exported and pushed!"
    ;;
  update)
    log "Pulling latest from GitHub..."
    cd $PROJECT_DIR
    git pull origin main
    cd docker
    docker compose restart node-red
    ok "Updated!"
    ;;
  *)
    echo "Usage: bash scripts/deploy.sh [start|stop|restart|status|logs|backup|export-flows|update]"
    ;;
esac
