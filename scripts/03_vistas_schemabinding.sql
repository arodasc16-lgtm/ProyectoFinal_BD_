USE Academia2022;
GO
/* 2 vistas con SCHEMABINDING + agregación + GROUP BY */

IF OBJECT_ID('App.vw_CargaPorAlumno','V') IS NOT NULL
  DROP VIEW App.vw_CargaPorAlumno;
GO
CREATE VIEW App.vw_CargaPorAlumno
WITH SCHEMABINDING
AS
SELECT m.AlumnoID, m.MatriculaPeriodo, COUNT_BIG(*) AS TotalCursos
FROM Academico.Matriculas AS m
GROUP BY m.AlumnoID, m.MatriculaPeriodo;
GO

IF OBJECT_ID('App.vw_OcupacionPorPeriodo','V') IS NOT NULL
  DROP VIEW App.vw_OcupacionPorPeriodo;
GO
CREATE VIEW App.vw_OcupacionPorPeriodo
WITH SCHEMABINDING
AS
SELECT m.MatriculaPeriodo, COUNT_BIG(*) AS TotalMatriculas
FROM Academico.Matriculas AS m
GROUP BY m.MatriculaPeriodo;
GO

-- Evidencia de funcionamiento
SELECT TOP 10 * FROM App.vw_CargaPorAlumno;
SELECT TOP 10 * FROM App.vw_OcupacionPorPeriodo;
