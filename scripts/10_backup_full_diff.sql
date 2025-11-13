USE Academia2022;
GO
/* Registro interno de backups */
IF OBJECT_ID('Seguridad.RegistroBackups','U') IS NULL
CREATE TABLE Seguridad.RegistroBackups(
  RegistroID BIGINT IDENTITY(1,1) PRIMARY KEY,
  Tipo       VARCHAR(12) NOT NULL, -- FULL | DIFF
  FechaUTC   DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  Archivo    NVARCHAR(4000) NOT NULL
);

-- Ajusta estas rutas para tu servidor
DECLARE @FullFile NVARCHAR(4000) = N'C:\Backups\Academia2022_FULL.bak';
DECLARE @DiffFile NVARCHAR(4000) = N'C:\Backups\Academia2022_DIFF.bak';

-- FULL
BACKUP DATABASE Academia2022 TO DISK = @FullFile WITH INIT, COMPRESSION, STATS=5;
INSERT INTO Seguridad.RegistroBackups(Tipo,Archivo) VALUES('FULL', @FullFile);

-- Diferencial
BACKUP DATABASE Academia2022 TO DISK = @DiffFile WITH DIFFERENTIAL, INIT, COMPRESSION, STATS=5;
INSERT INTO Seguridad.RegistroBackups(Tipo,Archivo) VALUES('DIFF', @DiffFile);

-- Verificación en msdb y tabla local
SELECT TOP 10 database_name, backup_start_date, backup_finish_date, type
FROM msdb.dbo.backupset
WHERE database_name='Academia2022'
ORDER BY backup_finish_date DESC;

SELECT TOP 10 * FROM Seguridad.RegistroBackups ORDER BY RegistroID DESC;
