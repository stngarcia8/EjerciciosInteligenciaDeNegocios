/*
    Script:     dwKentFoods.sql
    Profesor:   Cristian Salazar.
    Ramo:       Inteligencia de negocios.
    Alumnos:    Daniel García.
                Ignacio Salazar.
    Fecha:      18/11/2019
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
    trabajamos con contenedores y si pasamos esto tal cual colocando los
    atributos file_name and file_path, estas son rutas linux, por lo cual,
    no funcionarán al momento de ejecutar el script en windows.
    La versión utilizada del motor de sql server utilizado es la 2019 developer edition
    No existe la versión 2012 para utlizarla con contenedores.
*/
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
    EmpleadoID   INT           NOT NULL,
    Apellido     NVARCHAR(20)  NOT NULL,
    Nombre       NVARCHAR(10)  NOT NULL,
    Cargo        NVARCHAR(30),
    Direccion    NVARCHAR(60),
    Ciudad       NVARCHAR(15),
    Pais         NVARCHAR(15),
    Territorio   NVARCHAR(100),
    Region       NVARCHAR(50),
    CreationDate DATETIME      DEFAULT getdate() NOT NULL,
    UpdateDate   DATETIME,
    CONSTRAINT pk_dimempleado PRIMARY KEY (EmpleadoID ASC)
);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Creando la dimension producto.';
GO
CREATE TABLE dbo.dim_producto
(
    ProductoID        INT          NOT NULL,
    Producto          NVARCHAR(40) NOT NULL,
    CantidadPorUnidad INT          DEFAULT 0,
    PrecioUnitario    MONEY        DEFAULT 0,
    CreationDate      DATETIME     DEFAULT getdate() NOT NULL,
    UpdateDate        DATETIME,
    CONSTRAINT pk_producto PRIMARY KEY (ProductoID ASC)
);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Creando la dimension proveedor.';
GO
CREATE TABLE dbo.dim_proveedor
(
    ProveedorID  INT          NOT NULL,
    Proveedor    NVARCHAR(40) NOT NULL,
    Contacto     NVARCHAR(30),
    Cargo        NVARCHAR(30),
    Direccion    NVARCHAR(60),
    Ciudad       NVARCHAR(15),
    Pais         NVARCHAR(15),
    CreationDate DATETIME     DEFAULT getdate() NOT NULL,
    UpdateDate   DATETIME,
    CONSTRAINT pk_proveedor PRIMARY KEY (ProveedorID ASC)
);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Creando la dimension categoria.';
GO
CREATE TABLE dbo.dim_categoria
(
    CategoriaID  INT          NOT NULL,
    Categoria    NVARCHAR(15) NOT NULL,
    Descripcion  VARCHAR(max),
    CreationDate DATETIME     DEFAULT getdate() NOT NULL,
    UpdateDate   DATETIME,
    CONSTRAINT pk_categoria PRIMARY KEY (CategoriaID ASC)
);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Creando la dimension tiempo.';
GO
CREATE TABLE dbo.dim_tiempo
(
    FechaID      INT         NOT NULL,
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
    hora         TIME        NOT NULL,
    nro_hora     INT         NOT NULL,
    nro_minutos  INT         NOT NULL,
    CreationDate DATETIME    DEFAULT getdate() NOT NULL,
    UpdateDate   DATETIME,
    CONSTRAINT fecha_pk PRIMARY KEY (FechaID)
)
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Creando la tabla de hechos.';
GO
CREATE TABLE fact_orden
(
    FechaID                      INT          NOT NULL,
    EmpleadoID                   INT          NULL,
    ProductoID                   INT          NOT NULL,
    ProveedorID                  INT          NOT NULL,
    CategoriaID                  INT          NOT NULL,
    FechaOrden                   INT          NULL,
    FechaEnvio                   INT          NULL,
    Empresa_cliente              NVARCHAR(40) NOT NULL,
    Cargo_cliente                NVARCHAR(30),
    Ciudad_cliente               NVARCHAR(15),
    Pais_cliente                 NVARCHAR(15),
    CodigoPostal_cliente         NVARCHAR(10),
    Transportista                NVARCHAR(40),
    CiudadEnvio                  NVARCHAR(15),
    PaisEnvio                    NVARCHAR(15) ,
    CodigoPostal_envio           NVARCHAR(10),
    PrecioUnitario               BIGINT       DEFAULT 0 NOT NULL,
    Cantidad                     INT          DEFAULT 0 NOT NULL,
    PrecioVenta                  BIGINT       DEFAULT 0 NOT NULL,
    Descuento                    REAL         DEFAULT 0 NOT NULL,
    TotalVenta                   BIGINT       DEFAULT 0 NOT NULL,
    ProductosVendidosALaFecha    INT          DEFAULT 0 NOT NULL,
    CantidadDeComprasDelProducto INT          DEFAULT 0 NOT NULL,
    TieneDescuento               BIT          DEFAULT 0 NOT NULL,
    EnvioLocal                   BIT          DEFAULT 0 NOT NULL,
    EnvioInternacional           BIT          DEFAULT 0 NOT NULL,
    EsClienteEmpresa             BIT          DEFAULT 0 NOT NULL,
    CreationDate                 DATETIME     DEFAULT getdate() NOT NULL,
    UpdateDate                   DATETIME,
    CONSTRAINT fk_factOrden_tiempo FOREIGN KEY (FechaID) 
    REFERENCES dbo.dim_tiempo (FechaID),
    CONSTRAINT fk_factOrden_empleado FOREIGN KEY (EmpleadoID) 
    REFERENCES dbo.dim_empleado (EmpleadoID),
    CONSTRAINT fk_factOrden_producto FOREIGN KEY (ProductoID) 
    REFERENCES dbo.dim_producto (ProductoID),
    CONSTRAINT fk_factOrden_proveedor FOREIGN KEY (ProveedorID) 
    REFERENCES dbo.dim_proveedor (ProveedorID),
    CONSTRAINT fk_factOrden_categoria FOREIGN KEY (CategoriaID) 
    REFERENCES dbo.dim_categoria (CategoriaID)
);
GO

PRINT '';
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' Finalizando script.';
GO 