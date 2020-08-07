CREATE TABLE dbo.Categorias(
	CategoriaID INT NOT NULL,
	Categoria NVARCHAR(15) NOT NULL,
	Descripcion NTEXT NULL,
	Imagen IMAGE NULL,
PRIMARY KEY CLUSTERED 
(
	CategoriaID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY
) ON PRIMARY TEXTIMAGE_ON PRIMARY
GO
CREATE TABLE dbo.Clientes(
	ClienteID NCHAR(5) NOT NULL,
	Empresa NVARCHAR(40) NOT NULL,
	Contacto NVARCHAR(30) NULL,
	Cargo NVARCHAR(30) NULL,
	Direccion NVARCHAR(60) NULL,
	Ciudad NVARCHAR(15) NULL,
	CodigoPostal NVARCHAR(10) NULL,
	Pais NVARCHAR(15) NULL,
	Telefono NVARCHAR(24) NULL,
PRIMARY KEY CLUSTERED 
(
	ClienteID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY
) ON PRIMARY
GO
	CREATE TABLE dbo.DetalleOrden(
	OrdenID INT NOT NULL,
	ProductoID INT NOT NULL,
	PrecioUnitario MONEY NOT NULL,
	Cantidad SMALLINT NOT NULL,
	Descuento REAL NOT NULL,
PRIMARY KEY CLUSTERED 
(
	ProductoID ASC,
	OrdenID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY
) ON PRIMARY
GO

	CREATE TABLE dbo.Empleados(
	EmpleadoID INT NOT NULL,
	Apellido NVARCHAR(20) NOT NULL,
	Nombre NVARCHAR(10) NOT NULL,
	Cargo NVARCHAR(30) NULL,
	FechaNacimiento DATETIME NULL,
	FechaContratacion DATETIME NULL,
	Direccion NVARCHAR(60) NULL,
	Ciudad NVARCHAR(15) NULL,
	Pais NVARCHAR(15) NULL,
PRIMARY KEY CLUSTERED 
(
	EmpleadoID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY
) ON PRIMARY
GO

	CREATE TABLE dbo.Ordenes(
	OrdenID INT NOT NULL,
	ClienteID NCHAR(5) NULL,
	EmpleadoID INT NULL,
	FechaOrden DATETIME NULL,
	FechaEnvio DATETIME NULL,
	EnviadoPor INT NULL,
	CiudadEnvio NVARCHAR(15) NULL,
	PaisEnvio NVARCHAR(15) NULL,
	CodigoPostal NVARCHAR(10) NULL,
PRIMARY KEY CLUSTERED 
(
	OrdenID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY
) ON PRIMARY
GO

	CREATE TABLE dbo.Productos(
	ProductoID INT NOT NULL,
	Producto NVARCHAR(40) NOT NULL,
	ProveedorID INT NULL,
	CategoriaID INT NULL,
	CantidadPorUnidad NVARCHAR(20) NULL,
	PrecioUnitario MONEY NULL,
PRIMARY KEY CLUSTERED 
(
	ProductoID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY
) ON PRIMARY
GO

			CREATE TABLE dbo.Proveedores(
	ProveedorID INT NOT NULL,
	Proveedor NVARCHAR(40) NOT NULL,
	Contacto NVARCHAR(30) NULL,
	Cargo NVARCHAR(30) NULL,
	Direccion NVARCHAR(60) NULL,
	Ciudad NVARCHAR(15) NULL,
	Pais NVARCHAR(15) NULL,
	Telefono NVARCHAR(24) NULL,
PRIMARY KEY CLUSTERED 
(
	ProveedorID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY
) ON PRIMARY
GO

		CREATE TABLE dbo.Regiones(
	RegionID INT NOT NULL,
	Region NCHAR(50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	RegionID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY
) ON PRIMARY
GO

		CREATE TABLE dbo.Territorios(
	TerritorioID NVARCHAR(20) NOT NULL,
	Territorio NCHAR(50) NOT NULL,
	RegionID INT NOT NULL,
PRIMARY KEY CLUSTERED 
(
	TerritorioID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY
) ON PRIMARY
GO

		CREATE TABLE dbo.TerritoriosEmpleados(
	EmpleadoID INT NOT NULL,
	TerritorioID NVARCHAR(20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	EmpleadoID ASC,
	TerritorioID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY
) ON PRIMARY
GO

		CREATE TABLE dbo.Transportistas(
	TransportistaID INT NOT NULL,
	Transportista NVARCHAR(40) NOT NULL,
	Telefono NVARCHAR(24) NULL,
PRIMARY KEY CLUSTERED 
(
	TransportistaID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY
) ON PRIMARY
GO
