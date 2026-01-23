# Portfolio

Portfolio estático servido con Nginx en Docker y desplegado a un VPS (Vexyhost) con SSL de Let's Encrypt.

Este README es una guía paso a paso para:

- Levantar el sitio en local.
- Hacer el primer deploy manual al VPS (HTTP + HTTPS).
- Configurar el deploy automático con GitHub Actions (opcional).

---

## Estructura del proyecto

- `public/`: proyecto del portfolio construido con [Jaspr](https://pub.dev/packages/jaspr) (código fuente en Dart).
- `docker-compose.yml`: ejemplo simple para servir `./public` en local (solo HTTP, si apuntás al build estático).
- `deploy/`: todo lo relacionado al despliegue en VPS con Nginx + Certbot.
  - `deploy/compose.yml`: stack de producción (nginx + app + certbot).
  - `deploy/.env`: variables de entorno del despliegue (dominio, email, etc.).
  - `deploy/nginx/conf.d/site.conf.template`: config Nginx solo HTTP (primer deploy).
  - `deploy/nginx/conf.d/site-ssl.conf.template`: config Nginx HTTP + HTTPS (después del SSL).
  - `deploy/scripts/01-install-docker.sh`: instala Docker y configura firewall (se corre una sola vez).
  - `deploy/scripts/02-deploy.sh`: despliega el sitio en HTTP o HTTPS según haya certificado.
  - `deploy/scripts/03-ssl.sh`: emite certificado SSL y actualiza Nginx para HTTPS.
  - `deploy/scripts/04-renew-cron.sh`: configura auto-renovación del certificado con `cron`.

---

## 1. Variables de entorno (`deploy/.env`)

En `deploy/.env` configurás tu dominio y mail (usados por los scripts actuales):

- `DOMAIN`: dominio que apunta al VPS (ej: `tu-dominio.com`).
- `EMAIL`: email válido para los avisos de Let's Encrypt.

Para el flujo actual, lo importante es que:

- `DOMAIN` tenga el dominio que realmente apunta al VPS.
- `EMAIL` sea válido (Let's Encrypt lo usa para avisos).

---

## 2. DNS en Hostinger (dominio → VPS)

En el panel de Hostinger del dominio:

1. Crear/editar registro `A` para `@` apuntando a la IP de tu VPS (Vexyhost).
2. Crear registro `A` para `www` apuntando a la misma IP.
3. Esperar propagación (suele ser 5–30 minutos).

Sin esto, Let's Encrypt no va a poder validar el dominio.

---

## 3. Preparar el VPS (primera vez)

1. Conectate al VPS (ajustá usuario/IP si cambian):

   ```bash
   ssh root@TU_VPS_IP
   ```

2. Cloná el repo (si todavía no está clonado) y entrá a `deploy/`:

   ```bash
   git clone git@github.com:NicolasSEstigarribia/Portfolio.git
   cd Portfolio/deploy
   ```

3. Creá/ajustá `deploy/.env` con tu dominio y email:

   ```env
   DOMAIN=tu-dominio.com
   EMAIL=tu-correo@ejemplo.com
   ```

4. Instalá Docker y configurá el firewall (solo la primera vez en ese VPS):

   ```bash
   ./scripts/01-install-docker.sh
   ```

5. **Cerrá y volvé a abrir** la sesión SSH para que el grupo `docker` se aplique al usuario actual.

---

## 4. Primer deploy manual al VPS

### 4.1. Deploy del sitio en HTTP

Ya con Docker instalado y la sesión reconectada:

```bash
cd ~/Portfolio/deploy
```

1. Actualizá el repo si hiciste cambios:

   ```bash
   git pull
   ```

2. Verificá que `deploy/.env` tenga `DOMAIN` y `EMAIL` correctos.

3. Hacé el deploy del sitio (HTTP o HTTPS, según el estado de certificados):

   ```bash
   ./scripts/02-deploy.sh
   ```

   Este script:

   - Genera `deploy/nginx/conf.d/site.conf` desde el template correspondiente:
     - `site.conf.template` si aún no hay certificado (solo HTTP).
     - `site-ssl.conf.template` si ya existe un certificado (HTTP→HTTPS).
   - Si detecta un proyecto Jaspr en `public/` (archivo `public/pubspec.yaml`):
     - Ejecuta `dart pub get` y `jaspr build` dentro de `public/`.
     - Copia el contenido de `public/build/jaspr/` a `deploy/site/`.
   - Si no detecta Jaspr, mantiene el flujo anterior copiando `public/` tal cual a `deploy/site/`.
   - Levanta el stack definido en `deploy/compose.yml` (`nginx`, `app`, `certbot`).

4. Probar que HTTP funciona (desde tu máquina local):

   ```bash
   curl -I http://tu-dominio.com
   curl -I http://www.tu-dominio.com
   ```

   Deberías obtener `HTTP/1.1 200 OK`.

### 4.2. Emitir certificado SSL y activar HTTPS

Con HTTP funcionando y DNS propagado, emití el certificado:

```bash
cd ~/Portfolio/deploy
./scripts/03-ssl.sh
```

Este script:

- Asegura que `nginx` y `certbot` estén arriba.
- Corre `certbot certonly` con `--webroot` usando `deploy/data/www`.
- Regenera la config de Nginx (`deploy/nginx/conf.d/site.conf`) usando el template con SSL.
- Recarga Nginx para aplicar certificados y redirecciones a HTTPS.

Probar desde tu máquina:

```bash
curl -I https://tu-dominio.com
curl -I https://www.tu-dominio.com
```

Deberías ver respuestas `200` o `301` ya en HTTPS.

### 4.3. Auto-renovación de certificados

Para que Let's Encrypt se renueve solo:

```bash
cd ~/Portfolio/deploy
./scripts/04-renew-cron.sh
```

Esto agrega una entrada en `crontab` que:

- Ejecuta `certbot renew` cada 12 horas usando el mismo webroot.
- Si se renueva, recarga Nginx en el contenedor `web_nginx`.

Podés ver el cron actual con:

```bash
crontab -l
```

---

## 5. Deploy automático con GitHub Actions (opcional)

Hay un workflow en `.github/workflows/deploy.yml` que se ejecuta en cada `push` a `main`.
Lo que hace es conectarse por SSH al VPS y correr `./scripts/02-deploy.sh` por vos.

### 5.1. Requisitos previos

- El repo debe estar clonado en el VPS en `~/Portfolio` (o ajustar la ruta en el workflow).
- El primer deploy manual debe haber funcionado (Docker instalado, `02-deploy.sh` OK).
- Tenés un usuario con acceso SSH al VPS (ej: `root` o `deploy`).

### 5.2. Crear la clave SSH y autorizarla en el VPS

En tu máquina local:

```bash
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/portfolio_deploy
```

Agregar la clave pública al VPS (ajustando usuario/IP):

```bash
ssh-copy-id -i ~/.ssh/portfolio_deploy.pub root@TU_VPS_IP
```

### 5.3. Configurar los secrets en GitHub

En el repositorio de GitHub: `Settings` → `Security` → `Secrets and variables` → `Actions` → `New repository secret`:

- `SSH_HOST`: IP o dominio del VPS (ej: `TU_VPS_IP` o `tu-dominio.com`).
- `SSH_USER`: usuario SSH (ej: `root` o `deploy`).
- `SSH_PORT`: puerto SSH (si usás el default, `22`).
- `SSH_KEY`: contenido completo de la clave privada, por ejemplo el archivo `~/.ssh/portfolio_deploy` (copiado tal cual).

Con estos secrets configurados, el workflow `Deploy to VPS` va a:

1. Conectarse al VPS por SSH.
2. Hacer `git fetch` + `git reset --hard origin/main`.
3. Ejecutar `./scripts/02-deploy.sh` dentro de `deploy/`.

---

## 6. Actualizar el sitio cuando cambies el código

Cuando cambies algo en el proyecto Jaspr dentro de `public/`:

- **Si usás el deploy automático**:
  - Hacés `git commit` + `git push` a `main`.
  - GitHub Actions corre el workflow y se encarga de ejecutar `./scripts/02-deploy.sh` en el VPS.

- **Si querés hacerlo manualmente**:

  1. En el VPS:

     ```bash
     cd ~/Portfolio
     git pull
     cd deploy
     ./scripts/02-deploy.sh
     ```

  2. Nginx seguirá usando el mismo certificado; solo se actualiza el contenido del sitio.

---

## 7. Deploy local de prueba (opcional)

Para probar el sitio sin todo el stack de `deploy/`, podés usar el `docker-compose.yml` de la raíz:

```bash
docker compose up -d
```

Esto levanta un Nginx simple que sirve `./public` en `http://localhost:80`.
