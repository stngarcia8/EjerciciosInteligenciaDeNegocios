/*
DBMS: Microsoft sqlServer2017, developer edition.
Database: relVentasEmy
*/
USE master;
GO
SET NOCOUNT ON;
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a ' + db_name() + '.';
GO

/*
Objeto: trgMonitorizaBaseDeDatos
Descripcion: Monitoriza las actividades que se producen 
en el servidor, con respecto a las bases de datos de este, 
las actividades a monitorizar son:
- create_database
- drop_database
*/
CREATE OR ALTER TRIGGER trgMonitorizaBaseDeDatos   
ON ALL SERVER   
FOR CREATE_DATABASE, drop_database    
AS   
BEGIN
    SET NOCOUNT ON;
    DECLARE @InfoEvento XML, @Objeto NVARCHAR(max);
    SET @InfoEvento = EVENTDATA();
    SET @Objeto = @InfoEvento.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'varchar(500)');
    PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + @Objeto + '.';
END;
GO



/*
Crear base de datos.
Descripcion: Elimina (drop) la base de datos para posteriormente
crearla en el servidor, la finalidad es que necesito que todos 
los objetos de la base sean eliminados del servidor y que luego
se vuelvan a crear limpiamente.
Es obvio que esto no debe ser realizado en producción.
*/
DROP DATABASE IF EXISTS relVentasEmy
GO
CREATE DATABASE relVentasEmy
GO
USE relVentasEmy;
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a ' + db_name() + '.';
GO

/*
Objeto: trgDBMonitor
Descripcion: Trigger para monitorizar los cambios realizados en la
base de datos, esto lo hago para posteriormente analizar que pasa y poder
almacenar los logs si es que lo requiero para hacer pruebas.
En producción no se utiliza.
*/
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



/*
Creando las tablas de la base de datos.
*/
CREATE TABLE dbo.comuna
(
    ID_COMUNA     INT          NOT NULL,
    NOMBRE_COMUNA VARCHAR(40)  NOT NULL,
    DESC_COMUNA   VARCHAR(100) NOT NULL,
    CONSTRAINT comuna_PK PRIMARY KEY (ID_COMUNA)
)
GO

CREATE TABLE dbo.empresa
(
    ID_EMPRESA     INT          NOT NULL,
    NOMBRE_EMPRESA VARCHAR(50)  NOT NULL,
    DESC_EMPRESA   VARCHAR(100) NOT NULL,
    CONSTRAINT empresa_PK PRIMARY KEY (ID_EMPRESA)
)
GO

CREATE TABLE dbo.estado_documento
(
    ID_ESTADO   TINYINT      NOT NULL,
    DESC_ESTADO VARCHAR(100) NOT NULL,
    CONSTRAINT estado_documento_PK PRIMARY KEY (ID_ESTADO)
)
GO

CREATE TABLE dbo.marca_celular
(
    ID_MARCACEL INT          NOT NULL,
    DESC_MARCA  VARCHAR(100) NOT NULL,
    CONSTRAINT marca_celular_PK PRIMARY KEY (ID_MARCACEL)
)
GO

CREATE TABLE dbo.metodo_pago
(
    ID_METODO   TINYINT     NOT NULL,
    DESC_METODO VARCHAR(30) NOT NULL,
    CONSTRAINT metodo_pago_PK PRIMARY KEY (ID_METODO)
)
GO

CREATE TABLE dbo.modelo_celular
(
    ID_MODELOCEL   INT          NOT NULL,
    DESC_MODELOCEL VARCHAR(100) NOT NULL,
    CONSTRAINT modelo_celular_PK PRIMARY KEY (ID_MODELOCEL)
)
GO

CREATE TABLE dbo."plan"
(
    ID_PLAN     INT            NOT NULL,
    NOMBRE_PLAN VARCHAR(20)    NOT NULL,
    COSTO_PLAN  NUMERIC(12,12) NOT NULL,
    DESC_PLAN   VARCHAR(100)   NOT NULL,
    CONSTRAINT plan_PK PRIMARY KEY (ID_PLAN)
)
GO

CREATE TABLE dbo.region
(
    ID_REGION     TINYINT      NOT NULL,
    NOMBRE_REGION VARCHAR(40)  NOT NULL,
    DESC_REGION   VARCHAR(100) NOT NULL,
    CONSTRAINT region_PK PRIMARY KEY (ID_REGION)
)
GO

CREATE TABLE dbo.sucursal
(
    ID_SUCURSAL   INT          NOT NULL,
    ID_COMUNA     INT          NOT NULL,
    ID_REGION     TINYINT      NOT NULL,
    DESC_SUCURSAL VARCHAR(200) NOT NULL,
    CONSTRAINT sucursal_PK PRIMARY KEY (ID_SUCURSAL),
    CONSTRAINT sucursal_comuna_FK FOREIGN KEY (ID_COMUNA)
    REFERENCES dbo.comuna (ID_COMUNA),
    CONSTRAINT sucursal_region_FK FOREIGN KEY (ID_REGION)
    REFERENCES dbo.region (ID_REGION)
)
GO

CREATE TABLE dbo.tipo_cliente
(
    ID_TIPOCLI   TINYINT     NOT NULL,
    DESC_TIPOCLI VARCHAR(60) NOT NULL,
    CONSTRAINT tipo_cliente_PK PRIMARY KEY (ID_TIPOCLI)
)
GO

CREATE TABLE dbo.celular
(
    ID_CELULAR   BIGINT       NOT NULL,
    ID_MARCACEL  INT          NOT NULL,
    ID_MODELOCEL INT          NOT NULL,
    NRO_CELULAR  NUMERIC(8,8) NOT NULL,
    DESC_CELULAR VARCHAR(100) NOT NULL,
    CONSTRAINT celular_PK PRIMARY KEY (ID_CELULAR),
    CONSTRAINT celular_marca_FK FOREIGN KEY (ID_MARCACEL)
    REFERENCES dbo.marca_celular (ID_MARCACEL),
    CONSTRAINT celular_modelo_FK FOREIGN KEY (ID_MODELOCEL)
    REFERENCES dbo.modelo_celular (ID_MODELOCEL)
)
GO

CREATE TABLE dbo.cliente
(
    ID_CLIENTE       BIGINT      NOT NULL,
    ID_EMPRESA       INT         NOT NULL,
    ID_TIPOCLI       TINYINT     NOT NULL,
    NOMBRE_CLIENTE   VARCHAR(20) NOT NULL,
    APATERNO_CLIENTE VARCHAR(25) NOT NULL,
    AMATERNO_CLIENTE VARCHAR(25) NOT NULL,
    FECNAC_CLIENTE   DATETIME    NOT NULL,
    SEXO_CLIENTE     VARCHAR(15) NOT NULL,
    CONSTRAINT cliente_PK PRIMARY KEY (ID_CLIENTE),
    CONSTRAINT cliente_empresa_FK FOREIGN KEY (ID_EMPRESA)
    REFERENCES dbo.empresa (ID_EMPRESA),
    CONSTRAINT cliente_tipocliente_FK FOREIGN KEY (ID_TIPOCLI)
    REFERENCES dbo.tipo_cliente (ID_TIPOCLI)
)
GO

CREATE TABLE dbo.empleado
(
    ID_EMPLEADO     INT         NOT NULL,
    ID_SUCURSAL     INT         NOT NULL,
    NOMBRE_EMPLEADO VARCHAR(20) NOT NULL,
    FEC_INGRESOEMP  DATETIME    NOT NULL,
    CONSTRAINT empleado_PK PRIMARY KEY (ID_EMPLEADO),
    CONSTRAINT empleado_sucursal_FK FOREIGN KEY (ID_SUCURSAL)
    REFERENCES dbo.sucursal (ID_SUCURSAL)
)
GO

CREATE TABLE dbo.venta
(
    ID_VENTA    BIGINT       NOT NULL,
    ID_EMPLEADO INT          NOT NULL,
    DESC_VENTA  VARCHAR(100) NOT NULL,
    FEC_VENTA   DATETIME     NOT NULL,
    CONSTRAINT venta_PK PRIMARY KEY (ID_VENTA),
    CONSTRAINT venta_empleado_FK FOREIGN KEY (ID_EMPLEADO)
   REFERENCES dbo.empleado (ID_EMPLEADO)
)
GO

CREATE TABLE dbo.documento
(
    ID_DOCUMENTO          BIGINT         NOT NULL,
    ID_VENTA              BIGINT         NOT NULL,
    ID_ESTADO             TINYINT        NOT NULL,
    FEC_DOCUMENTO_EMITIDO DATETIME       NOT NULL,
    COSTO_DOCUMENTO       NUMERIC(12,12) NOT NULL,
    DESC_DOCUMENTO        VARCHAR(100)   NOT NULL,
    TIPO_DOCUMENTO        VARCHAR(20)    NOT NULL,
    CONSTRAINT documento_PK PRIMARY KEY (ID_DOCUMENTO),
    CONSTRAINT documento_venta_FK FOREIGN KEY (ID_VENTA)
    REFERENCES dbo.venta (ID_VENTA),
    CONSTRAINT documento_tipodocumento_FK FOREIGN KEY (ID_ESTADO)
   REFERENCES dbo.estado_documento (ID_ESTADO)
)
GO

CREATE TABLE dbo.contrato
(
    ID_CONTRATO   BIGINT       NOT NULL,
    FEC_CONTRATO  DATETIME     NOT NULL,
    DESC_CONTRATO VARCHAR(100) NOT NULL,
    CONSTRAINT contrato_PK PRIMARY KEY (ID_CONTRATO)
)
GO

CREATE TABLE dbo.detalle_contrato
(
    ID_DETALLE  BIGINT NOT NULL,
    ID_CONTRATO BIGINT NOT NULL,
    ID_PLAN     INT    NOT NULL,
    ID_CELULAR  BIGINT NOT NULL,
    ID_CLIENTE  BIGINT NOT NULL,
    CONSTRAINT detallecontrato_PK PRIMARY KEY (ID_DETALLE),
    CONSTRAINT detallecontrato_contrato_FK FOREIGN KEY (ID_CONTRATO)
    REFERENCES dbo.contrato (ID_CONTRATO),
    CONSTRAINT detallecontrato_plan_FK FOREIGN KEY (ID_PLAN)
    REFERENCES dbo."plan" (ID_PLAN),
    CONSTRAINT detallecontrato_celular_FK FOREIGN KEY (ID_CELULAR)
    REFERENCES dbo.celular (ID_CELULAR),
    CONSTRAINT detallecontrato_cliente_FK FOREIGN KEY (ID_CLIENTE)
    REFERENCES dbo.cliente (ID_CLIENTE)
)
GO

CREATE TABLE DETALLE_VENTA
(
    ID_DETALLEVEN BIGINT         NOT NULL,
    ID_VENTA      BIGINT         NOT NULL,
    ID_CONTRATO   BIGINT         NOT NULL,
    ID_METODO     TINYINT        NOT NULL,
    MONTO         NUMERIC(12,12) DEFAULT 0 NOT NULL,
    DESC_DETALLE  VARCHAR(200)   NOT NULL,
    CONSTRAINT detalle_venta_PK PRIMARY KEY (ID_DETALLEVEN),
    CONSTRAINT detalleventa_venta_FK FOREIGN KEY (ID_VENTA)
   REFERENCES dbo.venta (ID_VENTA),
    CONSTRAINT detalleventa_contrato_FK FOREIGN KEY (ID_CONTRATO)
   REFERENCES dbo.contrato (ID_CONTRATO),
    CONSTRAINT detalleventa_metodopago_FK FOREIGN KEY (ID_METODO)
   REFERENCES dbo.metodo_pago (ID_METODO)
)
GO

