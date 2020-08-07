-- pasos iniciales para crear base de datos.
SET NOCOUNT ON;
GO
USE master;
GO

-- creando la base de datos.
DROP DATABASE IF EXISTS dwPatiperros;
GO
CREATE DATABASE dwPatiperros
ON PRIMARY 
(name='dwPatiperros_data', filename='/var/opt/mssql/data/dwPatiperros_data.mdf', size=5Mb, maxsize=500Mb, filegrowth=5Mb)
log ON 
(name='dwPatiperros_logs', filename='/var/opt/mssql/data/dwPatiperros_logs.ldf', size=10Mb, maxsize=20Mb, filegrowth=1Mb)
GO
USE dwPatiperros;
GO




-- Creacion de tablas de la base de datos...
CREATE TABLE dbo.dim_pasajero
(
    id_pasajero  INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre       NVARCHAR(50),
    genero       NVARCHAR(15),
    nacionalidad NVARCHAR(25),
    rango_edad   NVARCHAR(7)
);
GO

CREATE TABLE dbo.dim_ticket
(
    id_ticket      INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    ciudad_origen  NVARCHAR(50),
    pais_origen    NVARCHAR(30),
    ciudad_destino NVARCHAR(50),
    pais_destino   NVARCHAR(30)
);
GO

CREATE TABLE dbo.dim_servicio
(
    id_servicio      INT           PRIMARY KEY IDENTITY(1,1) NOT NULL,
    servicio         NVARCHAR(75),
    compania         NVARCHAR(100),
    es_servadicional BIT
);
GO

CREATE TABLE dbo.dim_fecha
(
    id_fecha       INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    fecha_salida   DATE,
    dia_salida     TINYINT      DEFAULT 0,
    nomdia_salida  NVARCHAR(10),
    mes_salida     TINYINT      DEFAULT 0,
    nommes_salida  NVARCHAR(15),
    semana_salida  TINYINT      DEFAULT 0,
    anio_salida    SMALLINT     DEFAULT 0,
    fecha_regreso  DATE,
    dia_regreso    TINYINT      DEFAULT 0,
    nomdia_regreso NVARCHAR(10),
    mes_regreso    TINYINT      DEFAULT 0,
    nommes_regreso NVARCHAR(15),
    semana_regreso TINYINT      DEFAULT 0,
    anio_regreso   SMALLINT     DEFAULT 0
);
GO

CREATE TABLE dbo.dim_precio
(
    id_precio         INT     PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_viaje          INT     NOT NULL,
    id_servicio       INT     NOT NULL,
    valor_servicio    NUMERIC DEFAULT 0 ,
    interes_servicio  NUMERIC DEFAULT 0 ,
    comision_servicio NUMERIC DEFAULT 0
);
GO


CREATE TABLE dbo.hechos_viaje
(
    id_viaje       INT   NOT NULL,
    id_servicio    INT   NOT NULL,
    id_precio      INT   NOT NULL,
    id_pasajero    INT   NOT NULL,
    id_ticket      INT   NOT NULL,
    id_fecha       INT   NOT NULL,
    total_servicio MONEY DEFAULT 0,
    CONSTRAINT hechos_pasajero_fk FOREIGN KEY ( id_pasajero )
    REFERENCES dbo.dim_pasajero ( id_pasajero ),
    CONSTRAINT hechos_ticket_fk FOREIGN KEY ( id_ticket )
    REFERENCES dbo.dim_ticket ( id_ticket ),
    CONSTRAINT hechos_servicio_fk FOREIGN KEY ( id_servicio )
    REFERENCES dbo.dim_servicio ( id_servicio ),
    CONSTRAINT hechos_precio_fk FOREIGN KEY ( id_precio )
    REFERENCES dbo.dim_precio (id_precio ),
    CONSTRAINT hechos_fecha_fk FOREIGN KEY ( id_fecha )
    REFERENCES dbo.dim_fecha ( id_fecha )
);
GO 

