USE Academia2022;
GO

/* Índices */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Alumnos_NombreCompleto' AND object_id=OBJECT_ID('Academico.Alumnos'))
  CREATE INDEX IX_Alumnos_NombreCompleto ON Academico.Alumnos(NombreCompleto);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Matriculas_Curso_Periodo' AND object_id=OBJECT_ID('Academico.Matriculas'))
  CREATE INDEX IX_Matriculas_Curso_Periodo ON Academico.Matriculas(CursoID, MatriculaPeriodo) INCLUDE (AlumnoID);

/* Secuencia y código de curso */
IF NOT EXISTS (SELECT 1 FROM sys.sequences WHERE name='SeqCodigoCurso' AND SCHEMA_NAME(schema_id)='Academico')
  CREATE SEQUENCE Academico.SeqCodigoCurso AS INT START WITH 1000 INCREMENT BY 1;

IF COL_LENGTH('Academico.Cursos','CursoCodigo') IS NULL
ALTER TABLE Academico.Cursos
ADD CursoCodigo INT NOT NULL CONSTRAINT DF_Cursos_CursoCodigo DEFAULT (NEXT VALUE FOR Academico.SeqCodigoCurso);

/* Vista agregada indexada (Top Cursos) */
IF OBJECT_ID('App.vw_MatriculasPorCurso','V') IS NOT NULL
  DROP VIEW App.vw_MatriculasPorCurso;
GO
CREATE VIEW App.vw_MatriculasPorCurso
WITH SCHEMABINDING
AS
SELECT m.CursoID, COUNT_BIG(*) AS Total
FROM Academico.Matriculas AS m
GROUP BY m.CursoID;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_vw_MatriculasPorCurso' AND object_id=OBJECT_ID('App.vw_MatriculasPorCurso'))
  CREATE UNIQUE CLUSTERED INDEX IX_vw_MatriculasPorCurso ON App.vw_MatriculasPorCurso(CursoID);
GO
