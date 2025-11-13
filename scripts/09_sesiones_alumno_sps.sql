USE Academia2022;
GO
/* Tabla de sesiones */
IF OBJECT_ID('Seguridad.SesionesAlumno','U') IS NULL
CREATE TABLE Seguridad.SesionesAlumno(
  SesionID  BIGINT IDENTITY(1,1) PRIMARY KEY,
  AlumnoID  INT NOT NULL,
  LoginName sysname NOT NULL,
  InicioUTC DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  FinUTC    DATETIME2 NULL
);

-- Iniciar sesión
IF OBJECT_ID('Seguridad.sp_IniciarSesionAlumno','P') IS NOT NULL
  DROP PROCEDURE Seguridad.sp_IniciarSesionAlumno;
GO
CREATE PROCEDURE Seguridad.sp_IniciarSesionAlumno @AlumnoID INT
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO Seguridad.SesionesAlumno(AlumnoID, LoginName)
  VALUES(@AlumnoID, ORIGINAL_LOGIN());

  INSERT INTO Seguridad.AuditoriaAccesos(EventType, LoginName, AlumnoID)
  VALUES('AlumnoLogin', ORIGINAL_LOGIN(), @AlumnoID);

  PRINT CONCAT('Sesion iniciada para AlumnoID=', @AlumnoID, ' por ', ORIGINAL_LOGIN());
END
GO

-- Cerrar sesión
IF OBJECT_ID('Seguridad.sp_CerrarSesionAlumno','P') IS NOT NULL
  DROP PROCEDURE Seguridad.sp_CerrarSesionAlumno;
GO
CREATE PROCEDURE Seguridad.sp_CerrarSesionAlumno @AlumnoID INT
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE TOP(1) Seguridad.SesionesAlumno
     SET FinUTC = SYSUTCDATETIME()
  WHERE AlumnoID = @AlumnoID
    AND FinUTC IS NULL
  ORDER BY SesionID DESC;

  INSERT INTO Seguridad.AuditoriaAccesos(EventType, LoginName, AlumnoID)
  VALUES('AlumnoLogout', ORIGINAL_LOGIN(), @AlumnoID);

  PRINT CONCAT('Sesion cerrada para AlumnoID=', @AlumnoID, ' por ', ORIGINAL_LOGIN());
END
GO

-- Evidencia
EXEC Seguridad.sp_IniciarSesionAlumno @AlumnoID = 1;
EXEC Seguridad.sp_CerrarSesionAlumno  @AlumnoID = 1;
SELECT TOP 10 * FROM Seguridad.SesionesAlumno ORDER BY SesionID DESC;
SELECT TOP 10 * FROM Seguridad.AuditoriaAccesos ORDER BY AuditoriaID DESC;
