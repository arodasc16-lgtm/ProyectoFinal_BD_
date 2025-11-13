USE Academia2022;
GO

/* === Tablas base === */
IF OBJECT_ID('Academico.Carreras','U') IS NULL
CREATE TABLE Academico.Carreras(
  CarreraID     INT IDENTITY(1,1) CONSTRAINT PK_Carreras PRIMARY KEY,
  CarreraNombre NVARCHAR(80) NOT NULL CONSTRAINT UQ_Carreras_Nombre UNIQUE
);

IF OBJECT_ID('Academico.Alumnos','U') IS NULL
CREATE TABLE Academico.Alumnos(
  AlumnoID       INT IDENTITY(1,1) CONSTRAINT PK_Alumnos PRIMARY KEY,
  AlumnoNombre   NVARCHAR(60) NOT NULL,
  AlumnoApellido NVARCHAR(60) NOT NULL,
  AlumnoEmail    NVARCHAR(120) NULL CONSTRAINT UQ_Alumnos_Email UNIQUE,
  AlumnoEdad     TINYINT NOT NULL CONSTRAINT CK_Alumno_Edad CHECK (AlumnoEdad >= 16),
  AlumnoActivo   BIT NOT NULL CONSTRAINT DF_Alumno_Activo DEFAULT (1),
  CarreraID      INT NULL CONSTRAINT FK_Alumnos_Carreras
                 FOREIGN KEY REFERENCES Academico.Carreras(CarreraID) ON DELETE SET NULL
);

IF OBJECT_ID('Academico.Cursos','U') IS NULL
CREATE TABLE Academico.Cursos(
  CursoID           INT IDENTITY(1,1) CONSTRAINT PK_Cursos PRIMARY KEY,
  CursoNombre       NVARCHAR(100) NOT NULL CONSTRAINT UQ_Cursos_Nombre UNIQUE,
  CursoCreditosECTS TINYINT NOT NULL CONSTRAINT CK_Cursos_Creditos CHECK (CursoCreditosECTS BETWEEN 1 AND 10)
);

IF OBJECT_ID('Academico.Matriculas','U') IS NULL
CREATE TABLE Academico.Matriculas(
  AlumnoID         INT NOT NULL,
  CursoID          INT NOT NULL,
  MatriculaPeriodo CHAR(4) NOT NULL
      CONSTRAINT CK_Matriculas_Periodo CHECK (MatriculaPeriodo LIKE '[0-9][0-9][S][12]'),
  CONSTRAINT PK_Matriculas PRIMARY KEY (AlumnoID, CursoID, MatriculaPeriodo),
  CONSTRAINT FK_Matriculas_Alumnos FOREIGN KEY (AlumnoID) REFERENCES Academico.Alumnos(AlumnoID) ON DELETE CASCADE,
  CONSTRAINT FK_Matriculas_Cursos  FOREIGN KEY (CursoID)  REFERENCES Academico.Cursos(CursoID)  ON DELETE CASCADE
);

/* Campo calculado y tablas auxiliares */
IF COL_LENGTH('Academico.Alumnos','NombreCompleto') IS NULL
ALTER TABLE Academico.Alumnos
ADD NombreCompleto AS (AlumnoNombre + N' ' + AlumnoApellido) PERSISTED;

IF OBJECT_ID('Academico.Contactos','U') IS NULL
CREATE TABLE Academico.Contactos(
  ContactoID INT IDENTITY(1,1) CONSTRAINT PK_Contactos PRIMARY KEY,
  Email      NVARCHAR(120) NULL CONSTRAINT UQ_Contactos_Email UNIQUE,
  Telefono   VARCHAR(20)   NULL
);

IF COL_LENGTH('Academico.Alumnos','ContactoID') IS NULL
ALTER TABLE Academico.Alumnos ADD ContactoID INT NULL
  CONSTRAINT FK_Alumnos_Contactos FOREIGN KEY REFERENCES Academico.Contactos(ContactoID);

IF OBJECT_ID('Academico.AlumnoIdiomas','U') IS NULL
CREATE TABLE Academico.AlumnoIdiomas(
  AlumnoID INT NOT NULL,
  Idioma   NVARCHAR(40) NOT NULL,
  Nivel    NVARCHAR(20) NOT NULL,
  CONSTRAINT PK_AlumnoIdiomas PRIMARY KEY (AlumnoID, Idioma),
  CONSTRAINT FK_AI_Alumno FOREIGN KEY (AlumnoID)
    REFERENCES Academico.Alumnos(AlumnoID) ON DELETE CASCADE
);

/* Vista de capa App (datos no sensibles) */
IF OBJECT_ID('App.vw_ResumenAlumno','V') IS NOT NULL DROP VIEW App.vw_ResumenAlumno;
GO
CREATE VIEW App.vw_ResumenAlumno
AS
SELECT a.AlumnoID, a.NombreCompleto, a.AlumnoEdad, a.CarreraID
FROM Academico.Alumnos a
WHERE a.AlumnoActivo = 1;
GO
