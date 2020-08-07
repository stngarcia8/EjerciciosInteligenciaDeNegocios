USE master;
GO
SET NOCOUNT ON;
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a ' + db_name() + '.';
GO


-- Creando la base de datos.
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Creando base de datos.';
DROP DATABASE IF EXISTS [REL_CESFAM]
GO
CREATE DATABASE REL_CESFAM;
GO
USE REL_CESFAM;
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a ' + db_name() + '.';
GO


-- Creando tablas de la base de datos.
CREATE TABLE dbo.especialidad
(
    id_especialidad          SMALLINT    PRIMARY KEY IDENTITY(1,1) NOT NULL,
    descripcion_especialidad VARCHAR(50) NOT NULL,
    fecha_registro           DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion       DATE,
    estado_registro          BIT         DEFAULT 1 NOT NULL
);
GO


CREATE TABLE dbo.estado_civil
(
    id_estadocivil           TINYINT     PRIMARY KEY IDENTITY(1,1) NOT NULL,
    descripcion_estado_civil VARCHAR(15) NOT NULL,
    fecha_registro           DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion       DATE,
    estado_registro          BIT         DEFAULT 1 NOT NULL
);
GO


CREATE TABLE dbo.fabricante
(
    id_fabricante      INT         PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre_fabricante  VARCHAR(30) NOT NULL,
    fecha_registro     DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL
);
GO


CREATE TABLE dbo.horario
(
    id_horario    TINYINT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    horario_desde TIME    NOT NULL,
    horario_hasta TIME    NOT NULL
);
GO


CREATE TABLE dbo.medida_medicamento
(
    id_medida          INT         PRIMARY KEY IDENTITY(1,1) NOT NULL,
    descripcion_medida VARCHAR(20) NOT NULL,
    fecha_registro     DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL
);
GO


CREATE TABLE dbo.nivel_urgencia
(
    id_nivelurgencia          TINYINT     PRIMARY KEY IDENTITY(1,1) NOT NULL,
    descripcion_nivelurgencia VARCHAR(20) NOT NULL,
    fecha_registro            DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion        DATE,
    estado_registro           BIT         DEFAULT 1 NOT NULL
);
GO


CREATE TABLE dbo.sexo
(
    id_sexo            TINYINT     PRIMARY KEY IDENTITY(1,1) NOT NULL,
    descripcion_sexo   VARCHAR(10) NOT NULL,
    fecha_registro     DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL
);
GO


CREATE TABLE dbo.tipo_componente
(
    id_componente          INT         PRIMARY KEY IDENTITY(1,1) NOT NULL,
    descripcion_componente VARCHAR(50) NOT NULL,
    fecha_registro         DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion     DATE,
    estado_registro        BIT         DEFAULT 1 NOT NULL
);
GO


CREATE TABLE dbo.tipo_medicamento
(
    id_tipomedicamento INT         PRIMARY KEY IDENTITY(1,1) NOT NULL,
    descripcion_tipo   VARCHAR(30) NOT NULL,
    fecha_registro     DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT         DEFAULT 1 NOT NULL
);
GO


CREATE TABLE dbo.titulo
(
    id_titulo              INT         PRIMARY KEY IDENTITY(1,1) NOT NULL,
    descripcion_titulo     VARCHAR(50) NOT NULL,
    institucion_titulacion VARCHAR(50) NOT NULL,
    anio_titulacion        SMALLINT    DEFAULT 0 NOT NULL,
    fecha_registro         DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion     DATE,
    estado_registro        BIT         DEFAULT 1 NOT NULL
);
GO


CREATE TABLE paciente
(
    id_paciente        INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_sexo            TINYINT      NOT NULL,
    id_estadocivil     TINYINT      NOT NULL,
    rut_paciente       VARCHAR(10)  NOT NULL,
    nombre             VARCHAR(30)  NOT NULL,
    apellido_paterno   VARCHAR(30)  NOT NULL,
    apellido_materno   VARCHAR(30)  DEFAULT '' NOT NULL,
    fecha_nacimiento   DATE         NOT NULL,
    telefono_contacto  VARCHAR(15)  DEFAULT '',
    email              VARCHAR(75)  DEFAULT '',
    domicilio          VARCHAR(100) NOT NULL,
    grupo_sanguineo    VARCHAR(20)  DEFAULT '',
    fecha_registro     DATE         DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT          DEFAULT 1 NOT NULL,
    CONSTRAINT rut_paciente_un UNIQUE ( rut_paciente ),
    CONSTRAINT paciente_sexo_fk FOREIGN KEY ( id_sexo)
    REFERENCES dbo.sexo ( id_sexo ),
    CONSTRAINT paciente_estadocivil_fk FOREIGN KEY ( id_estadocivil )
    REFERENCES dbo.estado_civil ( id_estadocivil )
);
GO


CREATE TABLE dbo.administrativo
(
    id_administrativo  INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    rut_administrativo VARCHAR(10)  NOT NULL,
    nombre             VARCHAR(30)  NOT NULL,
    apellido_paterno   VARCHAR(30)  NOT NULL,
    apellido_materno   VARCHAR(30)  DEFAULT '',
    telefono_contacto  VARCHAR(15)  DEFAULT '',
    email              VARCHAR(75)  DEFAULT '',
    domicilio          VARCHAR(100) NOT NULL,
    fecha_registro     DATE         DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT          DEFAULT 1 NOT NULL,
    CONSTRAINT rut_administrativo_un UNIQUE ( rut_administrativo )
);
GO


CREATE TABLE dbo.medico
(
    id_medico          INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_titulo          INT          NOT NULL,
    rut_medico         VARCHAR(10)  NOT NULL,
    nombre             VARCHAR(30)  NOT NULL,
    apellido_paterno   VARCHAR(30)  NOT NULL,
    apellido_materno   VARCHAR(30)  DEFAULT '',
    telefono_contacto  VARCHAR(15)  DEFAULT '',
    email              VARCHAR(75)  DEFAULT '',
    domicilio          VARCHAR(100) DEFAULT '',
    fecha_registro     DATE         DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT          DEFAULT 1 NOT NULL,
    CONSTRAINT rut_medico_un UNIQUE ( rut_medico ),
    CONSTRAINT medico_titulo_fk FOREIGN KEY   ( id_titulo )
    REFERENCES dbo.titulo ( id_titulo )
);
GO


CREATE TABLE dbo.horario_medico
(
    id_medico      INT     NOT NULL,
    id_horario     TINYINT NOT NULL,
    fecha_atencion DATE    NOT NULL,
    CONSTRAINT horario_medico_pk PRIMARY KEY ( id_medico, id_horario),
    CONSTRAINT horariomedico_medico_fk FOREIGN KEY ( id_medico )
    REFERENCES dbo.medico ( id_medico ),
    CONSTRAINT horariomedico_horario_fk FOREIGN KEY ( id_horario) 
    REFERENCES dbo.horario ( id_horario )
);
GO


CREATE TABLE dbo.medicamento
(
    id_medicamento          INT         PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_tipomedicamento      INT         NOT NULL,
    codigo_medicamento      VARCHAR(15) NOT NULL,
    descripcion_medicamento VARCHAR(30) NOT NULL,
    fecha_registro          DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion      DATE,
    estado_registro         BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT codigo_medicamento_un UNIQUE ( codigo_medicamento ),
    CONSTRAINT medicamento_tipomedicamento_fk FOREIGN KEY ( id_tipomedicamento )
    REFERENCES dbo.tipo_medicamento ( id_tipomedicamento )
);
GO


CREATE TABLE dbo.detalle_medicamento
(
    id_medicamento     INT  NOT NULL,
    id_fabricante      INT  NOT NULL,
    id_medida          INT  NOT NULL,
    cantidad_contenido INT  DEFAULT 0 NOT NULL,
    stock_medicamento  INT  DEFAULT 0 NOT NULL,
    fecha_registro     DATE DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT  DEFAULT 1 NOT NULL,
    CONSTRAINT detalle_medicamento_pk PRIMARY KEY ( id_medicamento, id_fabricante, id_medida ),
    CONSTRAINT detallemedicamento_medicamento_fk FOREIGN KEY ( id_medicamento )
    REFERENCES dbo.medicamento ( id_medicamento ),
    CONSTRAINT detallemedicamento_fabricante_fk FOREIGN KEY ( id_fabricante)
    REFERENCES dbo.fabricante ( id_fabricante ),
    CONSTRAINT detallemedicamento_medida_fk FOREIGN KEY ( id_medida )
    REFERENCES dbo.medida_medicamento ( id_medida )
);
GO


CREATE TABLE dbo.componentes_medicamento
(
    id_medicamento      INT         NOT NULL,
    id_componente       INT         NOT NULL,
    cantidad_componente VARCHAR(30) NOT NULL,
    fecha_registro      DATE        DEFAULT getdate() NOT NULL,
    fecha_modificacion  DATE,
    estado_registro     BIT         DEFAULT 1 NOT NULL,
    CONSTRAINT componentes_medicamento_pk PRIMARY KEY ( id_medicamento, id_componente) ,
    CONSTRAINT componentemedicamento_medicamento_fk FOREIGN KEY ( id_medicamento )
    REFERENCES dbo.medicamento ( id_medicamento ),
    CONSTRAINT componentesmedicamento_componente_fk FOREIGN KEY ( id_componente )
    REFERENCES dbo.tipo_componente ( id_componente )
);
GO


CREATE TABLE dbo.ficha_ingreso
(
    id_ficha             INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_paciente          INT          NOT NULL,
    id_administrativo    INT          NOT NULL,
    id_nivelurgencia     TINYINT      NOT NULL,
    fecha_ingreso        DATE         NOT NULL,
    hora_ingreso         TIME         NOT NULL,
    paciente_acompanado  BIT          DEFAULT 0 NOT NULL,
    motivo_consulta      VARCHAR(max) DEFAULT '' NOT NULL,
    descripcion_paciente VARCHAR(max) DEFAULT '' NOT NULL,
    fecha_registro       DATE         DEFAULT getdate() NOT NULL,
    fecha_modificacion   DATE,
    estado_registro      BIT          DEFAULT 1 NOT NULL,
    CONSTRAINT ficha_paciente_fk FOREIGN KEY ( id_paciente )
    REFERENCES dbo.paciente ( id_paciente ),
    CONSTRAINT ficha_administrativo_fk FOREIGN KEY ( id_administrativo )
    REFERENCES dbo.administrativo ( id_administrativo ),
    CONSTRAINT ficha_nivelurgencia_fk FOREIGN KEY ( id_nivelurgencia )
    REFERENCES dbo.nivel_urgencia ( id_nivelurgencia )
);
GO


CREATE TABLE dbo.atencion
(
    id_atencion         INT          PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_ficha            INT          NOT NULL,
    id_especialidad     SMALLINT     NOT NULL,
    id_medico           INT          NOT NULL,
    fecha_atencion      DATE         NOT NULL,
    hora_atencion       TIME         NOT NULL,
    sintomas_detectados VARCHAR(max) NOT NULL,
    diagnostico         VARCHAR(max) NOT NULL,
    requiere_reposo     BIT          DEFAULT 0 NOT NULL,
    dias_reposo         TINYINT      DEFAULT 0 NOT NULL,
    fecha_registro      DATE         DEFAULT getdate() NOT NULL,
    fecha_modificacion  DATE,
    estado_registro     BIT          DEFAULT 1 NOT NULL,
    CONSTRAINT atencion_FICHA_fk FOREIGN KEY ( id_ficha )
    REFERENCES dbo.ficha_ingreso ( id_ficha ) ,
    CONSTRAINT atencion_especialidad_fk FOREIGN KEY ( id_especialidad )
    REFERENCES dbo.especialidad ( id_especialidad ),
    CONSTRAINT atencion_medico_fk FOREIGN KEY ( id_medico )
    REFERENCES dbo.medico ( id_medico )
);
GO


CREATE TABLE dbo.receta_ATENCION
(
    id_receta          INT          IDENTITY(1,1) NOT NULL,
    id_atencion        INT          NOT NULL,
    id_medicamento     INT          NOT NULL,
    dosis_medicamento  VARCHAR(100) NOT NULL,
    dias_medicacion    TINYINT      DEFAULT 0 NOT NULL,
    fecha_registro     DATE         DEFAULT getdate() NOT NULL,
    fecha_modificacion DATE,
    estado_registro    BIT          DEFAULT 1 NOT NULL,
    CONSTRAINT receta_atencion_pk PRIMARY KEY ( id_receta, id_atencion),
    CONSTRAINT recetatencion_atencion_fk FOREIGN KEY ( id_ATENCION )
    REFERENCES dbo.atencion ( id_atencion ),
    CONSTRAINT recetatencion_medicamento_fk FOREIGN KEY ( id_medicamento )
    REFERENCES dbo.medicamento ( id_medicamento )
);
GO


PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'creacion de base de datos ' + db_name() + ' finalizada.';
GO