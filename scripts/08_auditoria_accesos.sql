USE Academia2022;
GO
/* Auditoría de accesos */
IF OBJECT_ID('Seguridad.AuditoriaAccesos','U') IS NULL
CREATE TABLE Seguridad.AuditoriaAccesos(
  AuditoriaID BIGINT IDENTITY(1,1) PRIMARY KEY,
  EventType   VARCHAR(30) NOT NULL,   -- LOGON | AlumnoLogin | AlumnoLogout
  LoginName   sysname NOT NULL,
  HostName    sysname NULL,
  AppName     NVARCHAR(128) NULL,
  LoginTime   DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  SessionId   INT NULL,
  AlumnoID    INT NULL
);
GO

/* LOGON trigger (nivel servidor) — requiere sysadmin.
   Si no tienes permisos, deja este bloque tal cual o coméntalo. */
IF EXISTS (SELECT 1 FROM sys.server_triggers WHERE name='tr_ServerLogon_Academia2022')
BEGIN
  DISABLE TRIGGER tr_ServerLogon_Academia2022 ON ALL SERVER;
  DROP TRIGGER tr_ServerLogon_Academia2022 ON ALL SERVER;
END
EXEC('CREATE TRIGGER tr_ServerLogon_Academia2022
ON ALL SERVER
FOR LOGON
AS
BEGIN
  BEGIN TRY
    INSERT INTO Academia2022.Seguridad.AuditoriaAccesos(EventType,LoginName,HostName,AppName,LoginTime,SessionId)
    SELECT ''LOGON'', ORIGINAL_LOGIN(), HOST_NAME(), PROGRAM_NAME(), SYSUTCDATETIME(), @@SPID;
  END TRY
  BEGIN CATCH
  END CATCH
END');
GO

-- Evidencia rápida
SELECT TOP 20 * FROM Seguridad.AuditoriaAccesos ORDER BY AuditoriaID DESC;
