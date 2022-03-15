-- Ver todas las BDs
SHOW DATABASES;

-- Selección de una tabla especificando la BD
SELECT * FROM TrabajosGraduacion.Trabajos;

-- Selección de una tabla sin especificar la BD (toma la BD predeterminada)
SELECT * FROM Trabajos;

-- Tipos de tablas en MySQL
SHOW ENGINES;

-- Creación de BD en MySQL
DROP DATABASE IF EXISTS LBD2022;
CREATE DATABASE IF NOT EXISTS LBD2022;

USE LBD2022;

-- Tabla con tipos de datos numéricos
DROP TABLE IF EXISTS Tabla; 

CREATE TABLE IF NOT EXISTS Tabla (
	colInt INT NOT NULL,
    colDecimal DECIMAL(10, 2) NOT NULL,
    colFloat FLOAT NOT NULL, 
    colBit BIT NOT NULL
) ENGINE=INNODB;

INSERT INTO Tabla VALUES(1, 100, 100, 1);
INSERT INTO Tabla VALUES(1, 100, 100, b'1');
INSERT INTO Tabla VALUES(1, 100, 100, b'0');

SELECT 
	colInt,
	@a := colDecimal/3, 
    @b := colFloat/3, 
    @a + @a + @a,
    @b + @b + @b,
    colBit
FROM Tabla;

-- Atributos para los tipos numéricos
DROP TABLE IF EXISTS Tabla; 

CREATE TABLE IF NOT EXISTS Tabla (
	colIntSinAncho INT ZEROFILL, -- 10 es el valor predeterminado del ancho
    colIntConAncho3 INT(3) ZEROFILL,
    colIntConAncho11ConZEROFILL INT(11) ZEROFILL, 
    colIntConAncho11SinZEROFILL INT(11), 
    colIntConAncho20 INT(20) ZEROFILL,
    colIntUnsigned INT UNSIGNED ZEROFILL -- 10 es el valor predeterminado del ancho
) ENGINE=INNODB;

INSERT INTO Tabla VALUES(1, 1, 1, 1, 1, 1);
INSERT INTO Tabla VALUES(10, 10, 10, 10, 10, 10);
INSERT INTO Tabla VALUES(100, 100, 100, 100, 100, 100);
INSERT INTO Tabla VALUES(1000, 1000, 1000, 1000, 1000, 1000);
INSERT INTO Tabla VALUES(10000, 10000, 10000, 10000, 10000, 10000);
INSERT INTO Tabla VALUES(10000, 10000, 10000, -2147483648, 10000, -2147483648); -- error en colIntUnsigned
INSERT INTO Tabla VALUES(10000, 10000, 10000, 4294967295, 10000, 4294967295); -- error en colIntConAncho11SinZEROFILL

SELECT * FROM Tabla;

-- Atributo AUTO_INCREMENT (columna entera)
DROP TABLE IF EXISTS Tabla; 

CREATE TABLE IF NOT EXISTS Tabla (
	colInt INT,
    colIntAutoIncrement INT AUTO_INCREMENT,
    PRIMARY KEY (colIntAutoIncrement)
) ENGINE=INNODB;

INSERT INTO Tabla (colInt) VALUES (100);
INSERT INTO Tabla (colInt) VALUES (200);
INSERT INTO Tabla (colInt) VALUES (300);

SELECT * FROM Tabla;
SELECT LAST_INSERT_ID();

INSERT INTO Tabla (colInt, colIntAutoIncrement) VALUES (400, 10);
INSERT INTO Tabla (colInt) VALUES (500);

SELECT * FROM Tabla;
SELECT LAST_INSERT_ID();

-- Atributo AUTO_INCREMENT (columna flotante)
DROP TABLE IF EXISTS Tabla; 

CREATE TABLE IF NOT EXISTS Tabla (
	colInt INT,
    colFloatAutoIncrement FLOAT(4, 2) AUTO_INCREMENT,
    PRIMARY KEY (colFloatAutoIncrement)
) ENGINE=INNODB;

INSERT INTO Tabla (colInt) VALUES (100);
INSERT INTO Tabla (colInt) VALUES (200);
INSERT INTO Tabla (colInt) VALUES (300);

SELECT * FROM Tabla;
SELECT LAST_INSERT_ID();

INSERT INTO Tabla (colInt, colFloatAutoIncrement) VALUES (400, 10.00);
INSERT INTO Tabla (colInt) VALUES (500);

SELECT * FROM Tabla;
SELECT LAST_INSERT_ID();

-- Tabla con tipos de datos para fechas
DROP TABLE IF EXISTS Tabla; 

CREATE TABLE IF NOT EXISTS Tabla (
    colIntAutoIncrement INT AUTO_INCREMENT,
    colFecha DATE,
    colFechaYHoraDateTime1 DATETIME DEFAULT CURRENT_TIMESTAMP,
    colFechaYHoraDateTime2 DATETIME(3),
    colFechaYHoraTimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    colHora1 TIME,
    colHora2 TIME(5), -- hasta 5 dígitos para los microsegundos
    PRIMARY KEY (colIntAutoIncrement)
) ENGINE=INNODB;

INSERT INTO Tabla (colFecha, colFechaYHoraDateTime2, colHora1, colHora2) VALUES ('2020-03-13', '2020-03-13 19:43:00.111', '19:43:00', '19:43:00.11111');
INSERT INTO Tabla (colFecha, colFechaYHoraDateTime2, colHora1, colHora2) VALUES ('2020-03-14', '2020-03-14 19:43:00.222', '19:43:00', '19:43:00.22222');
INSERT INTO Tabla (colFecha, colFechaYHoraDateTime2, colHora1, colHora2) VALUES ('2020-03-15', '2020-03-15 19:43:00.333', '19:43:00', '19:43:00.33333');
INSERT INTO Tabla (colFecha, colFechaYHoraDateTime2, colHora1, colHora2) VALUES ('2020-03-16', '2020-03-16 19:43:00.444', '19:43:00', '19:43:00.44444');
INSERT INTO Tabla (colFecha, colFechaYHoraDateTime2, colHora1, colHora2) 
VALUES (NULL, '2020-03-13 19:43:00.111', '19:43:00', '19:43:00.55555');

SELECT * FROM Tabla;


-- Tabla con tipos de datos CHAR y BINARY

DROP TABLE IF EXISTS Tabla; 

CREATE TABLE IF NOT EXISTS Tabla (
	colVarchar VARCHAR(10),
    colVarbinary VARBINARY(10)
) ENGINE=INNODB;

INSERT INTO Tabla VALUES ('mundo', 'mundo');
INSERT INTO Tabla VALUES ('Mundo', 'Mundo');
INSERT INTO Tabla VALUES ('Hola', 'Hola');
INSERT INTO Tabla VALUES ('hola', 'hola');

SELECT * FROM Tabla ORDER BY colVarchar;
-- Para poder ver una columna BINARY: preferencias - “SQL Execution” - “Treat Binary/Varbinary as nonbinary character string”
-- Hola, hola, mundo, Mundo: alfabético ascendente: si encuentra 2 iguales, según el orden de inserción
SELECT * FROM Tabla ORDER BY colVarbinary;
-- Hola, Mundo, hola, mundo: según el valor numérico de las cadenas

-- Tabla con tipo de dato Enum

DROP TABLE IF EXISTS Tabla; 

CREATE TABLE IF NOT EXISTS Tabla (
    marca VARCHAR(40) NOT NULL,
    tamanio ENUM('Small', 'Medium', 'Large')
) ENGINE=INNODB;

INSERT INTO Tabla (marca, tamanio) VALUES ('Marca1', 'Small'); -- posición = 1
INSERT INTO Tabla (marca, tamanio) VALUES ('Marca1', 'Medium'); -- posición = 2
INSERT INTO Tabla (marca, tamanio) VALUES ('Marca2', 'Medium'); -- posición = 2
INSERT INTO Tabla (marca, tamanio) VALUES ('Marca3', 'Small'); -- posición = 1
INSERT INTO Tabla (marca, tamanio) VALUES ('Marca3', 'Medium'); -- posición = 2
INSERT INTO Tabla (marca, tamanio) VALUES ('Marca3', 'Large'); -- posición = 3
INSERT INTO Tabla (marca, tamanio) VALUES ('Marca3', 'large'); -- valor válido, posición = 3
INSERT INTO Tabla (marca, tamanio) VALUES ('Marca3', NULL); -- valor válido, posición = NULL
INSERT INTO Tabla (marca, tamanio) VALUES ('Marca3', ''); -- valor inválido, posición = 0 (modo estricto debe estar deshabilitado. Se habilita mediante el archivo my.ini)
INSERT INTO Tabla (marca, tamanio) VALUES ('Marca4', 'Otro valor'); -- valor inválido
-- Si la columna tamanio se hubiera declarado como VARCHAR, 
-- insertar un millón de filas con el valor ‘medium’ requeriría 6 millones de bytes
-- Al declararse como ENUM se requieren 1 millón

SELECT marca, tamanio, tamanio + 0 as 'Posición' FROM Tabla;

SELECT * FROM Tabla
ORDER BY tamanio; 
-- ordena según la posición


-- Tabla con tipo de dato Set

DROP TABLE IF EXISTS Tabla; 

CREATE TABLE IF NOT EXISTS Tabla (
    idAlumno INT NOT NULL,
    turnos SET('Turno1', 'Turno2', 'Turno3')
) ENGINE=INNODB;

INSERT INTO Tabla (idAlumno, turnos) VALUES (1, 'Turno1'); -- valor válido
INSERT INTO Tabla (idAlumno, turnos) VALUES (2, 'Turno1,Turno2'); -- valor válido
INSERT INTO Tabla (idAlumno, turnos) VALUES (3, 'Turno1, Turno2'); -- valor inválido (espacio en blanco)
INSERT INTO Tabla (idAlumno, turnos) VALUES (4, 'Turno2,Turno1'); -- valor válido
INSERT INTO Tabla (idAlumno, turnos) VALUES (5, 'Turno1,Turno2,Turno3'); -- valor válido
INSERT INTO Tabla (idAlumno, turnos) VALUES (6, 'Turno1,Turno2,Turno3,Turno3'); -- valor válido
INSERT INTO Tabla (idAlumno, turnos) VALUES (7, ''); -- valor válido
INSERT INTO Tabla (idAlumno, turnos) VALUES (8, 'Turno1,Turno2,Turno3,Turno4'); -- valor inválido
INSERT INTO Tabla (idAlumno, turnos) VALUES (9, 'Turno4'); -- valor inválido

SELECT * FROM Tabla;
