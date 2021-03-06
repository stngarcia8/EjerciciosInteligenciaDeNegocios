USE [CallCenter]
GO
IF  EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[hLlamada]') AND type IN (N'U'))
ALTER TABLE [dbo].[hLlamada] DROP CONSTRAINT IF EXISTS [hechos_tipoLlamada_fk]
GO
IF  EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[hLlamada]') AND type IN (N'U'))
ALTER TABLE [dbo].[hLlamada] DROP CONSTRAINT IF EXISTS [hechos_resultados_fk]
GO
IF  EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[hLlamada]') AND type IN (N'U'))
ALTER TABLE [dbo].[hLlamada] DROP CONSTRAINT IF EXISTS [hechos_hora_fk]
GO
IF  EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[hLlamada]') AND type IN (N'U'))
ALTER TABLE [dbo].[hLlamada] DROP CONSTRAINT IF EXISTS [hechos_fecha_fk]
GO
IF  EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[hLlamada]') AND type IN (N'U'))
ALTER TABLE [dbo].[hLlamada] DROP CONSTRAINT IF EXISTS [hechos_agente_fk]
GO
/****** Object:  Table [dbo].[hLlamada]    Script Date: 28-08-2019 2:44:18 ******/
DROP TABLE IF EXISTS [dbo].[hLlamada]
GO
/****** Object:  Table [dbo].[dTipoLlamada]    Script Date: 28-08-2019 2:44:18 ******/
DROP TABLE IF EXISTS [dbo].[dTipoLlamada]
GO
/****** Object:  Table [dbo].[dResultadoLlamada]    Script Date: 28-08-2019 2:44:18 ******/
DROP TABLE IF EXISTS [dbo].[dResultadoLlamada]
GO
/****** Object:  Table [dbo].[dHora]    Script Date: 28-08-2019 2:44:18 ******/
DROP TABLE IF EXISTS [dbo].[dHora]
GO
/****** Object:  Table [dbo].[dFecha]    Script Date: 28-08-2019 2:44:18 ******/
DROP TABLE IF EXISTS [dbo].[dFecha]
GO
/****** Object:  Table [dbo].[dAgente]    Script Date: 28-08-2019 2:44:18 ******/
DROP TABLE IF EXISTS [dbo].[dAgente]
GO
USE [master]
GO
/****** Object:  Database [CallCenter]    Script Date: 28-08-2019 2:44:18 ******/
DROP DATABASE IF EXISTS [CallCenter]
GO
/****** Object:  Database [CallCenter]    Script Date: 28-08-2019 2:44:18 ******/
CREATE DATABASE [CallCenter]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CallCenter', FILENAME = N'/var/opt/mssql/data/CallCenter.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CallCenter_log', FILENAME = N'/var/opt/mssql/data/CallCenter_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [CallCenter] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
BEGIN
	EXEC [CallCenter].[dbo].[sp_fulltext_database] @action = 'enable'
END
GO
ALTER DATABASE [CallCenter] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CallCenter] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CallCenter] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CallCenter] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CallCenter] SET ARITHABORT OFF 
GO
ALTER DATABASE [CallCenter] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CallCenter] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CallCenter] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CallCenter] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CallCenter] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CallCenter] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CallCenter] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CallCenter] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CallCenter] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CallCenter] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CallCenter] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CallCenter] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CallCenter] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CallCenter] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CallCenter] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CallCenter] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CallCenter] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CallCenter] SET RECOVERY FULL 
GO
ALTER DATABASE [CallCenter] SET  MULTI_USER 
GO
ALTER DATABASE [CallCenter] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CallCenter] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CallCenter] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CallCenter] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CallCenter] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'CallCenter', N'ON'
GO
ALTER DATABASE [CallCenter] SET QUERY_STORE = OFF
GO
USE [CallCenter]
GO
GRANT VIEW ANY COLUMN ENCRYPTION KEY DEFINITION TO [public] AS [dbo]
GO
GRANT VIEW ANY COLUMN MASTER KEY DEFINITION TO [public] AS [dbo]
GO
/****** Object:  Table [dbo].[dAgente]    Script Date: 28-08-2019 2:44:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dAgente]
(
	[idAgente] [SMALLINT]     NOT NULL,
	[agente]   [NVARCHAR](50) NOT NULL,
	CONSTRAINT [PK__agente__F7F25B739783CE95] PRIMARY KEY CLUSTERED 
(
	[idAgente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dFecha]    Script Date: 28-08-2019 2:44:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dFecha]
(
	[idFecha]   [INT]          NOT NULL,
	[año]       [SMALLINT]     NOT NULL,
	[mes]       [NVARCHAR](50) NOT NULL,
	[diaSemana] [NVARCHAR](50) NOT NULL,
	[dia]       [SMALLINT]     NULL,
	CONSTRAINT [PK__fecha__65F2E869E2DA7D1D] PRIMARY KEY CLUSTERED 
(
	[idFecha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dHora]    Script Date: 28-08-2019 2:44:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dHora]
(
	[idHora]  [INT]          NOT NULL,
	[hora]    [TIME](7)      NOT NULL,
	[jornada] [NVARCHAR](20) NOT NULL,
	CONSTRAINT [PK__hora__770403DB6F9D030E] PRIMARY KEY CLUSTERED 
(
	[idHora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dResultadoLlamada]    Script Date: 28-08-2019 2:44:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dResultadoLlamada]
(
	[idResultadoLlamada] [TINYINT]      NOT NULL,
	[ResultadoLlamada]   [NVARCHAR](30) NOT NULL,
	CONSTRAINT [PK__TipoResu__F68E9A594648FA42] PRIMARY KEY CLUSTERED 
(
	[idResultadoLlamada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dTipoLlamada]    Script Date: 28-08-2019 2:44:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dTipoLlamada]
(
	[idTipoLlamada] [TINYINT]      NOT NULL,
	[tipoLlamada]   [NVARCHAR](50) NOT NULL,
	CONSTRAINT [PK__TipoLlam__F155C3D19EEAF620] PRIMARY KEY CLUSTERED 
(
	[idTipoLlamada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hLlamada]    Script Date: 28-08-2019 2:44:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hLlamada]
(
	[idFecha]               [INT]      NULL,
	[idHora]                [INT]      NULL,
	[idAgente]              [SMALLINT] NULL,
	[idTipoLlamada]         [TINYINT]  NULL,
	[idResultadoLlamada]    [TINYINT]  NULL,
	[satisfaccionEspera]    [SMALLINT] NOT NULL,
	[satisfaccionAtencion]  [SMALLINT] NOT NULL,
	[satisfaccionRespuesta] [SMALLINT] NOT NULL,
	[tiempoHablado]         [SMALLINT] NOT NULL,
	[tiempoEspera]          [SMALLINT] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[hLlamada]  WITH CHECK ADD  CONSTRAINT [hechos_agente_fk] FOREIGN KEY([idAgente])
REFERENCES [dbo].[dAgente] ([idAgente])
GO
ALTER TABLE [dbo].[hLlamada] CHECK CONSTRAINT [hechos_agente_fk]
GO
ALTER TABLE [dbo].[hLlamada]  WITH CHECK ADD  CONSTRAINT [hechos_fecha_fk] FOREIGN KEY([idFecha])
REFERENCES [dbo].[dFecha] ([idFecha])
GO
ALTER TABLE [dbo].[hLlamada] CHECK CONSTRAINT [hechos_fecha_fk]
GO
ALTER TABLE [dbo].[hLlamada]  WITH CHECK ADD  CONSTRAINT [hechos_hora_fk] FOREIGN KEY([idHora])
REFERENCES [dbo].[dHora] ([idHora])
GO
ALTER TABLE [dbo].[hLlamada] CHECK CONSTRAINT [hechos_hora_fk]
GO
ALTER TABLE [dbo].[hLlamada]  WITH CHECK ADD  CONSTRAINT [hechos_resultados_fk] FOREIGN KEY([idResultadoLlamada])
REFERENCES [dbo].[dResultadoLlamada] ([idResultadoLlamada])
GO
ALTER TABLE [dbo].[hLlamada] CHECK CONSTRAINT [hechos_resultados_fk]
GO
ALTER TABLE [dbo].[hLlamada]  WITH CHECK ADD  CONSTRAINT [hechos_tipoLlamada_fk] FOREIGN KEY([idTipoLlamada])
REFERENCES [dbo].[dTipoLlamada] ([idTipoLlamada])
GO
ALTER TABLE [dbo].[hLlamada] CHECK CONSTRAINT [hechos_tipoLlamada_fk]
GO
USE [master]
GO
ALTER DATABASE [CallCenter] SET  READ_WRITE 
GO
