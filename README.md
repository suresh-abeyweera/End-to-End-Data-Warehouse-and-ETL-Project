# End-to-End-Data-Warehouse-and-ETL-Project
Data Warehouse is a good skill for any data enthusiast. I learnt some Data Warehouse &amp; ETL concepts and did my own end to end Data warehouse model. I have used SQL server and SSIS as tools in the project.

I selected the below database for my Analysis, and it is a Data set from a bank about loan transactions.

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



