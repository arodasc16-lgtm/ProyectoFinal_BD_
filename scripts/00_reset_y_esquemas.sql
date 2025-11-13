/* Reinicio de base (uso de laboratorio) */
IF DB_ID('Academia2022') IS NOT NULL
BEGIN
    ALTER DATABASE Academia2022 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Academia2022;
END
GO
CREATE DATABASE Academia2022;
GO
USE Academia2022;
GO

/* Esquemas base */
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='Academico') EXEC('CREATE SCHEMA Academico');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='Seguridad') EXEC('CREATE SCHEMA Seguridad');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='App')       EXEC('CREATE SCHEMA App');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='Lab')       EXEC('CREATE SCHEMA Lab');
GO
