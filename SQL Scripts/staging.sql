/******  This script is created by Suresh Abeyweera on 2021-12-31    ******/
/******  All scripts in the sql file realted to actions realted to Staging DB    ******/



/****** 1 ******/
/******  Below Script is for creating the  [DWH_Project_Staging] DB    ******/
/******  Skip running this if already DB is created    ******/
USE [master]
GO

CREATE DATABASE [DWH_Project_Staging]
 
GO
USE [DWH_Project_Staging]
GO


/****** 2 ******/
/******  Creation of the  Financial Schema    ******/
/******   
Create Seperate Schemas to distingusg that this data coming from financial ERP etc. 
If we have more data sources coming in ,we can make it from another schema
******/
/******  Skip running this if already DB is created    ******/
CREATE SCHEMA [financial]
GO


/****** 3 ******/
/******  Creation of the  Tables in the Staging Area    ******/
/****** 
3.1. In Staging environment relationship are not created.
3.2. Get the required data table from Source to Staging.
3.3. As a Tracking purposes SSIS track ID and created date columns are added in each table.

******/
/******  Skip running this if already Tables are created    ******/

/******   Create the Trans Table  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [financial].[trans](
		[trans_id] [int] NULL ,
		[account_id] [int] NULL,
	   [loan_id] [int] NULL,
	   [client_id] [int] NULL,
	   [date] [date] NULL
      ,[type] [nvarchar](50)
      ,[operation] [nvarchar](50)
      ,[amount] [int] NULL
      ,[balance] [int] NULL
      ,[k_symbol] [nvarchar](50)
      ,[bank] [nvarchar](50)
      ,[account] [nvarchar](50),
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]

GO

/******  Create the Client Table  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [financial].[client](
	   [client_id] [int] NULL 
	  ,[gender] [nvarchar](50)
      ,[birth_date] [date] NULL
      ,[district_id] [int] NULL
	  	,[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]

GO

/******  Create the Disp Table  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [financial].[disp](
	   [disp_id] [int] NOT NULL 
	  ,[client_id] [int] NOT NULL
      ,[account_id] [int] NOT NULL
      ,[type] [nvarchar](50) NULL
	  	,[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]

GO

/****** Create the Loan Table  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [financial].[loan](
		[loan_id] [int] NULL 
      ,[account_id] [int] NULL
      ,[date] [date] NULL
      ,[amount] [int] NULL
      ,[duration] [int] NULL
      ,[payments] [int] NULL
      ,[status] [nvarchar](50)
	  	,[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]

GO

/******  Create the Account Table  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [financial].[account](
	   [account_id] [int] NULL 
      ,[district_id] [int] NULL
      ,[frequency] [nvarchar](50)
      ,[date] [date] NULL
	  ,	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]

GO


/****** 4 ******/
/******  Once all the bulding blocks created relavant to the Staging ,Look into the SSIS Stafing packages    ******/
