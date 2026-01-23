#!/usr/bin/env bash
# -----------------------------------------------------------
# 02-deploy.sh
#
# Despliegue de la versión HTTP de tu sitio.
#
# Hace:
#   - Carga variables de deploy/.env (DOMAIN, EMAIL, etc.).
#   - Renderiza la config de nginx sin SSL desde un template.
#   - Construye el sitio estático con Jaspr (public/) y copia el build a deploy/site/.
#   - Levanta los servicios definidos en deploy/compose.yml (nginx + app + certbot).
#
# Se puede re-ejecutar cuando cambies el código del sitio.
# -----------------------------------------------------------

set -euo pipefail

# Ir al directorio deploy/
cd "$(dirname "$0")/.."

# Validar que exista el archivo de entorno
if [ ! -f ".env" ]; then
  echo "Missing .env. Create it from .env.example"
  exit 1
fi

# Cargar variables de entorno (DOMAIN, EMAIL, etc.)
set -a
source .env
set +a

# Carpetas usadas por nginx y certbot dentro de deploy/
mkdir -p data/www data/letsencrypt site nginx/conf.d

# Elegir template de nginx según si ya existe un certificado emitido.
# - Sin certificado: usar config solo HTTP (site.conf.template).
# - Con certificado: usar config HTTP + HTTPS (site-ssl.conf.template).
NGINX_TEMPLATE="nginx/conf.d/site.conf.template"
if [ -f "data/letsencrypt/live/${DOMAIN}/fullchain.pem" ]; then
  NGINX_TEMPLATE="nginx/conf.d/site-ssl.conf.template"
fi

# Render nginx config desde el template elegido
sed \
  -e "s/\${DOMAIN}/${DOMAIN}/g" \
  "$NGINX_TEMPLATE" > nginx/conf.d/site.conf

# Copiar el sitio real al directorio que sirve el contenedor `app`
# Si en ../public hay un proyecto Jaspr, se construye en modo estático
# y se copia el resultado desde build/jaspr/. En caso contrario se
# mantiene el comportamiento anterior (copiar public/ tal cual).
if [ -f "../public/pubspec.yaml" ]; then
  echo "[02] Detectado proyecto Jaspr en ../public (pubspec.yaml encontrado)."

  if ! command -v dart >/dev/null 2>&1; then
    echo "[02] Error: Dart SDK no está instalado en el VPS."
    echo "     Instalalo siguiendo la guía oficial: https://dart.dev/get-dart"
    exit 1
  fi

  if ! command -v jaspr >/dev/null 2>&1; then
    echo "[02] jaspr CLI no está disponible. Intentando instalación automática..."
    if dart pub global activate jaspr_cli; then
      export PATH="$PATH:$HOME/.pub-cache/bin"
      if ! command -v jaspr >/dev/null 2>&1; then
        echo "[02] Error: jaspr CLI se instaló pero no se encontró en el PATH."
        echo "     Asegurate de tener ~/.pub-cache/bin en el PATH."
        exit 1
      fi
      echo "[02] jaspr CLI instalado correctamente."
    else
      echo "[02] Error: no se pudo instalar jaspr CLI automáticamente."
      echo "     Instalalo manualmente con: dart pub global activate jaspr_cli"
      echo "     y asegurate de tener ~/.pub-cache/bin en el PATH."
      exit 1
    fi
  fi

  echo "[02] Ejecutando build estático de Jaspr..."
  pushd ../public > /dev/null
  dart pub get
  jaspr build
  popd > /dev/null

  if [ ! -d "../public/build/jaspr" ]; then
    echo "[02] Error: no se encontró ../public/build/jaspr después de 'jaspr build'."
    exit 1
  fi

  rm -rf site/*
  cp -r ../public/build/jaspr/* site/
else
  echo "[02] No se detectó proyecto Jaspr en ../public, usando flujo estático clásico."
  rm -rf site/*
  cp -r ../public/* site/
fi

# Levantar o recrear el stack definido en deploy/compose.yml
docker compose -f compose.yml up -d --remove-orphans

echo "✅ Deploy HTTP listo. Ahora corré scripts/03-ssl.sh para emitir el certificado SSL."
