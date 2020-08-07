USE master;
GO
SET NOCOUNT ON;
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a ' + db_name() + '.';
GO
-- Monitorizando objetos.
CREATE OR ALTER TRIGGER ddl_trig_database   
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


-- Creando la base de datos.
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Creando base de datos.';
DROP DATABASE IF EXISTS [REL_CESFAM]
GO
CREATE DATABASE REL_CESFAM;
GO
USE REL_CESFAM;
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Cambiando a ' + db_name() + '.';
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
    descripcion_medida VARCHAR(40) NOT NULL,
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


CREATE TABLE dbo.paciente
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
    CONSTRAINT horario_medico_pk PRIMARY KEY ( id_medico, id_horario, fecha_atencion),
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


-- Insercion de registros.
PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando especialidades.';
INSERT INTO dbo.especialidad
    ([descripcion_especialidad])
VALUES
    ('Urgencia adulto'),
    ('Urgencia pediatrica'),
    ('Odontologia'),
    ('Oftalmologia'),
    ('Medicina general'),
    ('Cardiologia'),
    ('Medicina nuclear'),
    ('Kinesiologia'),
    ('Anatomia patologica'),
    ('Neurologia');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando estados civiles';
INSERT INTO dbo.estado_civil
    ([descripcion_estado_civil])
VALUES
    ('Soltero'),
    ('Casado'),
    ('Divorciado'),
    ('Viudo');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando fabricantes de medicamentos.';
INSERT INTO dbo.fabricante
    ([nombre_fabricante])
VALUES
    ('Sabal'),
    ('Novartis');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando horarios de atencion.';
INSERT INTO dbo.horario
    ([horario_desde], [horario_hasta])
VALUES
    ('08:00', '14:00'),
    ('15:00', '21:00'),
    ('08:00', '17:00'),
    ('11:00', '21:00');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando medidas de medicamentos.';
INSERT INTO dbo.medida_medicamento
    ([descripcion_medida])
VALUES
    ('Gramo (g)'),
    ('Miligramo (mg'),
    ('Unidades internacionales (UI)');
GO


PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando los niveles de urgencias.';
INSERT INTO dbo.nivel_urgencia
    ([descripcion_nivelurgencia])
VALUES
    ('Critico C1'),
    ('Grave C2'),
    ('Intermedio C3'),
    ('Bajo C4'),
    ('Leve C5');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando sexos.';
INSERT INTO dbo.sexo
    ([descripcion_sexo])
VALUES
    ('Femenino'),
    ('Masculino');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando tipos de componentes de medicamentos.';
INSERT INTO dbo.tipo_componente
    ([descripcion_componente])
VALUES
    ('Componente 1'),
    ('Componente 2');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando tipos de medicamentos.';
INSERT INTO dbo.tipo_medicamento
    ([descripcion_tipo])
VALUES
    ('Analgesicos'),
    ('Antiacidos-antiulcerosos'),
    ('Antialergicos'),
    ('Antiinfecciosos');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando titulos de los medicos.';
INSERT INTO dbo.titulo
    ([descripcion_titulo], [institucion_titulacion], [anio_titulacion])
VALUES
    ('Medicina general', 'Universidad de Chile', 2001),
    ('Medicina cardiovascular', 'Universidad Catolica', 1996),
    ('Kinesiologia', 'Universidad de Chile', 2010),
    ('Anatomo patologo', 'Universidad Catolica', 1990);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando pacientes.';
INSERT INTO dbo.paciente
    ([id_sexo], [id_estadocivil], [rut_paciente], [nombre], [apellido_paterno], [apellido_materno], [fecha_nacimiento], [telefono_contacto], [email], [domicilio], [grupo_sanguineo])
VALUES
    (2, 2, '07896457-1', 'Ernesto', 'Mado', '', '1951-01-01', '+569 78965412', '', 'Calle El vino 44', 'O4 Negativo'),
    (1, 1, '08456123-K', 'Ana Lisa', 'Melano', 'Rojo', '1974-09-12', '+569 98765432', 'anitamelano@gmail.com', 'El especulum 69', 'RH Positivo'),
    (1, 2, '12345678-9', 'Zoila', 'Mante', 'Del Rio', '1965-02-20', '+569 96754839', 'zoila87@hotmail.com', 'Las pasiones 2145', 'RH Positivo');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando administrativos.';
INSERT INTO dbo.administrativo
    ([rut_administrativo], [nombre], [apellido_paterno], [apellido_materno], [telefono_contacto], [email], [domicilio])
VALUES
    ('14235678-9', 'Mauricio', 'Y La Vaca', 'Toro', '+569 84623524', 'mauricio_muuuu@atenciones.com', 'Las atenciones 1234');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agrengado medicos.';
INSERT INTO dbo.medico
    ([id_titulo], [rut_medico], [nombre], [apellido_paterno], [apellido_materno], [telefono_contacto], [email], [domicilio])
VALUES
    (1, '13456789-2', 'Armando', 'Casas', 'Nuevas', '+569 48150203', 'armando@medico.com', 'El matasanos 777'),
    (2, '13245678-2', 'Victor Hugo', 'Escritor', 'De Libros', '+569 98543206', 'victorhugo@medico.com', 'Avenida Los Fomes 056'),
    (3, '09123654-3', 'Carlos', 'Montijo', 'Chapatin', '+569 97857496', 'chapatin@medico.com', 'Pasaje 1 1');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Relacionando los horarios de medicos.';
INSERT INTO dbo.horario_medico
    ([id_medico], [id_horario], [fecha_atencion])
VALUES
    (1, 1, '2019-10-02'),
    (1, 2, '2019-10-03'),
    (1, 3, '2019-10-04'),
    (1, 2, '2019-10-05'),
    (1, 1, '2019-10-06'),
    (2, 3, '2019-10-02'),
    (2, 2, '2019-10-03'),
    (2, 1, '2019-10-04'),
    (2, 2, '2019-10-05'),
    (2, 3, '2019-10-06'),
    (3, 3, '2019-10-02'),
    (3, 4, '2019-10-03'),
    (3, 4, '2019-10-05'),
    (3, 3, '2019-10-06');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando medicamentos.';
INSERT INTO dbo.medicamento
    ([id_tipomedicamento], [codigo_medicamento], [descripcion_medicamento])
VALUES
    (1, 'ivo01', 'IBUPROFENO'),
    (1, 'MET01', 'Metamisol'),
    (1, 'PAR01', 'Paracetamol'),
    (1, 'SEL01', 'CELECOXIB'),
    (1, 'TRA01', 'TRAMADOL'),
    (2, 'BIC02', 'Bicarbonato de sodio'),
    (2, 'HID02', 'Hidróxido de magnesio'),
    (2, 'OME02', 'Omeprazol'),
    (3, 'CLO03', 'Clorfenamina'),
    (3, 'LOR03', 'Loratadina'),
    (4, 'AMO04', 'Amoxicilina'),
    (4, 'CLO04', 'CLOTRIMAZOL');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando detalle de medicamentos.';
INSERT INTO dbo.detalle_medicamento
    ([id_medicamento], [id_fabricante],[id_medida], [stock_medicamento])
VALUES
    (1, 1, 1, 10000),
    (2, 2, 2, 10000),
    (3, 1, 3, 10000),
    (4, 2, 1, 10000),
    (5, 1, 2, 10000),
    (6, 2, 3, 10000),
    (7, 1, 1, 10000),
    (8, 2, 2, 10000),
    (9, 1, 3, 10000),
    (10, 2, 1, 10000),
    (11, 1, 2, 10000),
    (12, 2, 3, 10000);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando componentes de medicamentos.';
INSERT INTO dbo.componentes_medicamento
    ([id_medicamento], [id_componente], [cantidad_componente])
VALUES
    (1, 1, '10 g'),
    (1, 2, '5 g'),
    (2, 1, '10 mg'),
    (3, 1, '12 g'),
    (4, 2, '100 mg'),
    (5, 1, '100 ui'),
    (5, 2, '10 mg'),
    (6, 1, '10 g'),
    (7, 2, '100 ui'),
    (8, 1, '10 g'),
    (8, 2, '100 ui'),
    (9, 1, '10 g'),
    (10, 2, '200 mg'),
    (11, 1, '10 g'),
    (11, 2, '1 g'),
    (12, 1, '100 mg');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando fichas de pacientes.';
INSERT INTO dbo.ficha_ingreso
    ([id_paciente], [id_administrativo], [id_nivelurgencia], [fecha_ingreso], [hora_ingreso], [paciente_acompanado], [motivo_consulta], [descripcion_paciente])
VALUES
    (1, 1, 5, '2019-10-02', '08:00', 0, 'Dolor de guatita', 'Paciente con caña'),
    (2, 1, 3, '2019-10-02', '08:30', 1, 'Malestar general', 'Paciente con dolor de cabeza intenso.'),
    (3, 1, 1, '2019-10-02', '10:00', 1, 'Dolor de rodillas', 'Paciente con dolor extremo, pierde la conciencia.');
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando atenciones de pacientes.';
INSERT INTO dbo.atencion
    ([id_ficha], [id_especialidad], [id_medico], [fecha_atencion], [hora_atencion], [sintomas_detectados], [diagnostico], [requiere_reposo], [dias_reposo])
VALUES
    (1, 5, 3, '2019-10-02', '12:45', 'Estado etilico bajo', 'Sintomas de alcholismo.', 0, 0),
    (2, 5, 1, '2019-10-02', '09:50', 'Mareos y malestares neuralgicos', 'Embarazo de octillizos.', 1, 15),
    (3, 1, 2, '2019-10-02', '10:05', 'Dolor extremo de huesitos', 'Artritis reumatoide.', 1, 45);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'Agregando receta de medicamentos de la atencion.';
INSERT INTO dbo.receta_ATENCION
    ([id_atencion], [id_medicamento], [dosis_medicamento], [dias_medicacion])
VALUES
    (1, 12, '1 supositorio diario', 5),
    (1, 9, '1 comprimido cada 4 horas', 2),
    (2, 3, '1 pastilla cada 12 horas', 3),
    (3, 1, '1 comprimido cada 8 horas', 45),
    (3, 5, '1 comprimido cada 12 horas', 20),
    (3, 8, '1 comprimido cada 8 horas', 45);
GO

PRINT FORMAT(getdate(), 'dd/MM/yyyy HH:mm') + ' ' + 'creacion de base de datos ' + db_name() + ' finalizada.';
GO