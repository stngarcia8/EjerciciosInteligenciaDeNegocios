-- Preparando todo antes de crear la base de datos.
SET NOCOUNT ON;                
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Iniciando script.';
GO                             
USE master;                    
GO                             
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Cambiando a ' + db_name();
GO                                              
-- Creando la base de datos y sus elementos.
DROP DATABASE IF EXISTS DWVentasCelular 
GO                                     
CREATE DATABASE dwVentasCelular   
GO                               
USE dwVentasCelular;             
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Cambiando a ' + db_name();
GO                              
CREATE TRIGGER trgDBMonitor ON DATABASE 
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE  
  AS                          
BEGIN                
    SET NOCOUNT ON;  
    DECLARE @InfoEvento XML,@Accion VARCHAR(500),@Objeto VARCHAR(500);
    SET @InfoEvento = EVENTDATA();
    SET @Accion = @InfoEvento.value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(500)');
    SET @Objeto = @InfoEvento.value('(/EVENT_INSTANCE/SchemaName)[1]', 'varchar(250)') 
                   +'.'
                   +@InfoEvento.value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(250)');
    PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + @accion + ' ' + @Objeto + '.';
END;
GO


-- Creando las tablas del modelo dimensional.
CREATE TABLE dbo.dimCliente
(
    ID_CLIENTE          BIGINT       NOT NULL,
    NOMBRE_CLIENTE      VARCHAR(100) NOT NULL,
    FECNAC_CLIENTE      DATETIME,
    SEXO                VARCHAR(15),
    TIPO_CLIENTE        VARCHAR(60),
    NOMBRE_EMPRESA      VARCHAR(50),
    RAZONSOCIAL_EMPRESA VARCHAR(100),
    CONSTRAINT dimCliente_PK PRIMARY KEY ( ID_CLIENTE )
) 
GO

CREATE TABLE dbo.dimEmpleado
(
    ID_EMPLEADO     INT         NOT NULL,
    NOMBRE_EMPLEADO VARCHAR(20) NOT NULL,
    FEC_INGRESO     DATETIME,
    CONSTRAINT empleado_PK PRIMARY KEY (ID_EMPLEADO)
)
GO

CREATE TABLE dbo.dimSucursal
(
    ID_SUCURSAL      INT         NOT NULL,
    SUCURSAL         VARCHAR(50),
    NOMBRE_COMUNA    VARCHAR(40),
    NOMBRE_PROVINCIA VARCHAR(30),
    numero_region    INT,
    NOMBRE_REGION    VARCHAR(75),
    capital_region   VARCHAR(50),
    CONSTRAINT sucursal_pk PRIMARY KEY ( ID_SUCURSAL )
)
GO

CREATE TABLE dbo.dimContrato
(
    ID_CONTRATO                 BIGINT       NOT NULL,
    FOLIO_CONTRATO              VARCHAR(20),
    FEC_CONTRATO                INT          DEFAULT 0 NOT NULL,
    NOMBRE_PLAN                 VARCHAR(20)  NOT NULL,
    COSTO_PLAN                  BIGINT       DEFAULT 0 NOT NULL,
    PLANES_VENDIDOS_A_LA_FECHA  INT          DEFAULT 0 NOT NULL,
    NRO_CELULAR                 VARCHAR(15)  NOT NULL,
    fecha_activacion            INT          DEFAULT 0,
    MODELO                      VARCHAR(100) NOT NULL,
    MARCA                       VARCHAR(100) NOT NULL,
    MODELOS_VENDIDOS_A_LA_FECHA INT          DEFAULT 0 NOT NULL,
    CONSTRAINT contrato_pk PRIMARY KEY (ID_CONTRATO)
) 
GO

CREATE TABLE dbo.dimDocumento
(
    ID_DOCUMENTO     BIGINT       NOT NULL,
    FOLIO_DOCUMENTO  VARCHAR(20)  NOT NULL,
    TIPO_DOCUMENTO   VARCHAR(60)  NOT NULL,
    FEC_EMITIDO      INT          DEFAULT 0,
    MONTO_DOCUMENTO  BIGINT       DEFAULT 0 NOT NULL,
    ESTADO_DOCUMENTO VARCHAR(100) NOT NULL,
    FEC_pago         INT          DEFAULT 0,
    CONSTRAINT documento_pk PRIMARY KEY (ID_DOCUMENTO)
)
GO

CREATE TABLE dbo.dimTiempo
(
    ID_FECHA     INT         NOT NULL,
    FECHA        DATE        NOT NULL,
    DIA          INT         NOT NULL,
    NOMBRE_DIA   VARCHAR(15) NOT NULL,
    DIA_ANIO     INT         NOT NULL,
    Mes          INT         NOT NULL,
    NOMBRE_MES   VARCHAR(10) NOT NULL,
    DIAS_DEL_MES INT         NOT NULL,
    INICIO_MES   VARCHAR(15) NOT NULL,
    TERMINO_MES  VARCHAR(15) NOT NULL,
    ANIO         INT         NOT NULL,
    SEMANA       INT         NOT NULL,
    TRIMESTRE    INT         NOT NULL,
    SEMESTRE     INT         NOT NULL,
    CONSTRAINT fecha_pk PRIMARY KEY (ID_FECHA)
)
GO

CREATE TABLE dbo.factVenta
(
    ID_FECHA                          INT    NOT NULL,
    ID_EMPLEADO                       INT    NOT NULL,
    ID_SUCURSAL                       INT    NOT NULL,
    ID_CLIENTE                        BIGINT NOT NULL,
    ID_CONTRATO                       BIGINT NOT NULL,
    ID_DOCUMENTO                      BIGINT NOT NULL,
    MONTO_VENTA                       BIGINT DEFAULT 0,
    DOC_PAGADO                        BIT    DEFAULT 0 NOT NULL,
    DOC_VENCIDO                       BIT    DEFAULT 0 NOT NULL,
    DOC_PENDIENTE                     BIT    DEFAULT 0 NOT NULL,
    ES_BOLETA                         BIT    DEFAULT 0 NOT NULL,
    ES_FACTURA                        BIT    DEFAULT 0 NOT NULL,
    MONTO_PAGADO                      BIGINT DEFAULT 0 NOT NULL,
    CLIENTE_COORPORATIVO              BIT    DEFAULT 0 NOT NULL,
    CLIENTE_NUEVO                     BIT    DEFAULT 0 NOT NULL,
    CANTIDAD_COMPRAS_ANTERIORES       INT    DEFAULT 0 NOT NULL,
    CANTIDAD_DISPOSITIVOS_CONTRATADOS INT    DEFAULT 0 NOT NULL,
    CONSTRAINT factVenta_fecha_fk FOREIGN KEY (ID_FECHA)
    REFERENCES dbo.dimTiempo (ID_FECHA),
    CONSTRAINT factVenta_empleado_fk FOREIGN KEY (ID_EMPLEADO)
    REFERENCES dbo.dimEmpleado (ID_EMPLEADO),
    CONSTRAINT factVenta_sucursal_fk FOREIGN KEY (ID_SUCURSAL)
    REFERENCES dbo.dimSucursal (ID_SUCURSAL),
    CONSTRAINT factVenta_cliente_fk FOREIGN KEY (ID_CLIENTE)
    REFERENCES dbo.dimCliente (ID_CLIENTE),
    CONSTRAINT factVenta_contrato_fk FOREIGN KEY ( ID_CONTRATO)
    REFERENCES dbo.dimContrato (ID_COnTRATO),
    CONSTRAINT factVenta_documento_fk FOREIGN KEY (ID_DOCUMENTO)
    REFERENCES dbo.dimDocumento (ID_DOCUMENTO)
)
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Generando fechas.';
WITH
    Dates
    AS

    (
                    SELECT
                [Date] = CONVERT(DATETIME,'01/01/2004')
        UNION ALL
            SELECT
                [Date] = DATEADD(DAY, 1, [Date])
            FROM
                Dates
            WHERE
         Date < '01/01/2020'
    )
INSERT INTO dbo.dimTiempo
SELECT
    CONVERT(INT, [Date]) AS  ID_FECHA,
    CONVERT(DATE, [Date]) AS FECHA,
    datepart(DAY, [Date]) AS DIA,
    CASE
    WHEN datepart(dw, [Date])=1 THEN 'Lunes'
    WHEN datepart(dw, [Date])=2 THEN 'Martes'
    WHEN datepart(dw, [Date])=3 THEN 'Miercoles'
    WHEN datepart(dw, [Date])=4 THEN 'Jueves'
    WHEN datepart(dw, [Date])=5 THEN 'Viernes'
    WHEN datepart(dw, [Date])=6 THEN 'Sabado'
    ELSE 'Domingo'
    END AS NOMBRE_DIA,
    datepart(dayofyear, [Date]) AS DIA_ANIO,
    month([Date]) AS MES,
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
END AS NOMBRE_MES,
    datepart(day, dateadd(day, -1, dateadd(month, 1, DATEADD(MONTH, DATEDIFF(MONTH, 0,[Date]), 0)))) AS DIAS_DEL_MES,
    CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0,[Date]), 0)) AS INICIO_MES,
    CONVERT(DATE, dateadd(day, -1, dateadd(month, 1, DATEADD(MONTH, DATEDIFF(MONTH, 0,[Date]), 0)))) AS TERMINO_MES,
    datepart(year, [Date]) AS ANIO,
    datepart(week, [Date]) AS SEMANA,
    datepart(qq, [Date]) AS TRIMESTRE,
    CONVERT(INT,(datepart(month, [Date])/7)+1) AS SEMESTRE
FROM
    Dates
OPTION
(MAXRECURSION
20000)





PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Finalizando script.';


    