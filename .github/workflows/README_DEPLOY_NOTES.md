Este archivo existe solo como referencia rápida para el workflow de GitHub Actions.

- El workflow `deploy.yml` asume que el repo está clonado en `~/Portfolio` en el VPS.
- El usuario remoto se toma de `secrets.SSH_USER` (por ejemplo `root` o `deploy`).
- El workflow se limita a:
  - `cd ~/Portfolio`
  - `git pull`
  - `cd deploy`
  - `./scripts/02-deploy.sh`

Requisitos previos en el VPS:

1. Haber corrido al menos una vez manualmente:
   - `./scripts/01-install-docker.sh`
   - `./scripts/02-deploy.sh`
   - `./scripts/03-ssl.sh`
   - (opcional) `./scripts/04-renew-cron.sh`
2. Tener `deploy/.env` configurado con `DOMAIN` y `EMAIL`.

