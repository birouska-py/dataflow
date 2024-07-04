#!/bin/bash

# Diretórios locais para os dados e configuração do Grafana
GRAFANA_DATA_DIR="/path/to/local/data/grafana"
GRAFANA_CONFIG_DIR="/path/to/local/config/grafana"

# UID e GID do Grafana (normalmente 472)
GRAFANA_UID=472
GRAFANA_GID=472

# Ajustando as permissões
echo "Ajustando permissões para os diretórios do Grafana..."
sudo chown -R $GRAFANA_UID:$GRAFANA_GID $GRAFANA_DATA_DIR
sudo chown -R $GRAFANA_UID:$GRAFANA_GID $GRAFANA_CONFIG_DIR
sudo chmod -R 775 $GRAFANA_DATA_DIR
sudo chmod -R 775 $GRAFANA_CONFIG_DIR

echo "Permissões ajustadas para os diretórios do Grafana."