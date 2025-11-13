USE Academia2022;
GO
/* Roles */
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='AppReader')  CREATE ROLE AppReader;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='AppWriter')  CREATE ROLE AppWriter;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='AuditorDB')  CREATE ROLE AuditorDB;

/* Permisos mínimos por rol */
GRANT SELECT ON SCHEMA::App TO AppReader;
GRANT SELECT ON OBJECT::Academico.Alumnos TO AppReader; -- opcional si consultas base

GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::Academico.Matriculas TO AppWriter;

GRANT SELECT ON OBJECT::Seguridad.UsuariosAlumno TO AuditorDB;
GRANT VIEW DATABASE STATE TO AuditorDB;

/* Evidencia de permisos */
SELECT dp.class_desc, OBJECT_SCHEMA_NAME(dp.major_id) AS esquema,
       OBJECT_NAME(dp.major_id) AS objeto, dp.permission_name, dp.state_desc,
       USER_NAME(dp.grantee_principal_id) AS rol
FROM sys.database_permissions dp
WHERE USER_NAME(dp.grantee_principal_id) IN ('AppReader','AppWriter','AuditorDB')
ORDER BY rol, esquema, objeto, permission_name;
