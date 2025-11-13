USE Academia2022;
GO
/* Mapeo Login ↔ AlumnoID */
IF OBJECT_ID('Seguridad.UsuariosAlumno','U') IS NULL
CREATE TABLE Seguridad.UsuariosAlumno(
  LoginName sysname PRIMARY KEY,
  AlumnoID  INT NOT NULL
);

-- Función de predicado (Alumno activo + mapeo de usuario)
IF OBJECT_ID('Seguridad.fnRLS_Alumnos','IF') IS NOT NULL
  DROP FUNCTION Seguridad.fnRLS_Alumnos;
GO
CREATE FUNCTION Seguridad.fnRLS_Alumnos(@AlumnoID int, @Activo bit)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
  SELECT 1 AS Permitido
  WHERE @Activo = 1
    AND EXISTS (
      SELECT 1
      FROM Seguridad.UsuariosAlumno ua
      WHERE ua.AlumnoID = @AlumnoID
        AND ua.LoginName = ORIGINAL_LOGIN()
    );
GO

-- Política
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name='RLS_Alumnos_Policy')
  DROP SECURITY POLICY Seguridad.RLS_Alumnos_Policy;
GO
CREATE SECURITY POLICY Seguridad.RLS_Alumnos_Policy
ADD FILTER PREDICATE Seguridad.fnRLS_Alumnos(AlumnoID, AlumnoActivo) ON Academico.Alumnos,
ADD BLOCK  PREDICATE Seguridad.fnRLS_Alumnos(AlumnoID, AlumnoActivo) ON Academico.Alumnos AFTER INSERT
WITH (STATE = ON);
GO

-- Demo/evidencia:
MERGE Seguridad.UsuariosAlumno AS t
USING (SELECT CAST(SUSER_SNAME() AS sysname) AS LoginName, 1 AS AlumnoID) s
ON t.LoginName = s.LoginName
WHEN NOT MATCHED THEN INSERT(LoginName,AlumnoID) VALUES(s.LoginName,s.AlumnoID);

SELECT ORIGINAL_LOGIN() AS UsuarioReal, SUSER_SNAME() AS Contexto;
SELECT * FROM Academico.Alumnos; -- Debe filtrar por AlumnoID asignado y solo activos
