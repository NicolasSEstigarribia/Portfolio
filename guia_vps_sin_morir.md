---
title: "Armá tu VPS sin morir en el intento"
author: "Guía práctica"
---

# Armá tu VPS sin morir en el intento

Esta guía te acompaña paso a paso para levantar, asegurar y mantener un VPS Linux para tus proyectos sin volverte loco. La idea es que sigas el orden propuesto, copies y pegues los comandos con cuidado y entiendas, al menos a grandes rasgos, qué estás haciendo.

> Nota: Todos los ejemplos asumen una distribución basada en Debian/Ubuntu con `apt`, pero las ideas se pueden adaptar a otras distros.

---

## 1. Elegir el proveedor y el plan

Antes de tocar una terminal, definí:

- **Proveedor**: DigitalOcean, Linode, Hetzner, Vultr, AWS Lightsail, etc.
- **Ubicación**: elegí la región más cercana a tus usuarios.
- **Recursos**:
  - Para proyectos pequeños: 1 vCPU, 1–2 GB RAM, 20–40 GB SSD.
  - Para entornos de prueba: 1 vCPU, 1 GB RAM suele alcanzar.
  - Para producción con tráfico real: arrancá en 2 GB RAM y monitorizá.

Buenas prácticas:

- Preferí **facturación por horas** (podés destruir el VPS si algo sale mal).
- Activá **backups automáticos** si el proveedor lo ofrece (aunque sea semanal).
- Usá una **imagen LTS** (Ubuntu 22.04 LTS, Debian 12, etc.).


---

## 2. Primer acceso al VPS

Supongamos que tu VPS tiene IP `TU_VPS_IP` y usuario por defecto `root`:

```bash
ssh root@TU_VPS_IP
```

## Posible error

@  WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
ssh-keygen -R TU_VPS_IP

Recomendaciones inmediatas:

- Cambiá la contraseña de `root` si el proveedor te la dio por email.
- Actualizá el sistema:

  ```bash
  apt update && apt upgrade -y
  ```

- Configurá el **timezone** (zona horaria):

  ```bash
  timedatectl list-timezones | grep -i buenos
  sudo timedatectl set-timezone America/Argentina/Buenos_Aires
  ```

---


## 3. Preparar tus claves SSH

Nunca uses contraseña para conectarte por SSH en un VPS de producción. Lo ideal es usar **claves SSH**:

1. En tu máquina local, generá un par de claves si no lo tenés:

   ```bash
   ssh-keygen -t ed25519 -C "tu-correo@ejemplo.com"
   ```

   - Aceptá la ruta por defecto (`~/.ssh/id_ed25519`).
   - Poné una **passphrase** segura (no la dejes vacía).

2. Mostrá tu clave pública:

   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

3. Copiá y pegá esa clave en el panel del proveedor cuando crees el VPS o, si ya lo creaste, agregala luego al archivo `nano /root/.ssh/authorized_keys` del servidor.

## 4. Crear un usuario no-root y configurar sudo

Trabajar como `root` todo el tiempo es peligroso. Creá un usuario normal con permisos de `sudo`:

```bash
adduser deploy
usermod -aG sudo deploy
```

Copiá tus claves SSH al nuevo usuario:

```bash
rsync -avz ~/.ssh/ /home/deploy/.ssh/
chown -R deploy:deploy /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
chmod 600 /home/deploy/.ssh/authorized_keys
```

Probá conectarte:

```bash
ssh deploy@TU_VPS_IP
```

Si todo funciona, podés desconectarte y olvidarte (casi) de `root`.

Generar la key:

mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t ed25519 -C "deploy@vps-portfolio"

## Copiar la key publica

cat ~/.ssh/id_ed25519.pub

## Editar para utilizar la key publica
nano ~/.ssh/config

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes

## Permisos correctos

chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

## 6. Preparar el proyecto en el VPS

A partir de acá asumimos que vas a usar el **flujo automatizado de este repo** (carpeta `deploy/` + Docker). Eso significa que **no necesitás instalar Docker, nginx ni configurar el firewall a mano**: de todo eso se encarga el script `01-install-docker.sh`.

Pasos mínimos:

1. Instalar `git` (si todavía no lo tenés):

   ```bash
   sudo apt update
   sudo apt install -y git
   ```

2. Clonar el repo en el VPS (ejemplo usando `~/Portfolio`, que es la ruta que usa tu workflow de GitHub Actions):

   ```bash
   cd ~
   git clone git@github.com:NicolasSEstigarribia/Portfolio.git
   cd ~/Portfolio
   ```

3. Vas a ver algo parecido a:

   - `public/`: la versión estática de tu sitio.
   - `deploy/`: todo lo relacionado al despliegue (Docker, nginx, certbot, scripts).
   - `.github/workflows/`: workflow de GitHub Actions para deploy automático.

4. Dentro de `deploy/`, asegurate de tener un archivo `.env` con al menos:

   ```bash
   DOMAIN=tu-dominio.com
   EMAIL=tu-correo@ejemplo.com
   ```

   Ese archivo lo usan `02-deploy.sh` y `03-ssl.sh` para generar la config de nginx y pedir el certificado SSL.

---

## 7. Despliegue automatizado con Docker y scripts (tu flujo actual)

En este repo ya tenés un **sistema de despliegue automatizado** basado en Docker y unos scripts en `deploy/` que te simplifican muchísimo la vida.

La idea general:

- Todo el despliegue vive en la carpeta `deploy/`.
- `deploy/compose.yml` define tres contenedores:
  - `nginx`: proxy reverso frontal que expone HTTP/HTTPS y reenvía al contenedor `app`.
  - `app`: nginx sirviendo tu sitio estático desde `deploy/site/`.
  - `certbot`: contenedor “idle” que mantiene montados los volúmenes para certificados.
- `deploy/nginx/conf.d/site.conf.template` y `site-ssl.conf.template` son templates de nginx.
- Los scripts en `deploy/scripts/` orquestan todo:
  - `01-install-docker.sh`: prepara el VPS (Docker + ufw).
  - `02-deploy.sh`: hace el deploy HTTP del sitio.
  - `03-ssl.sh`: emite el certificado SSL de Let’s Encrypt.
  - `04-renew-cron.sh`: configura la auto-renovación del certificado.

En resumen: en vez de instalar y configurar todo a mano en el host, delegás la mayor parte del trabajo a Docker y a estos scripts.

### 7.1. Preparar el VPS una sola vez (`01-install-docker.sh`)

Supongamos que clonaste el repo en `~/Portfolio` dentro del VPS:

```bash
cd ~/Portfolio/deploy
./scripts/01-install-docker.sh
```

Este script hace, entre otras cosas:

- Instala paquetes básicos y `ufw` (firewall).
- Agrega el repositorio oficial de Docker para tu distro.
- Instala `docker-ce`, el plugin de Docker Compose y dependencias.
- Agrega tu usuario al grupo `docker` para poder ejecutar `docker` sin `sudo`.
- Configura el firewall para permitir:
  - SSH (`OpenSSH`).
  - HTTP (puerto 80).
  - HTTPS (puerto 443).
- Activa `ufw` de forma no interactiva.

Traducción: **no tenés que instalar Docker ni configurar el firewall a mano**, con correr este script una vez por servidor alcanza. Después de ejecutarlo, conviene cerrar sesión SSH y volver a entrar para que el grupo `docker` se aplique a tu usuario.

### 7.2. Deploy HTTP y stack Docker (`02-deploy.sh`)

El corazón del despliegue día a día es `deploy/scripts/02-deploy.sh`:

```bash
cd ~/Portfolio/deploy
./scripts/02-deploy.sh
```

Este script:

1. Se asegura de estar en `deploy/` y carga las variables desde `.env` (por ejemplo `DOMAIN`, `EMAIL`).
2. Crea las carpetas internas que necesita el stack:
   - `deploy/data/www` y `deploy/data/letsencrypt` para certbot.
   - `deploy/site` donde se copiará el sitio estático.
   - `deploy/nginx/conf.d` para la config generada.
3. Elige el template de nginx adecuado:
   - Si **todavía no hay certificado** para tu dominio, usa `nginx/conf.d/site.conf.template` (solo HTTP).
   - Si ya existe un certificado emitido en `deploy/data/letsencrypt/live/${DOMAIN}/fullchain.pem`, usa `site-ssl.conf.template` (HTTP + HTTPS).
4. Renderiza el template elegido reemplazando `${DOMAIN}` y lo guarda como `nginx/conf.d/site.conf`.
5. Borra el contenido previo de `deploy/site/` y copia ahí el contenido real de tu sitio:

   - En este repo el código público vive en `public/`.
   - Cada vez que corrés `02-deploy.sh`, hace esencialmente: `cp -r ../public/* site/`.

6. Levanta o recrea el stack Docker:

   ```bash
   docker compose -f compose.yml up -d --remove-orphans
   ```

Resultado: tu sitio queda sirviéndose por HTTP en el puerto 80 del VPS, proxyado por el contenedor `nginx` hacia el contenedor `app`.

### 7.3. Emitir el certificado SSL (`03-ssl.sh`)

Una vez que el dominio ya apunta al VPS y el stack HTTP está corriendo, pasás a HTTPS con:

```bash
cd ~/Portfolio/deploy
./scripts/03-ssl.sh
```

Este script:

1. Carga `DOMAIN` y `EMAIL` desde `deploy/.env`.
2. Asegura que los contenedores `nginx` y `certbot` estén arriba (`docker compose up -d nginx certbot`).
3. Ejecuta un contenedor `certbot/certbot` para **solicitar el certificado** usando el método HTTP-01:

   - Usa `/var/www/certbot` como webroot para los desafíos de Let’s Encrypt.
   - Monta los volúmenes `deploy/data/www` y `deploy/data/letsencrypt` dentro del contenedor.
   - Pide certificados para `DOMAIN` y `www.DOMAIN`.
4. Una vez emitido el certificado, vuelve a renderizar la config de nginx pero ahora con el template SSL:

   ```bash
   sed -e "s/${DOMAIN}/${DOMAIN}/g" nginx/conf.d/site-ssl.conf.template > nginx/conf.d/site.conf
   ```

5. Recarga el contenedor `web_nginx` para que tome los certificados y la nueva config:

   ```bash
   docker exec web_nginx nginx -s reload
   ```

Resultado: tu sitio queda sirviéndose por HTTPS en el puerto 443, con certificados válidos de Let’s Encrypt.

### 7.4. Renovación automática del certificado (`04-renew-cron.sh`)

Para no estar pendiente de renovar certificados manualmente, tenés:

```bash
cd ~/Portfolio/deploy
./scripts/04-renew-cron.sh
```

Este script:

- Construye una línea de `cron` que:
  - Dos veces al día ejecuta `certbot renew` dentro de un contenedor `certbot/certbot`.
  - Si el certificado se renueva, recarga automáticamente `web_nginx` para que tome los nuevos archivos.
- Limpia entradas viejas de renovación de certbot y agrega la actualizada.

Con esto, el VPS se encarga solo de mantener tu HTTPS al día.

### 7.5. Integración con GitHub Actions (deploy automático al hacer push)

Además de los scripts, tenés un workflow en `.github/workflows/deploy.yml` que despliega al VPS cada vez que pusheás a `main`.

En resumen:

- Usa la acción `appleboy/ssh-action` para conectarse al VPS por SSH.
- Asume que el repo está clonado en `~/Portfolio`.
- Corre estos pasos en el VPS:

  ```bash
  cd ~/Portfolio
  git fetch origin main
  git reset --hard origin/main
  cd deploy
  ./scripts/02-deploy.sh
  ```

Para que funcione:

- Configurás en los **GitHub Secrets**:
  - `SSH_HOST`: IP o dominio del VPS.
  - `SSH_USER`: usuario con permisos para hacer `git pull` y ejecutar Docker.
  - `SSH_KEY`: clave privada, autorizada en `cat ~/.ssh/id_ed25519` del VPS.
  - (opcional) `SSH_PORT`: si no usás el puerto 22.
- En el VPS ya tuviste que correr una vez:
  - `./scripts/01-install-docker.sh`
  - `./scripts/02-deploy.sh`
  - `./scripts/03-ssl.sh`
  - (opcional) `./scripts/04-renew-cron.sh`
- Tener `deploy/.env` con `DOMAIN` y `EMAIL` configurados.

Después de eso, tu flujo queda así:

1. Hacés cambios en tu sitio estático (carpeta `public/`).
2. `git commit` + `git push` a `main`.
3. GitHub Actions se conecta al VPS y corre `02-deploy.sh`.
4. El stack Docker levanta la nueva versión del sitio automáticamente.

---

## 8. Seguridad adicional básica

Algunas medidas rápidas:

- **Fail2ban** para bloquear IPs con muchos intentos fallidos de login:

  ```bash
  sudo apt install -y fail2ban
  ```

  La configuración por defecto ya da una capa básica de protección.

- **Actualizaciones automáticas de seguridad**:

  ```bash
  sudo apt install -y unattended-upgrades
  sudo dpkg-reconfigure --priority=low unattended-upgrades
  ```

  Esto configurará actualizaciones de seguridad automáticas.

---

## 9. Backups y snapshots

No sirve de nada tener un VPS impecable si no hacés backups.

- **Snapshots del VPS**:
  - La mayoría de los proveedores permiten hacer snapshots completos del servidor.
  - Úsalos antes de cambios grandes (actualizaciones mayores, reconfiguraciones importantes).

- **Backups de datos**:
  - Para bases de datos: `pg_dump`, `mysqldump`, etc.
  - Para archivos: `rsync` hacia otro servidor o almacenamiento (S3, Backblaze, etc.).

Ejemplo simple de backup de carpeta:

```bash
rsync -avz ~/Portfolio/ usuario@otro-servidor:/backups/portfolio/
```

Automatizá esto con `cron` o `systemd timers`.

---

## 10. Monitorización básica y checklist final

Aunque sea algo simple, monitoreá el estado del VPS:

- `htop` o `top` para ver CPU y RAM:

  ```bash
  sudo apt install -y htop
  htop
  ```

- `df -h` para ver espacio en disco.
- `docker ps` para ver si los contenedores (`web_nginx`, `web_app`, `web_certbot`) están arriba.
- `docker logs -f web_nginx` y `docker logs -f web_app` para seguir logs de nginx y de la app.
- Herramientas externas:
  - UptimeRobot, BetterStack, StatusCake, etc. para ping/HTTP checks.

---

### Checklist rápido “sin morir en el intento”

Usá esta lista como repaso antes de considerar tu VPS “listo”:

- [ ] Usuario no-root creado y usándolo para todo.
- [ ] Claves SSH funcionando, login por contraseña desactivado.
- [ ] `PermitRootLogin no` en SSH.
- [ ] Sistema actualizado (`apt update && apt upgrade -y`).
- [ ] Repo clonado en `~/Portfolio` (o la ruta que elijas) y `deploy/.env` con `DOMAIN` y `EMAIL`.
- [ ] `./scripts/01-install-docker.sh` corrido una vez (Docker + ufw listos).
- [ ] `./scripts/02-deploy.sh` corriendo sin errores (sitio sirviéndose por HTTP).
- [ ] `./scripts/03-ssl.sh` ejecutado y HTTPS funcionando con Let’s Encrypt.
- [ ] (Opcional pero recomendado) `./scripts/04-renew-cron.sh` configurado para renovar certificados automáticamente.
- [ ] Workflow de GitHub Actions configurado con `SSH_HOST`, `SSH_USER`, `SSH_KEY` (y `SSH_PORT` si aplica) y pasando al menos un deploy.
- [ ] Backups (snapshots + datos) configurados o al menos planificados.
- [ ] Monitorización básica (htop, df, docker ps, ping externo) en marcha.

Si todo eso está OK, oficialmente **armaste tu VPS sin morir en el intento**.

Pero como base sólida para tus proyectos, esta guía ya te deja en un muy buen punto de partida.
