USE Academia2022;
GO

/* Funciones ventana: ranking y comparación (LAG) */
WITH Carga AS (
  SELECT AlumnoID, MatriculaPeriodo, COUNT(*) AS CursosInscritos
  FROM Academico.Matriculas
  GROUP BY AlumnoID, MatriculaPeriodo
)
SELECT a.NombreCompleto,
       c.MatriculaPeriodo,
       c.CursosInscritos,
       DENSE_RANK() OVER(PARTITION BY c.MatriculaPeriodo ORDER BY c.CursosInscritos DESC) AS RankingEnPeriodo,
       LAG(c.CursosInscritos,1,0) OVER(PARTITION BY c.AlumnoID ORDER BY c.MatriculaPeriodo) AS CargaPeriodoAnterior
FROM Carga c
JOIN Academico.Alumnos a ON a.AlumnoID = c.AlumnoID
ORDER BY c.MatriculaPeriodo, RankingEnPeriodo;

/* PIVOT: alumnos por curso y periodo (columnas fijas ejemplo) */
WITH BasePivot AS (
  SELECT CursoID, MatriculaPeriodo, COUNT(*) AS TotalAlumnos
  FROM Academico.Matriculas
  GROUP BY CursoID, MatriculaPeriodo
)
SELECT c.CursoNombre,
       ISNULL(p.[24S1],0) AS [Periodo 24S1],
       ISNULL(p.[24S2],0) AS [Periodo 24S2],
       ISNULL(p.[25S1],0) AS [Periodo 25S1]
FROM BasePivot
PIVOT (SUM(TotalAlumnos) FOR MatriculaPeriodo IN ([24S1],[24S2],[25S1])) AS p
JOIN Academico.Cursos c ON c.CursoID = p.CursoID
ORDER BY c.CursoNombre;

/* Utilidad breve:
   - Ventanas (RANK/LAG): comparar y ordenar por partición.
   - PIVOT: filas a columnas para reportes tipo Excel. */
