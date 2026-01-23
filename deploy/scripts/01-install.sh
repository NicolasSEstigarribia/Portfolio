#!/usr/bin/env bash
# -----------------------------------------------------------
# 01-install-docker.sh
#
# Instala Docker, Docker Compose plugin y configura el firewall
# (ufw) para permitir SSH, HTTP (80) y HTTPS (443) en un VPS
# basado en Ubuntu/Debian.
#
# Se ejecuta una sola vez por servidor.
# -----------------------------------------------------------



set -euo pipefail

# Usuario objetivo para agregar al grupo docker (cuando aplica)
TARGET_USER="${SUDO_USER:-$USER}"

# -----------------------------------------------------------
# Sanity: deshabilitar repos apt rotos (ej: dart-archive viejo)
# Esto evita que falle el primer `apt-get update`.
# -----------------------------------------------------------

disable_broken_apt_sources() {
  local changed=0

  # Deshabilitar cualquier source que apunte al viejo dart-archive (404 / sin Release)
  for f in /etc/apt/sources.list.d/*.list; do
    [ -e "$f" ] || continue
    if grep -q "storage.googleapis.com/dart-archive" "$f" 2>/dev/null; then
      sudo mv "$f" "${f}.disabled" 2>/dev/null || true
      changed=1
    fi
  done

  # También cubrir el caso de que esté en /etc/apt/sources.list
  if grep -q "storage.googleapis.com/dart-archive" /etc/apt/sources.list 2>/dev/null; then
    # Comentamos las líneas problemáticas in-place
    sudo sed -i 's|^\s*deb\s\+\([^#].*storage\.googleapis\.com/dart-archive.*\)$|# disabled: \1|g' /etc/apt/sources.list || true
    changed=1
  fi

  if [ "$changed" -eq 1 ]; then
    echo "[01][INFO] Se deshabilitaron repositorios APT rotos (dart-archive viejo)."
  fi
}

disable_broken_apt_sources

 # Paquetes básicos + firewall ufw
# Si por alguna razón queda otro repo roto, reintentar una vez tras deshabilitar.
if ! sudo apt-get update -y; then
  echo "[01][WARN] Falló 'apt-get update'. Intentando deshabilitar repos rotos y reintentar..."
  disable_broken_apt_sources
  sudo apt-get update -y
fi
sudo apt-get install -y ca-certificates curl gnupg lsb-release ufw

# Repositorio oficial de Docker
sudo install -m 0755 -d /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
else
  sudo chmod a+r /etc/apt/keyrings/docker.gpg || true
fi


DOCKER_LIST_LINE="deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable"
if [ ! -f /etc/apt/sources.list.d/docker.list ] || ! grep -qxF "$DOCKER_LIST_LINE" /etc/apt/sources.list.d/docker.list 2>/dev/null; then
  echo "$DOCKER_LIST_LINE" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
fi


# Instalar Docker sólo si falta algún paquete
sudo apt-get update -y

missing_pkgs=()
for p in docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; do
  if ! dpkg -s "$p" >/dev/null 2>&1; then
    missing_pkgs+=("$p")
  fi
done

if [ ${#missing_pkgs[@]} -gt 0 ]; then
  sudo apt-get install -y "${missing_pkgs[@]}"
else
  echo "[01] Docker ya instalado (paquetes OK), se omite instalación."
fi

# Asegurar servicio docker activo (si systemd está disponible)
if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl enable --now docker >/dev/null 2>&1 || true
fi


# Permitir que el usuario objetivo ejecute docker sin sudo
# Nota: si corrés como root directo, TARGET_USER=root (no aporta). Ideal: ejecutar con sudo desde un usuario normal.
if [ -n "$TARGET_USER" ] && id "$TARGET_USER" >/dev/null 2>&1; then
  if ! id -nG "$TARGET_USER" | grep -qw docker; then
    sudo usermod -aG docker "$TARGET_USER" || true
    echo "[01] Usuario '$TARGET_USER' agregado al grupo docker (reconectar sesión para aplicar)."
  else
    echo "[01] Usuario '$TARGET_USER' ya está en el grupo docker."
  fi
fi


# Firewall (idempotente)
sudo ufw allow OpenSSH >/dev/null 2>&1 || true
sudo ufw allow 80/tcp >/dev/null 2>&1 || true
sudo ufw allow 443/tcp >/dev/null 2>&1 || true
sudo ufw --force enable >/dev/null 2>&1 || true

# -----------------------------------------------------------
# Dart SDK + Jaspr CLI
# -----------------------------------------------------------

# Instalar Dart SDK (opcional). Si falla, NO corta el script.
install_dart_optional() {
  if command -v dart >/dev/null 2>&1; then
    echo "[01] Dart SDK ya instalado, se omite."
    return 0
  fi

  echo "[01] Instalando Dart SDK (opcional)..."

  sudo mkdir -p /usr/share/keyrings

  # Keyring (idempotente, sin prompts)
  if [ ! -f /usr/share/keyrings/dart.gpg ]; then
    curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub \
      | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
  fi
  sudo chmod a+r /usr/share/keyrings/dart.gpg || true

  # Repo correcto (según docs oficiales). Reescribir es seguro e idempotente.
  echo "deb [signed-by=/usr/share/keyrings/dart.gpg arch=$(dpkg --print-architecture)] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" \
    | sudo tee /etc/apt/sources.list.d/dart_stable.list >/dev/null

  # Importante: si el repo falla, deshabilitarlo y seguir.
  if ! sudo apt-get update -y; then
    echo "[01][WARN] Falló 'apt-get update' al agregar Dart. Deshabilitando repo de Dart y continuando..."
    sudo mv /etc/apt/sources.list.d/dart_stable.list /etc/apt/sources.list.d/dart_stable.list.disabled 2>/dev/null || true
    return 0
  fi

  if ! sudo apt-get install -y dart; then
    echo "[01][WARN] No se pudo instalar Dart por apt. Continuando sin Dart/Jaspr."
    return 0
  fi

  echo "[01] Dart instalado correctamente."
}

install_dart_optional

# Instalar Jaspr CLI (opcional). Requiere Dart.
if command -v dart >/dev/null 2>&1; then
  if ! command -v jaspr >/dev/null 2>&1; then
    echo "[01] Instalando Jaspr CLI (dart pub global activate jaspr_cli)..."
    if dart pub global activate jaspr_cli; then
      # Asegurar que ~/.pub-cache/bin esté en el PATH del usuario actual
      SHELL_RC="$HOME/.bashrc"
      if [ -n "${ZSH_VERSION-}" ]; then
        SHELL_RC="$HOME/.zshrc"
      fi

      if ! grep -q 'PUB_CACHE/bin' "$SHELL_RC" 2>/dev/null; then
        echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> "$SHELL_RC"
      fi

      echo "[01] Jaspr CLI instalado. Si no lo ves aún en el PATH, reconectá la sesión SSH."
    else
      echo "[01][WARN] Falló la instalación de Jaspr CLI. Continuando..."
    fi
  else
    echo "[01] Jaspr CLI ya instalado, se omite."
  fi
else
  echo "[01] Dart no está instalado; se omite Jaspr CLI."
fi


# -----------------------------------------------------------
# Verificación (no falla el script; sólo informa estado)
# -----------------------------------------------------------
verify_install() {
  echo ""
  echo "[01][CHECK] Verificando instalaciones..."

  if command -v docker >/dev/null 2>&1; then
    echo "[01][OK] Docker: $(docker --version 2>/dev/null || echo installed)"
  else
    echo "[01][FAIL] Docker no encontrado en PATH"
  fi

  if docker compose version >/dev/null 2>&1; then
    echo "[01][OK] Docker Compose plugin: $(docker compose version 2>/dev/null | head -n 1)"
  else
    echo "[01][WARN] Docker Compose plugin no disponible (docker compose)"
  fi

  if command -v ufw >/dev/null 2>&1; then
    echo "[01][OK] UFW: $(sudo ufw status 2>/dev/null | head -n 1)"
  else
    echo "[01][WARN] UFW no instalado"
  fi

  if command -v dart >/dev/null 2>&1; then
    echo "[01][OK] Dart: $(dart --version 2>&1 | head -n 1)"
  else
    echo "[01][INFO] Dart no instalado (opcional)"
  fi

  if command -v jaspr >/dev/null 2>&1; then
    echo "[01][OK] Jaspr: $(jaspr --version 2>/dev/null | head -n 1)"
  else
    echo "[01][INFO] Jaspr no instalado (opcional)"
  fi
}

verify_install

echo "✅ Docker instalado. Dart/Jaspr son opcionales (si fallan, el script continúa). Reconectá la sesión SSH para que el grupo docker y el PATH se apliquen."
