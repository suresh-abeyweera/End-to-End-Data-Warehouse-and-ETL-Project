# End-to-End-Data-Warehouse-and-ETL-Project
Data Warehouse is a good skill for any data enthusiast. I learnt some Data Warehouse &amp; ETL concepts and did my own end to end Data warehouse model. I have used SQL server and SSIS as tools in the project.

I selected the below database for my Analysis, and it is a Data set from a bank about loan transactions which has over 1 million records.

https://relational.fit.cvut.cz/dataset/Financial

Err!. Challenge from the beginning. This is a MySQL DB and I badly needed to do this project using SQL server. Reason – I already had some knowledge about SQL server and needed to practicing SQL command at the same time doing end to end data warehouse implementation.

No problem. I was able to convert MySQL database to SQL server database from SQL server Migration Assistant for My SQL.

![image](https://user-images.githubusercontent.com/61721484/147851748-d2ef72b0-d7c1-4f03-b8a9-a888047ead42.png)

This repo contains the converted SQL server database (DWH Project-Source.bak)

Then next challenge was to go through the Data Base and understand what exactly meant by each column and tables. Since this project has no sponsor and no proper requirements drafted I myself has to understand what exactly data is about and what we can do for the data analysis.

For example different codes are used in the Tables as below.

![image](https://user-images.githubusercontent.com/61721484/147851777-6356415f-ef77-4288-9181-89d093270a22.png)

Below link provide structured explanation of the Columns/Tables/Design etc.
https://webpages.charlotte.edu/mirsad/itcs6265/group1/domain.html

Then comes the challenge of Data warehousing. Before jumping to any tools need to know what a data warehouse is and in real life what are the important concepts to consider in designing. I strongly recommend Analytics with Nags youtube channel for a Beginner. To be frank I noted that the contents around Data Warehouse is limited for a beginner who is planning to do an End-to-end project. For building this project I used below video as a Reference.

 https://www.youtube.com/watch?v=eNxbMwUGl1g
 
Before Starting the project my idea was to keep my DWH in cloud platform such as Azure Datawarehouse (Now rebranded as Azure Synapass Analytics) using the ETL tool of Data Factory. Since that learning curve is bit long I planned to hold that idea as a second step(Working on this) and start with SSIS as ETL tool and On prem SQL server DB as a Datawarehouse.

Now you are ready to do proceed the project.

First thing to do Import the Backup file (.bak) as the Source of the project. This is called as OLTP DB and typically this can be an ERP (Ex- In this case will think as an Production ERP Database.).

Use below link to know how to do the restoring a SQL server database DWH Project-Source.bak.

https://sqlbackupandftp.com/blog/restore-database-backup

Relationship Diagram for source database is as follows,

![image](https://user-images.githubusercontent.com/61721484/147851821-e8f100ee-68a7-4e8d-b47e-abf7a6fc7c17.png)

In a good Data Warehouse Modeling it is good to have a separate Staging Database. The staging area is mainly used to quickly extract data from its data sources, minimizing the impact of the sources. After data has been loaded into the staging area, the staging area is used to combine data from multiple data sources, transformations, validations, data cleansing.

So in the Project we are planning to have an Architecture like below.

![image](https://user-images.githubusercontent.com/61721484/147851835-ed1af38d-3876-48db-8b1d-0d47cff2f15d.png)

**Create the Staging Tables**

Run the above attached staging.sql file in SSMS and create the Staging tables. Here we get the required tables from the sourcing and do the slicing and dicing of the data as we need. 

![image](https://user-images.githubusercontent.com/61721484/147851853-d1c02ec2-8f09-47b0-a0ed-f0ec49ef8315.png)

I have created 2 SSIS projects. One for the data loading from Source DB to Staging. Other one is for data loading from Staging to Data Warehouse. 

Once Project is imported definitely you need to tweak all the packages with updating the database name etc. I have written a Control Package to run all the SSIS package to do all the ETL related activities at once. This is bit awkward as need to do some manual adjustments. For proper migration of SSIS package we need to do this project using SQL server Developer Edition etc. But still you can do the tweaking with in few time.

**Execute below SSIS Package**

![image](https://user-images.githubusercontent.com/61721484/147851886-746ad6f2-9616-4c82-99d3-e881acfa8b9c.png)

Now you can see the data has been loaded in the Staging environment.

**Create the Data warehouse using warehouse.sql**

Few things implemented in the Data Warehouse

1.	Used Star Schema to the DWH which will improve query performances
2.	Implemented surrogated Keys instead of provided business key. That will again improve the query performance.
3.	Implemented slowly changing dimension type 2 for Dim Loan to keep history of changes happening in the Status column etc.
4.	Created procedures for other Dimension to Refresh and insert records.(SCD type 1) 
5.	Incremental loading for Fact Trans table.

![image](https://user-images.githubusercontent.com/61721484/147851907-7706dcc6-3802-4f97-84fd-eb53cfe737e9.png)


**Load data to the Data Warehouse using SSIS Project.**

Use the provided SSIS project and to some tweaking of each packages (updating the database names etc.) and run the Control flow.

![image](https://user-images.githubusercontent.com/61721484/147851917-9a830576-9ad5-42c9-8ed4-43bd5c0224b6.png)

Now data warehouse is up and running. Next to connect power BI dashboard to the data warehouse in Get data option in Power BI.

![image](https://user-images.githubusercontent.com/61721484/147852035-36a629f6-e89e-496a-828a-1ce904fdcbb1.png)

**Enhancements for this project you can try.**

1.	Automation of the SSIS jobs.
2.	Can integrate some other sources as flat files etc. (Each district information about population, Average Income etc.)
3.	Can try changing the Primary keep format of source db with some prefix instead of Int. (Can understand the real use of the Surrogated Key).
4.	Try the same project in Azure Cloud with Data Factory.

I am working on the Power BI analysis part and Data warehouse further in this project and will update the GitHub repo soon.

Suggested readings – https://aatinegar.com/wp-content/uploads/2016/05/Kimball_The-Data-Warehouse-Toolkit-3rd-Edition.pdf

For any feedbacks contact me  suresh.abeyweera@gmail.com


