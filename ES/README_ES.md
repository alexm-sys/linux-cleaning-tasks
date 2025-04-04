# 🧹 Script de Limpieza Diaria para Servidores Linux

Este repositorio contiene un script Bash totalmente personalizable que permite automatizar tareas comunes de mantenimiento en un sistema Linux, como:

- Limpieza de recursos Docker
- Rotación de logs del sistema
- Limpieza de archivos temporales en `/tmp`
- Registro de la actividad y limpieza automática de sus propios logs

---

## 📁 Archivos incluidos

- `cleaning_tasks_ES.sh` → Script principal de limpieza
- `cleaning_tasks_ES.conf` → Archivo de configuración editable por el usuario

---

## ⚙️ Configuración

Antes de ejecutar el script, edita el archivo `cleaning_tasks_ES.conf` con tus preferencias:

```bash
# Activar o desactivar cada función
CLEAN_DOCKER="yes"
ROTATE_LOGS="yes"
CLEAN_TMP="yes"

# Activar modo prueba (no ejecuta, solo muestra)
DRY_RUN="no"

# Días para conservar logs del sistema
LOG_RETENTION_DAYS=7

# Días desde el último acceso para eliminar archivos en /tmp
TMP_RETENTION_DAYS=1

# Días máximos para conservar el log del script
MAX_LOG_AGE_DAYS=30

# Ruta del log del script (requiere permisos de escritura)
SCRIPT_LOG="/var/log/limpieza_diaria.log"
```

> ⚠️ **Este archivo debe estar en la misma carpeta que el script o modificar la ruta en el `.sh`**

---

## 🔐 Permisos necesarios

Este script **requiere permisos de administrador** para funcionar correctamente. Es necesario porque:

- Modifica archivos en `/etc/logrotate.d/`
- Usa `docker system prune`
- Elimina archivos en `/tmp`
- Escribe logs en `/var/log`

---

## 🧪 Ejecución manual

```bash
sudo bash cleaning_tasks.sh
```

Si activas el modo `DRY_RUN="yes"` en el `.conf`, el script **simulará** todas las acciones sin ejecutarlas realmente.

---

## ⏰ Automatización con cron (recomendado)

Edita el `crontab` del usuario `root`:

```bash
sudo crontab -e
```

Y añade una línea como esta para ejecutarlo todos los días a las 2:00 AM:

```cron
0 2 * * * /ruta/completa/cleaning_tasks_ES.sh
```

✔️ No es necesario usar `sudo` en el comando, ya que el cron corre como root.

---

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT.
