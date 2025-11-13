# Diccionario de Datos — Academia2022

## Esquema: Academico

| Tabla | Campo | Tipo de dato | Descripción | Restricciones |
|--------|--------|---------------|--------------|----------------|
| **Carreras** | CarreraID | INT | Identificador único de carrera | PK, IDENTITY |
|  | CarreraNombre | NVARCHAR(80) | Nombre de la carrera | UNIQUE, NOT NULL |
| **Alumnos** | AlumnoID | INT | Identificador del alumno | PK, IDENTITY |
|  | AlumnoNombre | NVARCHAR(60) | Nombre propio del alumno | NOT NULL |
|  | AlumnoApellido | NVARCHAR(60) | Apellido del alumno | NOT NULL |
|  | AlumnoEmail | NVARCHAR(120) | Correo electrónico | UNIQUE |
|  | AlumnoEdad | TINYINT | Edad del alumno | CHECK (>=16) |
|  | AlumnoActivo | BIT | Indica si está activo | DEFAULT 1 |
|  | CarreraID | INT | FK hacia Carreras | FK SET NULL |
|  | ContactoID | INT | FK hacia Contactos | FK |
|  | NombreCompleto | AS (Nombre + Apellido) | Campo calculado | PERSISTED |
| **Cursos** | CursoID | INT | Identificador de curso | PK, IDENTITY |
|  | CursoNombre | NVARCHAR(100) | Nombre del curso | UNIQUE |
|  | CursoCreditosECTS | TINYINT | Créditos ECTS | CHECK (1-10) |
|  | CursoCodigo | INT | Código de curso (auto) | DEFAULT NEXT VALUE FOR SeqCodigoCurso |
| **Matriculas** | AlumnoID | INT | FK hacia Alumnos | PK compuesto |
|  | CursoID | INT | FK hacia Cursos | PK compuesto |
|  | MatriculaPeriodo | CHAR(4) | Periodo académico (p.ej. '24S1') | CHECK formato |
| **Contactos** | ContactoID | INT | ID contacto | PK |
|  | Email | NVARCHAR(120) | Email contacto | UNIQUE |
|  | Telefono | VARCHAR(20) | Teléfono | - |
| **AlumnoIdiomas** | AlumnoID | INT | FK hacia Alumnos | PK compuesto |
|  | Idioma | NVARCHAR(40) | Idioma | PK compuesto |
|  | Nivel | NVARCHAR(20) | Nivel del idioma | NOT NULL |

---

## Esquema: Seguridad

| Tabla | Campo | Tipo | Descripción |
|--------|--------|------|-------------|
| **UsuariosAlumno** | LoginName | sysname | Usuario autenticado | PK |
|  | AlumnoID | INT | FK hacia Alumnos | - |
| **AuditoriaAccesos** | AuditoriaID | BIGINT | Identificador | PK |
|  | EventType | VARCHAR(30) | Tipo de evento (LOGON, Login, Logout) | - |
|  | LoginName | sysname | Usuario que generó el evento | - |
|  | HostName | sysname | Host origen | - |
|  | AppName | NVARCHAR(128) | Aplicación origen | - |
|  | LoginTime | DATETIME2 | Fecha y hora UTC | DEFAULT |
|  | SessionId | INT | ID de sesión SQL | - |
|  | AlumnoID | INT | Referencia (opcional) | - |
| **SesionesAlumno** | SesionID | BIGINT | ID | PK |
|  | AlumnoID | INT | FK hacia Alumnos | - |
|  | LoginName | sysname | Usuario | - |
|  | InicioUTC | DATETIME2 | Inicio sesión | DEFAULT |
|  | FinUTC | DATETIME2 | Fin sesión | NULL si activa |
| **RegistroBackups** | RegistroID | BIGINT | ID | PK |
|  | Tipo | VARCHAR(12) | FULL / DIFF | - |
|  | FechaUTC | DATETIME2 | Fecha del backup | DEFAULT |
|  | Archivo | NVARCHAR(4000) | Ruta del archivo .bak | - |

---

## Esquema: App
| Vista | Descripción | Tipo |
|--------|--------------|------|
| `App.vw_ResumenAlumno` | Vista pública de alumnos activos | SELECT |
| `App.vw_CargaPorAlumno` | Total de cursos por alumno/periodo | SCHEMABINDING |
| `App.vw_OcupacionPorPeriodo` | Matriculas totales por periodo | SCHEMABINDING |
| `App.vw_MatriculasPorCurso` | Vista indexada con COUNT_BIG() por curso | SCHEMABINDING + CLUSTERED INDEX |

---

## Esquema: Lab (reserva)
Usado para pruebas o funciones experimentales (sin objetos obligatorios en este proyecto).
