USE [master]
GO
/****** Object:  Database [Polyclinic]    Script Date: 27.11.2022 21:45:03 ******/
CREATE DATABASE [Polyclinic]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Polyclinic', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Polyclinic.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Polyclinic_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Polyclinic_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Polyclinic] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Polyclinic].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Polyclinic] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Polyclinic] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Polyclinic] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Polyclinic] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Polyclinic] SET ARITHABORT OFF 
GO
ALTER DATABASE [Polyclinic] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Polyclinic] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Polyclinic] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Polyclinic] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Polyclinic] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Polyclinic] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Polyclinic] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Polyclinic] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Polyclinic] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Polyclinic] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Polyclinic] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Polyclinic] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Polyclinic] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Polyclinic] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Polyclinic] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Polyclinic] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Polyclinic] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Polyclinic] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Polyclinic] SET  MULTI_USER 
GO
ALTER DATABASE [Polyclinic] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Polyclinic] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Polyclinic] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Polyclinic] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Polyclinic] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Polyclinic] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Polyclinic] SET QUERY_STORE = OFF
GO
USE [Polyclinic]
GO
/****** Object:  UserDefinedFunction [dbo].[CountSickInThisYear]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[CountSickInThisYear] (@MedicialCardId int)
RETURNS int
AS
BEGIN

	DECLARE @Result int

	SELECT @Result = Count(Sick.Id)
	From Sick INNER JOIN
            MedicalCard ON Sick.MedicalCardId = MedicalCard.Id	
			Where @MedicialCardId = MedicalCard.Id
	RETURN @Result

END
GO
/****** Object:  UserDefinedFunction [dbo].[DoctorSalatyAVG]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DoctorSalatyAVG] ()
RETURNS float
AS
BEGIN
	DECLARE @Result int
	SELECT @Result = AVG(Worker.Salary)
 From Doctor INNER JOIN
      Worker ON Doctor.Id = Worker.Id
	RETURN @Result
END
GO
/****** Object:  UserDefinedFunction [dbo].[NurseSalatyAVG]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[NurseSalatyAVG] ()
RETURNS float
AS
BEGIN

	DECLARE @Result int

	SELECT @Result = AVG(Worker.Salary)
 From Nurse INNER JOIN
                         Worker ON Nurse.Id = Worker.Id	RETURN @Result

END
GO
/****** Object:  Table [dbo].[Specialization]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Specialization](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
 CONSTRAINT [PK_Specialization] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Doctor]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctor](
	[Id] [int] NOT NULL,
	[SpecializationId] [int] NULL,
 CONSTRAINT [PK_Doctor] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Worker]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Worker](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FIO] [nvarchar](max) NULL,
	[Phone] [nvarchar](50) NULL,
	[Adress] [nvarchar](max) NULL,
	[DateEnployment] [datetime] NULL,
	[Salary] [money] NULL,
 CONSTRAINT [PK_Worker] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[DoctorView]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DoctorView]
AS
SELECT        dbo.Worker.Id, dbo.Worker.FIO, dbo.Worker.Phone, dbo.Worker.Adress, dbo.Specialization.Title, dbo.Worker.Salary
FROM            dbo.Doctor INNER JOIN
                         dbo.Specialization ON dbo.Doctor.SpecializationId = dbo.Specialization.Id INNER JOIN
                         dbo.Worker ON dbo.Doctor.Id = dbo.Worker.Id
GO
/****** Object:  Table [dbo].[Nurse]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Nurse](
	[Id] [int] NOT NULL,
	[Office] [int] NULL,
 CONSTRAINT [PK_Nurse] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[NurseView]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[NurseView]
AS
SELECT        dbo.Worker.Id, dbo.Worker.FIO, dbo.Nurse.Office, dbo.Worker.Phone, dbo.Worker.Adress, dbo.Worker.Salary
FROM            dbo.Nurse INNER JOIN
                         dbo.Worker ON dbo.Nurse.Id = dbo.Worker.Id
GO
/****** Object:  Table [dbo].[MedicalCard]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalCard](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FIO] [nvarchar](max) NULL,
	[Adress] [nvarchar](max) NULL,
	[Phone] [nvarchar](max) NULL,
 CONSTRAINT [PK_Patient] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[Patients]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Patients]
AS
SELECT        Id, FIO, Adress, Phone, dbo.CountSickInThisYear(Id) AS [Болел в этом году]
FROM            dbo.MedicalCard
GO
/****** Object:  Table [dbo].[Appointment]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Appointment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MedicalCardId] [int] NULL,
	[DoctorId] [int] NULL,
	[NurseId] [int] NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_Appointment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AppointmentView]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AppointmentView]
AS
SELECT        dbo.Appointment.Id, dbo.MedicalCard.FIO AS Пациент, dbo.Worker.FIO AS Врач, dbo.Nurse.Office AS Кабинет, dbo.Appointment.Date AS Дата
FROM            dbo.Appointment INNER JOIN
                         dbo.Doctor ON dbo.Appointment.DoctorId = dbo.Doctor.Id INNER JOIN
                         dbo.Nurse ON dbo.Appointment.NurseId = dbo.Nurse.Id INNER JOIN
                         dbo.MedicalCard ON dbo.Appointment.MedicalCardId = dbo.MedicalCard.Id INNER JOIN
                         dbo.Worker ON dbo.Doctor.Id = dbo.Worker.Id
GO
/****** Object:  Table [dbo].[Sick]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sick](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Number] [int] NULL,
	[DateStart] [datetime] NULL,
	[DateEnd] [datetime] NULL,
	[MedicalCardId] [int] NULL,
 CONSTRAINT [PK_Sick] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Appointment] ON 

INSERT [dbo].[Appointment] ([Id], [MedicalCardId], [DoctorId], [NurseId], [Date]) VALUES (1, 1, 6, 1, CAST(N'2022-03-15T12:00:00.000' AS DateTime))
INSERT [dbo].[Appointment] ([Id], [MedicalCardId], [DoctorId], [NurseId], [Date]) VALUES (2, 2, 8, 2, CAST(N'2022-03-19T14:45:00.000' AS DateTime))
INSERT [dbo].[Appointment] ([Id], [MedicalCardId], [DoctorId], [NurseId], [Date]) VALUES (3, 3, 8, 3, CAST(N'2022-03-29T17:00:00.000' AS DateTime))
INSERT [dbo].[Appointment] ([Id], [MedicalCardId], [DoctorId], [NurseId], [Date]) VALUES (4, 4, 9, 4, CAST(N'2022-03-13T00:00:00.000' AS DateTime))
INSERT [dbo].[Appointment] ([Id], [MedicalCardId], [DoctorId], [NurseId], [Date]) VALUES (5, 5, 10, 5, CAST(N'2022-03-24T00:00:00.000' AS DateTime))
INSERT [dbo].[Appointment] ([Id], [MedicalCardId], [DoctorId], [NurseId], [Date]) VALUES (6, 1, 6, 1, CAST(N'2022-05-14T00:00:00.000' AS DateTime))
INSERT [dbo].[Appointment] ([Id], [MedicalCardId], [DoctorId], [NurseId], [Date]) VALUES (8, 2, 12, 16, CAST(N'2022-10-20T13:40:00.000' AS DateTime))
INSERT [dbo].[Appointment] ([Id], [MedicalCardId], [DoctorId], [NurseId], [Date]) VALUES (10, 1, 14, 2, CAST(N'2022-11-06T13:40:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Appointment] OFF
GO
INSERT [dbo].[Doctor] ([Id], [SpecializationId]) VALUES (6, 1)
INSERT [dbo].[Doctor] ([Id], [SpecializationId]) VALUES (8, 3)
INSERT [dbo].[Doctor] ([Id], [SpecializationId]) VALUES (9, 4)
INSERT [dbo].[Doctor] ([Id], [SpecializationId]) VALUES (10, 5)
INSERT [dbo].[Doctor] ([Id], [SpecializationId]) VALUES (12, 1)
INSERT [dbo].[Doctor] ([Id], [SpecializationId]) VALUES (13, 3)
INSERT [dbo].[Doctor] ([Id], [SpecializationId]) VALUES (14, 2)
INSERT [dbo].[Doctor] ([Id], [SpecializationId]) VALUES (15, 1)
GO
SET IDENTITY_INSERT [dbo].[MedicalCard] ON 

INSERT [dbo].[MedicalCard] ([Id], [FIO], [Adress], [Phone]) VALUES (1, N'Криштофич Тарас Нифонтович', N'Россия, г. Петропавловск-Камчатский, Лесная ул., д. 8 кв.68', N'+7 (913) 439-21-38')
INSERT [dbo].[MedicalCard] ([Id], [FIO], [Adress], [Phone]) VALUES (2, N'Колбин Константин Афанасьевич', N'Россия, г. Шахты, Зеленая ул., д. 12 кв.205', N'+7 (915) 842-91-80')
INSERT [dbo].[MedicalCard] ([Id], [FIO], [Adress], [Phone]) VALUES (3, N'Ясина Сюзанна Ивановна', N'Россия, г. Мурманск, 3 Марта ул., д. 16 кв.197', N'+7 (945) 423-53-89')
INSERT [dbo].[MedicalCard] ([Id], [FIO], [Adress], [Phone]) VALUES (4, N'Барановский Иннокентий Константинович', N'Россия, г. Новочебоксарск, Мира ул., д. 17 кв.54', N'+7 (943) 270-87-69')
INSERT [dbo].[MedicalCard] ([Id], [FIO], [Adress], [Phone]) VALUES (5, N'Прибыльнова Анна Герасимовна', N'Россия, г. Новосибирск, Ленина ул., д. 8 кв.6', N'+7 (916) 337-66-96')
INSERT [dbo].[MedicalCard] ([Id], [FIO], [Adress], [Phone]) VALUES (6, N'Аникеева Лариса Гермоновна', N'Россия, г. Саратов, Коммунистическая ул., д. 18 кв', N'+7 (935) 884-80-58')
SET IDENTITY_INSERT [dbo].[MedicalCard] OFF
GO
INSERT [dbo].[Nurse] ([Id], [Office]) VALUES (1, 43)
INSERT [dbo].[Nurse] ([Id], [Office]) VALUES (2, 42)
INSERT [dbo].[Nurse] ([Id], [Office]) VALUES (3, 12)
INSERT [dbo].[Nurse] ([Id], [Office]) VALUES (4, 41)
INSERT [dbo].[Nurse] ([Id], [Office]) VALUES (5, 65)
INSERT [dbo].[Nurse] ([Id], [Office]) VALUES (16, 13)
GO
SET IDENTITY_INSERT [dbo].[Sick] ON 

INSERT [dbo].[Sick] ([Id], [Number], [DateStart], [DateEnd], [MedicalCardId]) VALUES (1, 5828713, CAST(N'2022-03-15T00:00:00.000' AS DateTime), CAST(N'2022-03-29T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[Sick] ([Id], [Number], [DateStart], [DateEnd], [MedicalCardId]) VALUES (3, 6473271, CAST(N'2022-03-29T00:00:00.000' AS DateTime), CAST(N'2022-04-12T00:00:00.000' AS DateTime), 3)
INSERT [dbo].[Sick] ([Id], [Number], [DateStart], [DateEnd], [MedicalCardId]) VALUES (4, 6424817, CAST(N'2022-03-13T00:00:00.000' AS DateTime), CAST(N'2022-03-27T00:00:00.000' AS DateTime), 4)
INSERT [dbo].[Sick] ([Id], [Number], [DateStart], [DateEnd], [MedicalCardId]) VALUES (5, 4620853, CAST(N'2022-03-24T00:00:00.000' AS DateTime), CAST(N'2022-04-08T00:00:00.000' AS DateTime), 5)
INSERT [dbo].[Sick] ([Id], [Number], [DateStart], [DateEnd], [MedicalCardId]) VALUES (11, 324123, CAST(N'2022-05-14T00:00:00.000' AS DateTime), CAST(N'2022-05-28T00:00:00.000' AS DateTime), 6)
INSERT [dbo].[Sick] ([Id], [Number], [DateStart], [DateEnd], [MedicalCardId]) VALUES (13, 1982396, CAST(N'2022-10-19T18:43:17.757' AS DateTime), CAST(N'2022-10-26T18:43:17.757' AS DateTime), 1)
INSERT [dbo].[Sick] ([Id], [Number], [DateStart], [DateEnd], [MedicalCardId]) VALUES (14, 8799184, CAST(N'2022-10-21T14:42:35.270' AS DateTime), CAST(N'2022-10-28T14:42:35.270' AS DateTime), 4)
SET IDENTITY_INSERT [dbo].[Sick] OFF
GO
SET IDENTITY_INSERT [dbo].[Specialization] ON 

INSERT [dbo].[Specialization] ([Id], [Title]) VALUES (1, N'Терапевт')
INSERT [dbo].[Specialization] ([Id], [Title]) VALUES (2, N'Окулист')
INSERT [dbo].[Specialization] ([Id], [Title]) VALUES (3, N'Хирург')
INSERT [dbo].[Specialization] ([Id], [Title]) VALUES (4, N'Эндокринолог')
INSERT [dbo].[Specialization] ([Id], [Title]) VALUES (5, N'Невролог')
INSERT [dbo].[Specialization] ([Id], [Title]) VALUES (6, N'Стоматолог')
INSERT [dbo].[Specialization] ([Id], [Title]) VALUES (7, N'Отоларинголог')
INSERT [dbo].[Specialization] ([Id], [Title]) VALUES (8, N'Аллерголог')
INSERT [dbo].[Specialization] ([Id], [Title]) VALUES (9, N'Гастроэнтеролог')
INSERT [dbo].[Specialization] ([Id], [Title]) VALUES (10, N'Гинеколог')
INSERT [dbo].[Specialization] ([Id], [Title]) VALUES (11, N'Уролог')
INSERT [dbo].[Specialization] ([Id], [Title]) VALUES (12, N'Иммунолог')
INSERT [dbo].[Specialization] ([Id], [Title]) VALUES (13, N'Дерматолог')
SET IDENTITY_INSERT [dbo].[Specialization] OFF
GO
SET IDENTITY_INSERT [dbo].[Worker] ON 

INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (1, N'Ульянина Арина Максимовна', N'+7 (981) 119-47-50', N'Россия, г. Саранск, Майская ул., д. 7 кв.145', CAST(N'2015-10-10T00:00:00.000' AS DateTime), 25000.0000)
INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (2, N'Пелёвина Таисия Феоктистовна', N'+7 (909) 465-72-15', N'Россия, г. Ангарск, Березовая ул., д. 3 кв.64', CAST(N'2018-07-12T00:00:00.000' AS DateTime), 25000.0000)
INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (3, N'Суружу Георгий Вячеславович', N'+7 (985) 481-44-32', N'Россия, г. Сочи, Заводская ул., д. 14 кв.108', CAST(N'2020-07-23T00:00:00.000' AS DateTime), 25000.0000)
INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (4, N'Локтионов Иван Петрович', N'+7 (954) 510-68-89', N'Россия, г. Красноярск, ЯнкиКупалы ул., д. 9 кв.172', CAST(N'2015-06-08T00:00:00.000' AS DateTime), 25000.0000)
INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (5, N'Рящина Сюзанна Гермоновна', N'+7 (914) 148-63-27', N'Россия, г. Балашиха, Красноармейская ул., д. 10 кв.26', CAST(N'2015-02-23T00:00:00.000' AS DateTime), 25000.0000)
INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (6, N'Митасова Ника Евгеньевна', N'+7 (989) 936-76-37', N'Россия, г. Владимир, Набережная ул., д. 21 кв.174', CAST(N'2019-05-15T00:00:00.000' AS DateTime), 35000.0000)
INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (8, N'Булдаков Георгий Дмитриевич', N'+7 (994) 860-25-16', N'Россия, г. Димитровград, Рабочая ул., д. 10 кв.158', CAST(N'2014-04-23T00:00:00.000' AS DateTime), 35000.0000)
INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (9, N'Гершельмана Анна Георгьевна', N'+7 (948) 850-63-82', N'Россия, г. Воронеж, Дзержинского ул., д. 24 кв.37', CAST(N'2019-07-27T00:00:00.000' AS DateTime), 35000.0000)
INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (10, N'Бакшаева Рада Саввановна', N'+7 (945) 615-67-24', N'Россия, г. Прокопьевск, Ленина ул., д. 7 кв.134', CAST(N'2021-01-26T00:00:00.000' AS DateTime), 35000.0000)
INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (12, N'Кондратьев Александр Михайлович', N'+7 (923) 866-57-18', N'Россия, г. Реутов, Белорусская ул., д. 17 кв.150', CAST(N'2017-04-20T00:00:00.000' AS DateTime), 40000.0000)
INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (13, N'Петров Даниил Александрович', N'+7 (965) 269-54-99', N'Россия, г. Пятигорск, Полевая ул., д. 23 кв.115', CAST(N'2012-05-07T00:00:00.000' AS DateTime), 40000.0000)
INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (14, N'Петров Даниил Александрович', N'+7 (965) 269-54-99', N'Россия, г. Пятигорск, Полевая ул., д. 23 кв.115', CAST(N'2012-05-07T00:00:00.000' AS DateTime), 40000.0000)
INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (15, N'Потапкин Павел Александрович', N'+7 (990) 323-32-32', N'Россия, г. Тула, Луговая ул., д. 2 кв.208', CAST(N'2016-03-21T00:00:00.000' AS DateTime), 34000.0000)
INSERT [dbo].[Worker] ([Id], [FIO], [Phone], [Adress], [DateEnployment], [Salary]) VALUES (16, N'Колтышева Алена Герасимовна', N'+7 (924) 809-92-15', N'Россия, г. Новомосковск, Лесной пер., д. 3 кв.150', CAST(N'2012-06-11T00:00:00.000' AS DateTime), 24000.0000)
SET IDENTITY_INSERT [dbo].[Worker] OFF
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Doctor] FOREIGN KEY([DoctorId])
REFERENCES [dbo].[Doctor] ([Id])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Doctor]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_MedicalCard] FOREIGN KEY([MedicalCardId])
REFERENCES [dbo].[MedicalCard] ([Id])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_MedicalCard]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Nurse] FOREIGN KEY([NurseId])
REFERENCES [dbo].[Nurse] ([Id])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Nurse]
GO
ALTER TABLE [dbo].[Doctor]  WITH CHECK ADD  CONSTRAINT [FK_Doctor_Specialization] FOREIGN KEY([SpecializationId])
REFERENCES [dbo].[Specialization] ([Id])
GO
ALTER TABLE [dbo].[Doctor] CHECK CONSTRAINT [FK_Doctor_Specialization]
GO
ALTER TABLE [dbo].[Doctor]  WITH CHECK ADD  CONSTRAINT [FK_Doctor_Worker] FOREIGN KEY([Id])
REFERENCES [dbo].[Worker] ([Id])
GO
ALTER TABLE [dbo].[Doctor] CHECK CONSTRAINT [FK_Doctor_Worker]
GO
ALTER TABLE [dbo].[Nurse]  WITH CHECK ADD  CONSTRAINT [FK_Nurse_Worker] FOREIGN KEY([Id])
REFERENCES [dbo].[Worker] ([Id])
GO
ALTER TABLE [dbo].[Nurse] CHECK CONSTRAINT [FK_Nurse_Worker]
GO
ALTER TABLE [dbo].[Sick]  WITH CHECK ADD  CONSTRAINT [FK_Sick_MedicalCard] FOREIGN KEY([MedicalCardId])
REFERENCES [dbo].[MedicalCard] ([Id])
GO
ALTER TABLE [dbo].[Sick] CHECK CONSTRAINT [FK_Sick_MedicalCard]
GO
/****** Object:  StoredProcedure [dbo].[AddAppoinment]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[AddAppoinment]
	
	
	@MedicialCardId int,
	@DoctorId int,
	@NurseId int,
	@Date datetime
	AS
BEGIN
	Insert into Appointment(MedicalCardId, DoctorId, NurseId, Date) Values (@MedicialCardId, @DoctorId, @NurseId, @Date)
	Return  SELECT MAX(Id) FROM Sick
END
GO
/****** Object:  StoredProcedure [dbo].[AddDoctor]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[AddDoctor]
	@FIO nvarchar(MAX),
	@Phone nvarchar(50),
	@Adress nvarchar(MAX),
	@DateEnployment datetime,
	@Salary money,
	@SpecializationId int
	AS
BEGIN
	Insert into Worker(FIO, Phone, Adress, DateEnployment, Salary) 
	Values (@FIO, @Phone, @Adress, @DateEnployment, @Salary)
	Declare @Id int
	SELECT @Id = MAX(Id) FROM Worker
	Insert into Doctor(Id, SpecializationId) Values (@Id, @SpecializationId)
	Return @Id 
END
GO
/****** Object:  StoredProcedure [dbo].[AddNurse]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[AddNurse]
	
	
	@FIO nvarchar(MAX),
	@Phone nvarchar(50),
	@Adress nvarchar(MAX),
	@DateEnployment datetime,
	@Salary money,
	@Office int
	AS
BEGIN
	Insert into Worker(FIO, Phone, Adress, DateEnployment, Salary) Values (@FIO, @Phone, @Adress, @DateEnployment, @Salary)
	Declare @Id int
	SELECT @Id = MAX(Id) FROM Worker
	Insert into Nurse(Id, Office) Values (@Id, @Office)
	Return @Id 
END
GO
/****** Object:  StoredProcedure [dbo].[AddPatient]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[AddPatient]
	
	@FIO nvarchar(50),
	@Adress nvarchar(50),
	@Phone nvarchar(50)
	AS
BEGIN
	Insert into MedicalCard(FIO, Adress, Phone) Values (@FIO, @Adress, @Phone)
	Return  SELECT MAX(Id) FROM MedicalCard
END
GO
/****** Object:  StoredProcedure [dbo].[AddSick]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[AddSick]
	
	
	@Number int,
	@DateStart datetime,
	@DateEnd datetime,
	@MedicialCardId int
	AS
BEGIN
	Insert into Sick(Number, DateStart, DateEnd, MedicalCardId) Values (@Number, @DateStart, @DateEnd, @MedicialCardId)
	Return  SELECT MAX(Id) FROM Sick
END
GO
/****** Object:  StoredProcedure [dbo].[DoctorAppointment]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[DoctorAppointment]
	@DoctorId int,
	@Date datetime
AS
BEGIN
	SELECT        dbo.Appointment.Id, dbo.MedicalCard.FIO AS Пациент, dbo.Worker.FIO AS Врач, dbo.Nurse.Office AS Кабинет, dbo.Appointment.Date AS Дата
	FROM            dbo.Appointment INNER JOIN
                         dbo.Doctor ON dbo.Appointment.DoctorId = dbo.Doctor.Id INNER JOIN
                         dbo.Nurse ON dbo.Appointment.NurseId = dbo.Nurse.Id INNER JOIN
                         dbo.MedicalCard ON dbo.Appointment.MedicalCardId = dbo.MedicalCard.Id INNER JOIN
                         dbo.Worker ON dbo.Doctor.Id = dbo.Worker.Id
	Where Doctor.Id = @DoctorId AND Appointment.Date = @Date
END
GO
/****** Object:  StoredProcedure [dbo].[PatientAppointment]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[PatientAppointment]
	@PatientId int
AS
BEGIN
	SELECT        dbo.Appointment.Id, dbo.MedicalCard.FIO AS Пациент, dbo.Worker.FIO AS Врач, dbo.Nurse.Office AS Кабинет, dbo.Appointment.Date AS Дата
	FROM            dbo.Appointment INNER JOIN
                         dbo.Doctor ON dbo.Appointment.DoctorId = dbo.Doctor.Id INNER JOIN
                         dbo.Nurse ON dbo.Appointment.NurseId = dbo.Nurse.Id INNER JOIN
                         dbo.MedicalCard ON dbo.Appointment.MedicalCardId = dbo.MedicalCard.Id INNER JOIN
                         dbo.Worker ON dbo.Doctor.Id = dbo.Worker.Id
	Where MedicalCard.Id = @PatientId
END
GO
/****** Object:  StoredProcedure [dbo].[PatientSick]    Script Date: 27.11.2022 21:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[PatientSick]
	@SickNumber int
AS
BEGIN
	SELECT      Sick.Number as Номер, MedicalCard.FIO as [ФИО заболевшего], Sick.DateStart as [Дата начала], Sick.DateEnd as [Дата окончания]
	FROM            dbo.MedicalCard inner join dbo.Sick on MedicalCard.Id = Sick.MedicalCardId
	Where @SickNumber = Sick.Number
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Appointment"
            Begin Extent = 
               Top = 32
               Left = 302
               Bottom = 162
               Right = 476
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Doctor"
            Begin Extent = 
               Top = 0
               Left = 556
               Bottom = 96
               Right = 730
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Nurse"
            Begin Extent = 
               Top = 121
               Left = 556
               Bottom = 217
               Right = 730
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MedicalCard"
            Begin Extent = 
               Top = 44
               Left = 67
               Bottom = 174
               Right = 241
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Worker"
            Begin Extent = 
               Top = 6
               Left = 886
               Bottom = 136
               Right = 1063
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AppointmentView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AppointmentView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AppointmentView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Doctor"
            Begin Extent = 
               Top = 112
               Left = 294
               Bottom = 208
               Right = 468
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Specialization"
            Begin Extent = 
               Top = 109
               Left = 532
               Bottom = 205
               Right = 706
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Worker"
            Begin Extent = 
               Top = 109
               Left = 79
               Bottom = 239
               Right = 256
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DoctorView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DoctorView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Nurse"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 102
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Worker"
            Begin Extent = 
               Top = 6
               Left = 250
               Bottom = 136
               Right = 427
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'NurseView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'NurseView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MedicalCard"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 171
               Right = 235
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Patients'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Patients'
GO
USE [master]
GO
ALTER DATABASE [Polyclinic] SET  READ_WRITE 
GO
