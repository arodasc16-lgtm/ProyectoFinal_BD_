# Manual Técnico — ProyectoFinal_BD (Academia2022)

## 1. Diseño de consultas (Vistas con SCHEMABINDING)
- **Scripts**: `03_vistas_schemabinding.sql`
- **Evidencias**: (pega aquí capturas de SELECT TOP 10 …)
- **Por qué**: materializa agregados estables; permite indexarlas.

## 2. PIVOT / Ventanas
- **Scripts**: `04_pivot_y_window.sql`
- **Evidencias**: ranking por periodo, PIVOT por periodos.
- **Por qué**: comparación fácil entre periodos; análisis temporal (LAG).

## 3. Optimización y Planes
- **Scripts**: `05_optimizacion_planes.sql`
- **Evidencias**: Actual Execution Plan, STATISTICS IO/TIME.
- **Por qué**: índice compuesto `(AlumnoID, MatriculaPeriodo)` reduce scans.

## 4. Seguridad — Row-Level Security (RLS)
- **Scripts**: `06_rls_alumnos.sql`
- **Evidencias**: `ORIGINAL_LOGIN()`, consulta filtrada.
- **Por qué**: menor privilegio por fila; aislamiento por usuario.

## 5. Roles y permisos
- **Scripts**: `07_roles_permisos.sql`
- **Evidencias**: salida de `sys.database_permissions`.
- **Por qué**: administración centralizada vía roles.

## 6. Auditoría de accesos
- **Scripts**: `08_auditoria_accesos.sql`
- **Evidencias**: inserciones automáticas (LOGON), tabla de auditoría.
- **Notas**: trigger LOGON requiere nivel servidor.

## 7. SPs de sesión (Login/Logout)
- **Scripts**: `09_sesiones_alumno_sps.sql`
- **Evidencias**: PRINTs, registros en `AuditoriaAccesos` y `SesionesAlumno`.

## 8. Backups FULL y Diferencial
- **Scripts**: `10_backup_full_diff.sql`
- **Evidencias**: `msdb.dbo.backupset`, `Seguridad.RegistroBackups`.
- **Notas**: ajustar rutas; demostrar RESTORE si se solicita.

## 9. Diccionario de datos
- **Archivo**: `docs/DiccionarioDatos.md` (opcional)
