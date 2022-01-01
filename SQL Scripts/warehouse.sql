/******  This script is created by Suresh Abeyweera on 2021-12-31    ******/
/******  All scripts in the sql file realted to actions realted to Data Warehouse DB    ******/



/****** 1 ******/
/******  Below Script is for creating the  [DWH_Project_Target] DB    ******/
/******  Skip running this if already DB is created    ******/

USE [master]
GO
CREATE DATABASE [DWH_Project_Target]
 
GO
USE [DWH_Project_Target]
GO

/****** 2 ******/
/******  Creation of the  Tables in the Data Warehouse Area    ******/
/****** 
2.1. In DWH environment relationship are not created.Done at the end
2.2. Get the required data table from Staging to DWH.
2.3. In each dimension except for the Dim Date SK is created to quick query puposes. SK is representing the Surrogate Key
2.4. Here Alternate Key is the same primary key represented in each table.
2.5. IDENTITY(1,1) is the way of implementing SK in integer Incremental order
2.6. Since no source file given to create the Date Dimension using SQL comprehensive date table is created.
2.7. Here the Dim Loan has been considered as a table whuch conist of columns SCD Type2. Hence start date and end date is includedin the DimLoan table


******/
/******  Skip running this if already Tables are created    ******/

/******  Create the DimClient  ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dimclient](
	   [client_SK]  [int] IDENTITY(1,1) NOT NULL,
	  [client_AlternateKey] [int]  NULL,
	  [gender] [nvarchar](50)  NULL,
      [birth_date] [date]  NULL,
      [district_id] [int]  NULL,
CONSTRAINT PK_Dimclient_client_SK PRIMARY KEY CLUSTERED (client_SK)
) ON [PRIMARY]

GO




/******  Create the DimLoan Table  ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dimloan](
		[loan_SK]  [int] IDENTITY(1,1) NOT NULL,
		[loan_AlternateKey] [int] NULL 
      ,[account_id] [int] NULL
      ,[date] [date] NULL
      ,[amount] [int] NULL
      ,[duration] [int] NULL
      ,[payments] [int] NULL
      ,[status] [nvarchar](50)
	  ,[start date] [date] NULL
	  , [end date] [date] NULL
	  ,CONSTRAINT PK_Dimloan_loan_SK PRIMARY KEY CLUSTERED (loan_SK)
) ON [PRIMARY]

GO

/****** Create the FactTrans Table  ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Facttrans](
		[trans_id] [int] NOT NULL ,
		[account_SK] [int] NULL,
	   [loan_SK] [int] NULL,
	   [client_SK] [int] NULL,
	   [date] [date] NULL
      ,[type] [nvarchar](50)
      ,[operation] [nvarchar](50)
      ,[amount] [int] NULL
      ,[balance] [int] NULL
      ,[k_symbol] [nvarchar](50)
      ,[bank] [nvarchar](50)
      ,[account] [nvarchar](50)
	  ,CONSTRAINT PK_Facttrans_trans_id PRIMARY KEY CLUSTERED (trans_id)
) ON [PRIMARY]

GO

/****** Create the Dimdate Table  ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dimdate](
	[DateKey] [int] NOT NULL,
	[FullDateAlternateKey] [date] NOT NULL,
	[DayNumberOfWeek] [tinyint] NOT NULL,
	[EnglishDayNameOfWeek] [nvarchar](10) NOT NULL,
	[DayNumberOfMonth] [tinyint] NOT NULL,
	[DayNumberOfYear] [smallint] NOT NULL,
	[WeekNumberOfYear] [tinyint] NOT NULL,
	[EnglishMonthName] [nvarchar](10) NOT NULL,
	[MonthNumberOfYear] [tinyint] NOT NULL,
	[CalendarQuarter] [tinyint] NOT NULL,
	[CalendarYear] [smallint] NOT NULL,
	[CalendarSemester] [tinyint] NOT NULL,
	[FiscalQuarter] [tinyint] NOT NULL,
	[FiscalYear] [smallint] NOT NULL,
	[FiscalSemester] [tinyint] NOT NULL,
 CONSTRAINT PK_DimDate_FullDateAlternateKey PRIMARY KEY CLUSTERED (FullDateAlternateKey)

) ON [PRIMARY]



/****** 3 ******/
/******  Creation of the  SQL procedures     ******/
/****** 
3.1. Procedures are a way to refresh and load values to Data Warehouse using SQL (Without gooing to SSIS)
3.2. Once the Procedures are created they are stored in the below location.

	SSMS > Relavant Database > Programmability > Stored Procedures

3.3. Created Procedures can be called from SSIS. See the SSIS.
3.4. Date Range for Dim Date is '1993-07-01' to '1998-12-31'
3.5. Procedures created here can be considered as SCD Type1.Because in the used procudures Dimension would only do the Overwrite if there is any change. Not keeping the history.
3.6. In DWH as a Practice we normally generate the Dimension first and then Produce the Fact.So amke sure you adhere this in SSIS.
******/

/******  Procedure [dbo].[Refresh_DimDate]     ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[Refresh_DimDate]
as
Begin

declare @startdate date = '1993-07-01',
    @enddate date = '1999-01-31'

IF @startdate IS NULL
    BEGIN
        Select Top 1 @startdate = FulldateAlternateKey
        From DimDate 
        Order By DateKey ASC 
    END

Declare @datelist table (FullDate date)

while @startdate <= @enddate

Begin 
    Insert into @datelist (FullDate)
    Select @startdate

    Set @startdate = dateadd(dd,1,@startdate)

end 

 Insert into dbo.DimDate 
    (DateKey, 
        FullDateAlternateKey, 
        DayNumberOfWeek, 
        EnglishDayNameOfWeek, 
      
        DayNumberOfMonth, 
        DayNumberOfYear, 
        WeekNumberOfYear, 
        EnglishMonthName, 
     
        MonthNumberOfYear, 
        CalendarQuarter, 
        CalendarYear, 
        CalendarSemester, 
        FiscalQuarter, 
        FiscalYear, 
        FiscalSemester)


select convert(int,convert(varchar,dl.FullDate,112)) as DateKey,
    dl.FullDate,
    datepart(dw,dl.FullDate) as DayNumberOfWeek,
    datename(weekday,dl.FullDate) as EnglishDayNameOfWeek,
    
    
    datepart(d,dl.FullDate) as DayNumberOfMonth,
    datepart(dy,dl.FullDate) as DayNumberOfYear,
    datepart(wk, dl.FUllDate) as WeekNumberOfYear,
    datename(MONTH,dl.FullDate) as EnglishMonthName,
   
   
    Month(dl.FullDate) as MonthNumberOfYear,
    datepart(qq, dl.FullDate) as CalendarQuarter,
    year(dl.FullDate) as CalendarYear,
    case datepart(qq, dl.FullDate)
        when 1 then 1
        when 2 then 1
        when 3 then 2
        when 4 then 2
    end as CalendarSemester,
    case datepart(qq, dl.FullDate)
        when 1 then 3
        when 2 then 4
        when 3 then 1
        when 4 then 2
    end as FiscalQuarter,
    case datepart(qq, dl.FullDate)
        when 1 then year(dl.FullDate)
        when 2 then year(dl.FullDate)
        when 3 then year(dl.FullDate) + 1
        when 4 then year(dl.FullDate) + 1
    end as FiscalYear,
    case datepart(qq, dl.FullDate)
        when 1 then 2
        when 2 then 2
        when 3 then 1
        when 4 then 1
    end as FiscalSemester

from @datelist dl left join 
    DimDate dd 
        on dl.FullDate = dd.FullDateAlternateKey
Where dd.FullDateAlternateKey is null 


End
GO


/******  Procedure [dbo].[Refresh_Dimclient]     ******/

/****** 
Create the Procedure to Load Client data to Warehouse from the Staging.
Ex -
Below code is for new record insertion for the Data Warehouse.
Imagine in Staging we have 7 and in DWH has 5.
It would add the new 2 Records
******/


Create Procedure [dbo].[Refresh_Dimclient]

as
begin


set nocount on 
Insert into [dbo].[Dimclient]

(
[client_AlternateKey]
,[gender]
,[birth_date]
,[district_id]
)


SELECT stg.[client_id]
,stg.[gender]
,stg.[birth_date]
,stg.[district_id]
        
  FROM [DWH_Project_Staging].[financial].[client] stg (nolock)
    left join [dbo].[Dimclient] Dim  (nolock)
  on stg.client_id = Dim.client_AlternateKey
    where Dim.client_AlternateKey is null

/****** 
Below code is for update the records
******/

  Update Dim

    Set Dim.[gender] = stg.gender,
	Dim.[birth_date] = stg.birth_date,
	Dim.[district_id] = stg.district_id
  from [dbo].[Dimclient] Dim  (nolock)
  inner join [DWH_Project_Staging].[financial].[client] stg  (nolock)
  on stg.client_id = Dim.client_AlternateKey


   set nocount off


end 
GO


/****** 4 ******/
/******  Creation of the  RelationShip     ******/
/******  Skip this if relationships are already created******/
USE [DWH_Project_Target]

ALTER TABLE dbo.Facttrans
WITH CHECK ADD  CONSTRAINT FK_loan_trans 
FOREIGN KEY (loan_SK) REFERENCES dbo.Dimloan(loan_SK) 
GO



ALTER TABLE dbo.Facttrans 
ADD CONSTRAINT FK_client_trans 
FOREIGN KEY (client_SK) REFERENCES dbo.Dimclient(client_SK) 
GO

ALTER TABLE dbo.Facttrans
WITH CHECK ADD  CONSTRAINT FK_date_trans 
FOREIGN KEY (date) REFERENCES dbo.DimDate(FullDateAlternateKey) 
GO

/****** Check later whether Accound Dimension also required - If so Database need to be created. Add a Procedure or Slowly Dimesnion SSIS package. Then make the relationship here
ALTER TABLE dbo.trans 
ADD CONSTRAINT FK_account_trans 
FOREIGN KEY (account_SK) REFERENCES dbo.account(account_SK) 
GO
******/


/****** 5 ******/
/******  See SSIS DWH project for the ETL Part     ******/

