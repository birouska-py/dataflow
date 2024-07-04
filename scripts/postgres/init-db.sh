#!/bin/bash
set -e

# Restaura o backup
echo "Restaurando o backup..."
pg_restore -U postgres -d dvdrental /backup/dvdrental.tar

echo "Backup restaurado com sucesso!"