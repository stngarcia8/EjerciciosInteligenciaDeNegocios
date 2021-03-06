USE master;
GO
SET NOCOUNT ON;
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a ' + db_name() + '.';
GO


-- Creando la base de datos.
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Creando base de datos.';
DROP DATABASE IF EXISTS [DW_CESFAM_STAR]
GO
CREATE DATABASE DW_CESFAM_STAR;
GO
USE DW_CESFAM_STAR;
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a ' + db_name() + '.';
GO


-- Creando tablas de la base de datos.
CREATE TABLE dbo.dim_especialidad
(
    id_especialidad          INT         PRIMARY KEY IDENTITY(1,1) NOT NULL,
    descripcion_especialidad VARCHAR(50) NOT NULL,

    -- Campos para la metadata de los registros.
    fecha_registro           DATE        DEFAULT getdate() NOT NULL,
    estado_registro          BIT         DEFAULT 1 NOT NULL
);
GO


CREATE TABLE dbo.dim_nivelurgencia
(
    id_nivelurgencia          INT         PRIMARY KEY IDENTITY(1,1) NOT NULL,
    descripcion_nivelurgencia VARCHAR(20) NOT NULL,

    -- Campos para la metadata de los registros.
    fecha_registro            DATE        DEFAULT getdate() NOT NULL,
    estado_registro           BIT         DEFAULT 1 NOT NULL
);
GO


CREATE TABLE dbo.dim_paciente
(
    id_paciente       INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    rut_paciente      VARCHAR(10)  NOT NULL,
    nombre            VARCHAR(30)  NOT NULL,
    apellido_paterno  VARCHAR(30)  NOT NULL,
    apellido_materno  VARCHAR(30)  DEFAULT '',
    estado_civil      VARCHAR(15)  DEFAULT '',
    sexo              VARCHAR(10)  DEFAULT '',
    fecha_nacimiento  DATE         NOT NULL,
    telefono_contacto VARCHAR(15)  DEFAULT '',
    email             VARCHAR(75)  DEFAULT '',
    domicilio         VARCHAR(100) DEFAULT '',
    grupo_sanguineo   VARCHAR(20)  DEFAULT '',

    -- Campos para la metadata de los registros.
    fecha_registro    DATE         DEFAULT getdate() NOT NULL,
    estado_registro   BIT          DEFAULT 1 NOT NULL,

    -- Restriccion de clave unica para el rut.
    CONSTRAINT rut_paciente_un UNIQUE ( rut_paciente )
);
GO


CREATE TABLE dbo.dim_administrativo
(
    id_administrativo  INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    rut_administrativo VARCHAR(10)  NOT NULL,
    nombre             VARCHAR(30)  NOT NULL,
    apellido_paterno   VARCHAR(30)  NOT NULL,
    apellido_materno   VARCHAR(30)  DEFAULT '',
    telefono_contacto  VARCHAR(15)  DEFAULT '',
    email              VARCHAR(75)  DEFAULT '',
    domicilio          VARCHAR(100) DEFAULT '',

    -- Campos para la metadata de los registros.
    fecha_registro     DATE         DEFAULT getdate() NOT NULL,
    estado_registro    BIT          DEFAULT 1 NOT NULL,

    -- Restriccion de clave unica para el rut.
    CONSTRAINT rut_administrativo_un UNIQUE ( rut_administrativo )
);
GO


CREATE TABLE dbo.dim_medico
(
    id_medico              INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    rut_medico             VARCHAR(10)  NOT NULL,
    nombre                 VARCHAR(30)  NOT NULL,
    apellido_paterno       VARCHAR(30)  NOT NULL,
    apellido_materno       VARCHAR(30)  DEFAULT '',
    telefono_contacto      VARCHAR(15)  DEFAULT '',
    email                  VARCHAR(75)  DEFAULT '',
    domicilio              VARCHAR(100) DEFAULT '',
    titulo                 VARCHAR(50)  NOT NULL,
    institucion_titulacion VARCHAR(50)  NOT NULL,
    anio_titulacion        INT          DEFAULT 0,

    -- Campos para la metadata de los registros.
    fecha_registro         DATE         DEFAULT getdate() NOT NULL,
    estado_registro        BIT          DEFAULT 1 NOT NULL,

    -- Restriccion de clave unica para el rut.
    CONSTRAINT rut_medico_un UNIQUE ( rut_medico )
);
GO


CREATE TABLE dbo.dim_atencion
(
    id_atencion         INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    sintomas_detectados VARCHAR(max) DEFAULT '',
    diagnostico         VARCHAR(max) DEFAULT '',

    -- Campos para la metadata de los registros.
    fecha_registro      DATE         DEFAULT getdate() NOT NULL,
    estado_registro     BIT          DEFAULT 1 NOT NULL
);
GO


CREATE TABLE dbo.dim_fecha
(
    id_fecha           INT         PRIMARY KEY NOT NULL,
    fecha_ingreso      DATE        NOT NULL,
    dia_ingreso        INT         DEFAULT 0,
    nombredia_ingreso  VARCHAR(15) DEFAULT '',
    semana_ingreso     INT         DEFAULT 0,
    mes_ingreso        INT         DEFAULT 0,
    nombremes_ingreso  VARCHAR(20) DEFAULT '',
    anio_ingreso       INT         DEFAULT 0,
    hora_ingreso       TIME        NOT NULL,
    fecha_atencion     DATE        NOT NULL,
    dia_atencion       INT         DEFAULT 0,
    nombredia_atencion VARCHAR(15) DEFAULT '',
    semana_atencion    INT         DEFAULT 0,
    mes_atencion       INT         DEFAULT 0,
    nombremes_atencion VARCHAR(20) DEFAULT '',
    anio_atencion      INT         DEFAULT 0,
    hora_atencion      TIME        NOT NULL,

    -- Campos para la metadata de los registros.
    fecha_registro     DATE        DEFAULT getdate() NOT NULL,
    estado_registro    BIT         DEFAULT 1 NOT NULL
);
GO


CREATE TABLE dbo.hechos_prescripcion
(
    id_paciente           INT  NOT NULL,
    id_administrativo     INT  NOT NULL,
    id_medico             INT  NOT NULL,
    id_especialidad       INT  NOT NULL,
    id_nivelurgencia      INT  NOT NULL,
    id_atencion           INT  NOT NULL,
    id_fecha              INT  NOT NULL,
    tiempo_espera         INT  DEFAULT 0,
    tiempo_atencion       INT  DEFAULT 0 ,
    requiere_medicamentos BIT  DEFAULT 0 ,
    requiere_reposo       BIT  DEFAULT 0 ,
    cant_dias_reposo      INT  DEFAULT 0 ,

    -- Campos para la metadata de los registros.
    fecha_registro        DATE DEFAULT getdate() NOT NULL,
    estado_registro       BIT  DEFAULT 1 NOT NULL,

    -- Definicion de las claves foraneas.
    CONSTRAINT hechos_paciente FOREIGN KEY ( id_paciente )
    REFERENCES dbo.dim_paciente ( id_paciente ),
    CONSTRAINT hechos_administrativo_fk FOREIGN KEY ( id_administrativo )
    REFERENCES dbo.dim_administrativo ( id_administrativo ),
    CONSTRAINT hechos_medico_fk FOREIGN KEY ( id_medico )
    REFERENCES dbo.dim_medico ( id_medico ),
    CONSTRAINT hechos_especialidad_fk FOREIGN KEY ( id_especialidad )
    REFERENCES dbo.dim_especialidad ( id_especialidad ),
    CONSTRAINT hechos_nivelurgencia_fk FOREIGN KEY ( id_nivelurgencia )
    REFERENCES dbo.dim_nivelurgencia ( id_nivelurgencia ),
    CONSTRAINT hechos_atencion_fk FOREIGN KEY ( id_atencion ) 
    REFERENCES dbo.dim_atencion ( id_atencion ),
    CONSTRAINT hechos_fecha_fk FOREIGN KEY ( id_fecha )
    REFERENCES dbo.dim_fecha ( id_fecha )
);
GO 
