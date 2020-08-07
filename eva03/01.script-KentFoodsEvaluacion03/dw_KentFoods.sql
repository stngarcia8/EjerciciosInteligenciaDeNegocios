/*
    Script:         dwKentFoods.sql
    Profesor:       Cristian Salazar.
    Ramo:           Inteligencia de negocios.
    Alumnos:        Daniel García.
    Fecha:          02/12/2019
    Descripción:    Script que crea la base de datos con el modelo multidimensional requerido.
*/

SET NOCOUNT ON;
PRINT FORMAT(getdate(),          'dd/MM/yyyy HH:mm') + ' Iniciando script.';
USE [master];
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a ' + db_name() + '.'; 
GO

/*
    Creando base de datos.
    La base de datos es generada de forma simple y que sql server
    tome los valores de referencia por defecto, esto es debido a que
    trabajo con contenedores (docker) y si pasamos esto tal cual colocando los
    atributos file_name and file_path, estas son rutas linux, por lo cual,
    no funcionarán al momento de ejecutar el script en windows.
    La versión utilizada del motor de sql server es la 2019 developer edition
    No existe la versión 2012 para utilizarla con contenedores.
*/
IF EXISTS (
    SELECT
    [name]
FROM
    sys.databases
WHERE [name] = 'dwKentFoods')
    BEGIN
    PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Eliminando la base de datos dwKentFoods.';
    DROP DATABASE dwKentFoods;
END;
GO
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Creando la base de datos dwKentFoods.';
GO
CREATE DATABASE [DWKentFoods];
 GO
USE [DWKentFoods];
GO
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a ' + db_name() + '.';
GO

-- Creando tablas del modelo estrella.
PRINT '';
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Creando la dimension empleado.';
GO
CREATE TABLE dim_empleado
(
    EmpleadoID     INT            NOT NULL,
    Apellido       NVARCHAR(20)   NOT NULL,
    Nombre         NVARCHAR(10)   NOT NULL,
    NombreCompleto NVARCHAR(50)   NOT NULL,
    Cargo          NVARCHAR(30),
    Direccion      NVARCHAR(60),
    Ciudad         NVARCHAR(15),
    Pais           NVARCHAR(15),
    Territorio     NVARCHAR(1000),
    Region         NVARCHAR(500),
    CreationDate   DATETIME       DEFAULT getdate() NOT NULL,
    UpdateDate     DATETIME,
    CONSTRAINT pk_dimempleado PRIMARY KEY (EmpleadoID ASC)
);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Creando la dimension producto.';
GO
CREATE TABLE dbo.dim_producto
(
    ProductoID        INT          NOT NULL,
    Producto          NVARCHAR(40) NOT NULL,
    Categoria         NVARCHAR(15) NOT NULL,
    CantidadPorUnidad NVARCHAR(20),
    PrecioUnitario    MONEY        DEFAULT 0,
    CreationDate      DATETIME     DEFAULT getdate() NOT NULL,
    UpdateDate        DATETIME,
    CONSTRAINT pk_producto PRIMARY KEY (ProductoID ASC)
);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Creando la dimension transportista.';
GO
CREATE TABLE dbo.dim_transportista
(
    TransportistaID INT          NOT NULL,
    Transportista   NVARCHAR(40) NOT NULL,
    Telefono        NVARCHAR(24),
    CreationDate    DATETIME     DEFAULT getdate() NOT NULL,
    UpdateDate      DATETIME,
    CONSTRAINT transportista_pk PRIMARY KEY CLUSTERED (TransportistaID ASC)
);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Creando la dimension cliente.';
GO
CREATE TABLE dbo.dim_cliente
(
    ClienteID    NCHAR(5)     NOT NULL,
    Empresa      NVARCHAR(40) NOT NULL,
    Contacto     NVARCHAR(30),
    Cargo        NVARCHAR(30),
    Direccion    NVARCHAR(60),
    Ciudad       NVARCHAR(15),
    CodigoPostal NVARCHAR(10),
    Pais         NVARCHAR(15),
    Telefono     NVARCHAR(24),
    CreationDate DATETIME     DEFAULT getdate() NOT NULL,
    UpdateDate   DATETIME,
    CONSTRAINT cliente_pk PRIMARY KEY CLUSTERED (ClienteID ASC)
);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Creando la dimension tiempo.';
GO
CREATE TABLE dbo.dim_tiempo
(
    FechaID      INT         NOT NULL,
    Fecha        DATE        NOT NULL,
    Dia          INT         NOT NULL,
    NombreDia    VARCHAR(15) NOT NULL,
    DiaDelAnio   INT         NOT NULL,
    Mes          INT         NOT NULL,
    NombreMes    VARCHAR(10) NOT NULL,
    DiasDelMes   INT         NOT NULL,
    ANIO         INT         NOT NULL,
    SEMANA       INT         NOT NULL,
    TRIMESTRE    INT         NOT NULL,
    SEMESTRE     INT         NOT NULL,
    CreationDate DATETIME    DEFAULT getdate() NOT NULL,
    UpdateDate   DATETIME,
    CONSTRAINT fecha_pk PRIMARY KEY (FechaID)
)
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Creando la tabla de hechos.';
GO
CREATE TABLE fact_orden
(
    FechaID            INT          NOT NULL,
    ClienteID          NCHAR(5)     NOT NULL,
    ProductoID         INT          NOT NULL,
    EmpleadoID         INT          NOT NULL,
    TransportistaID    INT          NOT NULL,
    FechaOrden         INT          NULL,
    FechaEnvio         INT          NULL,
    CiudadEnvio        NVARCHAR(15),
    PaisEnvio          NVARCHAR(15) ,
    CodigoPostal_envio NVARCHAR(10),
    PrecioUnitario     BIGINT       DEFAULT 0 NOT NULL,
    Cantidad           INT          DEFAULT 0 NOT NULL,
    PrecioVenta        BIGINT       DEFAULT 0 NOT NULL,
    Descuento          REAL         DEFAULT 0 NOT NULL,
    ValorDescuento     BIGINT       DEFAULT 0 NOT NULL,
    TotalVenta         BIGINT       DEFAULT 0 NOT NULL,
    TieneDescuento     BIT          DEFAULT 0 NOT NULL,
    CreationDate       DATETIME     DEFAULT getdate() NOT NULL,
    UpdateDate         DATETIME,
    CONSTRAINT fk_factOrden_tiempo FOREIGN KEY (FechaID) 
    REFERENCES dbo.dim_tiempo (FechaID),
    CONSTRAINT fk_factOrden_cliente FOREIGN KEY (ClienteID) 
    REFERENCES dbo.dim_cliente (ClienteID),
    CONSTRAINT fk_factOrden_producto FOREIGN KEY (ProductoID) 
    REFERENCES dbo.dim_producto (ProductoID),
    CONSTRAINT fk_factOrden_empleado FOREIGN KEY (EmpleadoID) 
    REFERENCES dbo.dim_empleado (EmpleadoID),
    CONSTRAINT fk_factOrden_transportista FOREIGN KEY (TransportistaID) 
    REFERENCES dbo.dim_transportista (TransportistaID),
);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Generando fechas.';
GO
WITH
    Dates
    AS
    (
                    SELECT
                [Date] = CONVERT(DATETIME,'01/01/1995')
        UNION ALL
            SELECT
                [Date] = DATEADD(DAY, 1, [Date])
            FROM
                Dates
            WHERE
         Date < '01/01/2000'
    )
INSERT INTO dbo.dim_tiempo
    ([FechaID], [Fecha], [Dia], [NombreDia], [DiaDelAnio], [Mes], [NombreMes], [DiasDelMes], [ANIO], [SEMANA], [TRIMESTRE], [SEMESTRE])
SELECT
    CONVERT(INT, [Date]) AS  FechaID,
    CONVERT(DATE, [Date]) AS Fecha,
    datepart(DAY, [Date]) AS Dia,
    CASE
    WHEN datepart(dw, [Date])=1 THEN 'Lunes'
    WHEN datepart(dw, [Date])=2 THEN 'Martes'
    WHEN datepart(dw, [Date])=3 THEN 'Miercoles'
    WHEN datepart(dw, [Date])=4 THEN 'Jueves'
    WHEN datepart(dw, [Date])=5 THEN 'Viernes'
    WHEN datepart(dw, [Date])=6 THEN 'Sabado'
    ELSE 'Domingo'
    END AS NombreDia,
    datepart(dayofyear, [Date]) AS DiaDelAnio,
    month([Date]) AS Mes,
    CASE  
    WHEN datepart(month, [Date])=1 THEN 'Enero'
    WHEN datepart(month, [Date])=2 THEN 'Febrero'
    WHEN datepart(month, [Date])=3 THEN 'marzo'
    WHEN datepart(month, [Date])=4 THEN 'Abril'
    WHEN datepart(month, [Date])=5 THEN 'Mayo'
    WHEN datepart(month, [Date])=6 THEN 'Junio'
    WHEN datepart(month, [Date])=7 THEN 'Julio'
    WHEN datepart(month, [Date])=8 THEN 'Agosto'
    WHEN datepart(month, [Date])=9 THEN 'Septiembre'
    WHEN datepart(month, [Date])=10 THEN 'octubre'
    WHEN datepart(month, [Date])=11 THEN 'Noviembre'
WHEN datepart(month, [Date])=12 THEN 'Diciembre'
    ELSE ''
END AS NombreMes,
    datepart(day, dateadd(day, -1, dateadd(month, 1, DATEADD(MONTH, DATEDIFF(MONTH, 0,[Date]), 0)))) AS DiasDelMes,
    datepart(year, [Date]) AS ANIO,
    datepart(week, [Date]) AS SEMANA,
    datepart(qq, [Date]) AS TRIMESTRE,
    CONVERT(INT,(datepart(month, [Date])/7)+1) AS SEMESTRE
FROM
    Dates
OPTION
(MAXRECURSION
20000)

PRINT '';
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Finalizando script.';
GO 