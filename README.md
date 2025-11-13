# ProyectoFinal_BD — Academia2022 (Módulo III)

Entrega con seguridad, reportes y operaciones.

## Estructura
- `/scripts/` — DDL/DML/DCL/DQL por tema (idempotentes).
- `/docs/` — Manual técnico y diccionario de datos.
- `/evidencias/` — Capturas de ejecución (RLS, planes, backups, etc.).
- `deploy.sql` — Script maestro (`SQLCMD Mode`) que incluye todos los scripts en orden.

## Requisitos
- SQL Server 2019/2022
- Permisos para crear DB, logon trigger (si aplica) y backups.
- Rutas de backups ajustadas en `scripts/10_backup_full_diff.sql`.

## Cómo desplegar
1. Abrir `deploy.sql` en SSMS.
2. Activar **Query → SQLCMD Mode**.
3. Ejecutar. Debe imprimir: `ProyectoFinal_BD desplegado correctamente.`

## Evidencias sugeridas
- `SELECT TOP 10` de `App.vw_CargaPorAlumno` y `App.vw_OcupacionPorPeriodo`.
- Planes de ejecución del script 05 (IO/TIME).
- RLS: `ORIGINAL_LOGIN()` y filtrado en `Academico.Alumnos`.
- `sys.database_permissions` para roles/permisos.
- Auditoría: `Seguridad.AuditoriaAccesos`.
- SPs: prints + inserciones en auditoría/sesiones.
- Backups: `msdb.dbo.backupset` y `Seguridad.RegistroBackups`.
