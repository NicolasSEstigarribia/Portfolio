#!/usr/bin/env bash
# -----------------------------------------------------------
# 03-ssl.sh
#
# Emite el certificado SSL de Let's Encrypt usando el método
# HTTP-01 (webroot) y actualiza la config de nginx para servir
# el sitio por HTTPS.
#
# Requisitos:
#   - DOMAIN en deploy/.env apuntando por DNS al VPS.
#   - El stack de deploy/compose.yml ya levantado (02-deploy.sh).
#   - Puerto 80 accesible desde internet.
# -----------------------------------------------------------

set -euo pipefail

# Ir al directorio deploy/
cd "$(dirname "$0")/.."

# Cargar variables de entorno (DOMAIN, EMAIL, etc.)
set -a
source .env
set +a

echo "[03] Asegurando que nginx y certbot estén arriba..."
# Asegurar que nginx (HTTP) y certbot estén corriendo
docker compose -f compose.yml up -d nginx certbot

echo "[03] Solicitando certificado Let's Encrypt..."
# Solicitar el certificado usando webroot en /var/www/certbot
docker run --rm \
  -v "$(pwd)/data/www:/var/www/certbot" \
  -v "$(pwd)/data/letsencrypt:/etc/letsencrypt" \
  certbot/certbot certonly \
  --webroot \
  --webroot-path /var/www/certbot \
  -d "${DOMAIN}" -d "www.${DOMAIN}" \
  --email "${EMAIL}" \
  --agree-tos \
  --non-interactive

echo "[03] Re-renderizando config de nginx con SSL..."
# Re-render nginx config ahora con SSL (HTTP + HTTPS)
sed \
  -e "s/\${DOMAIN}/${DOMAIN}/g" \
  nginx/conf.d/site-ssl.conf.template > nginx/conf.d/site.conf

echo "[03] Recargando nginx para tomar certificados..."
# Recargar nginx para aplicar certificados y nueva config
docker exec web_nginx nginx -s reload

echo "✅ SSL emitido para ${DOMAIN}. HTTPS debería funcionar."
