#!/usr/bin/env bash
# -----------------------------------------------------------
# 04-renew-cron.sh
#
# Crea (o actualiza) una entrada en crontab para renovar
# automáticamente el certificado de Let's Encrypt dos veces al día.
#
# Si la renovación cambia algo, se recarga nginx para tomar
# los nuevos certificados.
# -----------------------------------------------------------

set -euo pipefail

# Ir al directorio deploy/
cd "$(dirname "$0")/.."

# Línea de cron:
#   - Cada 12 horas ejecuta certbot renew usando el mismo webroot.
#   - Si se renueva, se recarga nginx dentro del contenedor web_nginx.
CRON_LINE='0 */12 * * * cd '"$(pwd)"' && docker run --rm -v '"$(pwd)"'/data/www:/var/www/certbot -v '"$(pwd)"'/data/letsencrypt:/etc/letsencrypt certbot/certbot renew --webroot -w /var/www/certbot --quiet && docker exec web_nginx nginx -s reload'

# Reemplazar cualquier línea anterior de renovación certbot y agregar la nueva
( crontab -l 2>/dev/null | grep -v "certbot/certbot renew" || true
  echo "$CRON_LINE"
) | crontab -

echo "✅ Cron de auto-renovación instalado."
