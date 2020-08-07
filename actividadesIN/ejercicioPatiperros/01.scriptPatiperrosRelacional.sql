-- pasos iniciales para crear base de datos.
SET NOCOUNT ON;
GO
USE master;
GO

-- creando la base de datos.
DROP DATABASE IF EXISTS rePatiperros;
GO
CREATE DATABASE rePatiperros
ON PRIMARY 
(name='rePatiperros_data', filename='/var/opt/mssql/data/rePatiperros_data.mdf', size=5Mb, maxsize=500Mb, filegrowth=5Mb)
log ON 
(name='rePatiperros_logs', filename='/var/opt/mssql/data/rePatiperros_logs.ldf', size=10Mb, maxsize=20Mb, filegrowth=1Mb)
GO
USE rePatiperros;
GO




-- Creacion de tablas de la base de datos...
CREATE TABLE dbo.pasajero
(
    id_pasajero  INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre       NVARCHAR(50) NOT NULL,
    genero       NVARCHAR(15) NOT NULL,
    nacionalidad NVARCHAR(25) NOT NULL,
    rango_edad   NVARCHAR(7)  NOT NULL
);
GO

CREATE TABLE dbo.ticket
(
    id_ticket      INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    ciudad_origen  NVARCHAR(50) NOT NULL,
    pais_origen    NVARCHAR(30) NOT NULL,
    ciudad_destino NVARCHAR(50) NOT NULL,
    pais_destino   NVARCHAR(30) NOT NULL
);
GO

CREATE TABLE dbo.servicio
(
    id_servicio      INT           PRIMARY KEY IDENTITY(1,1) NOT NULL,
    servicio         NVARCHAR(75)  NOT NULL,
    compania         NVARCHAR(100) NOT NULL,
    es_servadicional BIT           DEFAULT 0 NOT NULL
);
GO

CREATE TABLE dbo.viaje
(
    id_viaje      INT  PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_pasajero   INT  NOT NULL,
    id_ticket     INT  NOT NULL,
    fecha_salida  DATE DEFAULT getdate() NOT NULL,
    fecha_regreso DATE,
    CONSTRAINT viaje_pasajero_fk FOREIGN KEY ( id_pasajero)
    REFERENCES dbo.pasajero ( id_pasajero ),
    CONSTRAINT viaje_ticket_fk FOREIGN KEY ( id_ticket )
    REFERENCES dbo.ticket ( id_ticket )
);
GO

CREATE TABLE dbo.detalle_viaje
(
    id_viaje          INT     NOT NULL,
    id_servicio       INT     NOT NULL,
    valor_servicio    NUMERIC DEFAULT 0 NOT NULL,
    interes_servicio  NUMERIC DEFAULT 0 NOT NULL,
    comision_servicio NUMERIC DEFAULT 0 NOT NULL,
    CONSTRAINT detalle_viaje_pk PRIMARY KEY ( id_viaje, id_servicio ),
    CONSTRAINT detalleviaje_viaje_fk FOREIGN KEY ( id_viaje )
    REFERENCES dbo.viaje ( id_viaje ),
    CONSTRAINT detalleviaje_servicio_fk FOREIGN KEY ( id_servicio )
    REFERENCES dbo.servicio ( id_servicio )
);
GO




-- Insercion de datos.
PRINT 'Insertando pasajeros.'
INSERT INTO dbo.pasajero
    ([nombre], [genero], [nacionalidad], [rango_edad])
VALUES
    ('Sacarias Conchitas Del Rio', 'Masculino', 'Chilena', '40-50'),
    ('Aquiles Baeza Parada', 'Masculino', 'Sudafricano', '30-40'),
    ('Debora Melo Parada', 'Femenino', 'Peruana', '40-50'),
    ('Elba Zurita', 'Femenino', 'Chilena', '20-30'),
    ('Susana Orias Rojas', 'Femenino', 'Chilena', '50-60'),
    ('Elba Lazo', 'Femenino', 'Chilena', '30-40'),
    ('Ana Lisa Melano', 'Femenino', 'Argentina', '20-30'),
    ('Zoila Cerda Del Rio', 'Femenino', 'Peruana', '50-60'),
    ('Pato Carlos Bustos De La Vaca', 'Masculino', 'Colombiana', '20-30'),
    ('Daniel Garcia Asathor', 'Masculino', 'Chilena', '40-50');
GO

PRINT 'Insertando ticket';
INSERT INTO dbo.ticket
    ([ciudad_origen], [pais_origen], [ciudad_destino], [pais_destino])
VALUES
    ('Santiago', 'Chile', 'Madrid', 'España'),
    ('Santiago', 'Chile', 'Londres', 'Reino Unido'),
    ('Santiago', 'Chile', 'New York', 'Estados Unidos'),
    ('Santiago', 'Chile', 'Lima', 'Peru'),
    ('Santiago', 'Chile', 'Valdivia', 'Chile');
GO

PRINT 'Insertando servicios';
INSERT INTO dbo.servicio
    ([servicio],[compania], [es_servadicional])
VALUES
    ('Pasaje aereo', 'Latan', 0),
    ('Pasaje aereo', 'Sky', 0),
    ('Pasaje Terrestre', 'Transportes P', 0),
    ('Pasajes nauticos', 'Navios  El torero Cornado', 0),
    ('Pasajes nauticos', 'Jack The Ripper Navi', 0),
    ('Pasajes nauticos', 'Barcazas El Gringito', 0),
    ('Pasajes nauticos', 'Lanchas Calle Calle', 0),
    ('hoteleria', 'Hotel El Tomatazo', 1),
    ('Hoteleria', 'The Ripper Queen Hotel', 1),
    ('hoteleria', 'Hotel Las Torres Caidas', 1),
    ('Hoteleria', 'Hostal El P Solitario', 1),
    ('Hotel', 'Hotel Valdivia', 1),
    ('Traslados', 'Autos El Tomatazo', 1),
    ('Traslados', 'God Save The Queen Cars', 1),
    ('Traslados', 'The Alone Citycars', 1),
    ('Traslados', 'El peruanillo traslados', 1),
    ('Traslados', 'Transportes Cau Cau', 1),
    ('Tour', 'Turismo Ooooooleeeeee', 1),
    ('Tour', 'Alan Turin Tours', 1),
    ('Tour', 'Airplane in flames tourism', 1),
    ('Tour', 'Turismo Los Rios', 1),
    ('Seguro', 'Seguro anti cornazo de toro y anti tomatazos', 1),
    ('Seguro', 'Seguro anti destripamiento', 1),
    ('Seguro', 'Seguro anti derrumbe de edificios producto de avbiones locos', 1),
    ('Seguro', 'Seguro toxicologico por cerveza', 1),
    ('Otros servicios', 'Cerveceria Kustmann - La ruta de Kunstmann', 1),
    ('Otros servicios', 'Transportes, Traslado reserva Huilo Huilo', 1)
GO

PRINT 'Insertando viajes';
INSERT INTO dbo.viaje
    ([id_pasajero], [id_ticket], [fecha_salida], [fecha_regreso])
VALUES
    (1, 1, '2019-09-01', '2019-09-29'),
    (2, 3, '2019-09-03', '2019-09-25'),
    (3, 4, '2019-10-01', '2019-10-15'),
    (4, 1, '2019-09-01', '2019-09-29'),
    (5, 2, '2019-10-05', '2019-09-25'),
    (6, 3, '2019-09-13', '2019-09-22'),
    (7, 2, '2019-09-13', '2019-09-22'),
    (8, 4, '2019-11-07', '2019-11-13'),
    (9, 2, '2019-10-05', '2019-09-25'),
    (10, 5, '2019-09-13', '2019-09-22');
GO

PRINT 'Asignando servicios a los viajes';
INSERT INTO dbo.detalle_viaje
    ([id_viaje], [id_servicio], [valor_servicio], [interes_servicio], [comision_servicio])
VALUES
    (1, 1, 340000, 34000, 15000),
    (1, 4, 100000, 10000, 8500),
    (1, 8, 250000, 25000, 15000),
    (1, 13, 15000, 2500, 2000),
    (1, 18, 230000, 23000, 5000),
    (1, 22, 20000, 2800, 2000),
    (2, 1, 420000, 42000, 4200),
    (2, 10, 150000, 15000, 1500),
    (2, 15, 40000, 4000, 400),
    (3, 2, 100000, 50000, 20000),
    (3, 11, 150000, 100000, 50000),
    (3, 16, 30000, 3000, 5000),
    (4, 1, 340000, 34000, 15000),
    (4, 4, 100000, 10000, 8500),
    (4, 8, 250000, 25000, 15000),
    (4, 13, 15000, 2500, 2000),
    (4, 18, 230000, 23000, 5000),
    (4, 22, 20000, 2800, 2000),
    (5, 1, 250000, 25000, 2500),
    (5, 9, 50000, 5000, 500),
    (6, 1, 350000, 35000, 3500),
    (6, 10, 65000, 6500, 650),
    (6, 15, 15000, 1500, 150),
    (7, 1, 320000, 32000, 3200),
    (7, 9, 50000, 5000, 500),
    (7, 14, 15000, 1500, 150),
    (7, 19, 170000, 17000, 1700),
    (8, 2, 150000, 15000, 150),
    (9, 1, 250000, 25000, 2500),
    (9, 9, 50000, 5000, 500),
    (10, 1, 95000, 9500, 950),
    (10, 7, 5000, 500, 50),
    (10, 12, 100000, 10000, 1000),
    (10, 17, 2000, 200, 20),
    (10, 21, 50000, 5000, 500),
    (10, 25, 10000, 1000, 100),
    (10, 26, 10000, 1000, 100),
    (10, 27, 80000, 8000, 800);
GO


-- Creando la vista para unir los registros para la tabla de hechos.
EXEC dbo.sp_executesql @statement = N'
CREATE OR ALTER VIEW [dbo].[viewPrecio_servicio]
AS
SELECT        
dbo.viaje.id_viaje, 
dbo.viaje.id_pasajero, 
dbo.viaje.id_ticket, 
dbo.detalle_viaje.id_servicio, 
dbo.detalle_viaje.valor_servicio, 
dbo.detalle_viaje.interes_servicio, 
dbo.detalle_viaje.comision_servicio, 
(dbo.detalle_viaje.valor_servicio + 
dbo.detalle_viaje.interes_servicio + 
dbo.detalle_viaje.comision_servicio) AS total_servicio
FROM dbo.viaje INNER JOIN 
dbo.detalle_viaje 
ON dbo.viaje.id_viaje = dbo.detalle_viaje.id_viaje
' 
GO




