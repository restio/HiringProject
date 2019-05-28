USE [testing]

GO

CREATE TABLE [dbo].[emails](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[email] [varchar](500) NULL,
	[primary] [int] NULL,
	[date] [datetime] NULL,
)

GO

CREATE TABLE [dbo].[usage_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[sessionId] [int] NULL,
	[login] [datetime] NULL,
	[logout] [datetime] NULL,
)

GO

CREATE TABLE [dbo].[user_admin](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NOT NULL,
)

GO

CREATE TABLE [dbo].[users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fName] [varchar](500) NULL,
	[lName] [varchar](500) NULL,
	[age] [bigint] NULL,
	[date] [datetime] NULL
)

GO
