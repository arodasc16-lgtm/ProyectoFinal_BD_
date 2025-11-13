USE Academia2022;
GO
/* Índice propuesto para patrón AlumnoID+Periodo */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Matriculas_Alumno_Periodo' AND object_id=OBJECT_ID('Academico.Matriculas'))
  CREATE INDEX IX_Matriculas_Alumno_Periodo ON Academico.Matriculas(AlumnoID, MatriculaPeriodo) INCLUDE (CursoID);
GO

-- Captura de plan: habilita Actual Execution Plan en SSMS
SET STATISTICS IO ON; SET STATISTICS TIME ON;

-- Baseline (sin forzar índice)
SELECT AlumnoID, MatriculaPeriodo, COUNT(*) AS CantCursos
FROM Academico.Matriculas
WHERE AlumnoID = 1 AND MatriculaPeriodo BETWEEN '24S1' AND '25S1'
GROUP BY AlumnoID, MatriculaPeriodo;

-- Forzando índice (para comparar)
SELECT AlumnoID, MatriculaPeriodo, COUNT(*) AS CantCursos
FROM Academico.Matriculas WITH (INDEX(IX_Matriculas_Alumno_Periodo))
WHERE AlumnoID = 1 AND MatriculaPeriodo BETWEEN '24S1' AND '25S1'
GROUP BY AlumnoID, MatriculaPeriodo;

SET STATISTICS IO OFF; SET STATISTICS TIME OFF;
