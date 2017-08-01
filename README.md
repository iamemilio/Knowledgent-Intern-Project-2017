# Knowledgent-Intern-Project-2017

## Components
1. [Environment Setup](https://github.com/iamemilio/Knowledgent-Intern-Project-2017#environment-setup)
2. [Ingestion Tool](https://github.com/iamemilio/Knowledgent-Intern-Project-2017#ingestion-tool)
3. [Sample Data Cleansing](https://github.com/iamemilio/Knowledgent-Intern-Project-2017#sample-data-cleansing)
4. [Tableau Visualizations](https://github.com/iamemilio/Knowledgent-Intern-Project-2017#sample-tableau-visualizations)
5. [Project Timeline](Timeline_1.pdf)


## Data Sources
To learn more about the datat sourcese, please go to this google doc that clearly outlines what column definitions and data granularity.
https://docs.google.com/spreadsheets/d/1h4C55lwemSvEzmXvHUZBEKVqTp9AtJdrd5tfSyV2w2g/edit#gid=0

 
 
 ## Environment Setup
   The software was designed and tested in the Cloudera Quickstart VM with a specific set of data. **It is intended to be run from a terminal in a Cloudera Hadoop Edge Node**. Running it in environments other than this could result in unexpected bugs and errors. In order to run this software, you will need python 3. A script called [centos-setup.sh](./centos-setup.sh) is included to help you install python 3.4 if you dont already have it. To run centos-setup, you must be root. The following commands will get your environment set up: 
   
   ```Shell
   git clone https://github.com/iamemilio/Knowledgent-Intern-Project-2017.git
   cd Knowledgent-Intern-Project-2017 
   sudo bash centos-setup.sh
   ```
   
 
 ## Ingestion Tool
 
 ### Using Sample Data
   I developed a crude ingestion tool to automatically create a raw-zone in HDFS and Hive. In the repo's current state, the framework is pre-configured to work with the sample data in the [raw-data](automated-data-aggregation/raw-data) directory. Note that running this script will create directories in HDFS and in the home directory of the edge node you run it in. 
   If you would like to run this code with the sample data, you dont need to make any changes to anything. Just run [`bash load-hive-tables.sh`](./load-hive-tables.sh), and follow the prompts. **Do not run this script as root!** If you make an error, exiting with `ctrlc` should not cause any problems. 
   
 ### Guide to the Prompts:
 
 1. Are you using an existing database? (y | n)
     1. `y`: Data will be loaded into a database that already exists
         1. Enter the name of the database you want to use:
             - If the database exists, a raw-zone in your hdfs user directory will be created under the database name you provided, and raw tables will be added to the specified hive database
             - If the datatabase provided does not exist the program will fail, but the raw-zone in hdfs will still be created and populated
     2. `n`: A new database will be created for this data
         1. Enter a name for the new database: 
             - A raw zone in your hdfs user will be created under the database name given, a hive database will be created with the entered name
 2. Do you want to use hive, beeline:
     1. `hive`: the script will attempt to execute code using the Hive CLI
     2. `beeline`: the script will attempt to use the beeline CLI
         - You will be prompted to enter your jdbc string. Please use the following formatting:
         
         `jdbc:hive2://<host>:<port>`
         - Disclaimer: This has not been properly tested and will likely be buggy!
 
 ### Using Your Own Data
 
   If your intend to use your own data with the ingestion tool, the framework was designed to be able to use either locally stored data, or to download data directly from a link. In order to do this correctly however, there are two essential files that you will have to manipulate: data-sources.csv and types.csv. These tables store essential information that the system uses to process your data, and must be filled out correctly, since they both rely on each other, and will ultimiately cause your script to fail if neglected. 
 ### [data-sources.csv](automated-data-aggregation/data-sources.csv)
   This table is where you should start. It indexes all the data sources that you are aggregating, and it keeps track of important aspects of the table, such as where the header row is, the url you intend to download it from, etc. The columns are as follows:
 
 | index | filename | url | delimiter | header row |
 | :---: | :---: | :---: | :---: | :---: |
 | 0 | sample.txt | www.sample-url.com | comma | 0 |
 
 *Index* is index of the row in the types table that the information for this data set is stored. The first index is zero. *Filename* is what you want the file to be named when it gets put into the raw-data folder. However, there is more to it than just that! The next field is *URL*, which is the address that the data can be directly downloaded from. If you intend to download a data set, this obviously has to be filled out, however, the program will check the raw-data folder to see if a data set with the given *Filename* already exists. If it does, then the data set will not be downloaded and be assumed to be the one in the raw-data folder. Lastly, if *URL* is left blank, it will also not attempt to download anything. The *delimiter* field should be used to specify the delimiter for the data file. This is read literally, so if the textfile is delimited with pipes, type `|`. Since this is a comma seperated document, if your data file is delimited by commas, then `comma` or `c` are acceptable inputs. Finally, the *header row* is just the row in the data file that the header column is on. It assumes the first row of data is after the header row specified.
 
 The second table is *types.csv*, which is used to store the hive data types for the columns of the tables you are entering into hive. In the row indicated by the *index* field in the data-sources table, fill in the types of the columns from left to right starting in the zero row. 

For example, using the sources table above, assume you have a table called sample with the following schema:
id: *long*, name: *string*, phone: *string*, purchase: *string*, date: *date*

### Data-Sources
 | index | filename | url | delimiter | header row |
 | :---: | :---: | :---: | :---: | :---: |
 | 0 | sample.txt | www.sample-url.com | comma | 0 |
 
### Types
 | long | string | string | string | date |
 | :---: | :---: | :---: | :---: | :---: |
 |      |        |        |        |      |
 
 If you choose to edit these tables in microsoft excel, make sure to check the characters before running it because it does not encode in standard Unicode formatting, and can cause errors when its read. A text editor like notepad++ is probably the best way to check for this.
 
 
 

## Sample Data Cleansing
 For the most part this data was fairly clean. Most of my cleansing was focused on coarse grained cleansing, such as removing stray quotation marks. There are a few scripts in here that an be used depending on what you want. *join.hql* is an inner join on all the school level tables in the data lake. If you want an outer join, then use *outerJoin.hql*. For tables that only have district information, they are joined and cleansed in the *district_finance_join.hql* table. These scripts both cleanse and join the tables into tableau ready formats.

To run these scripts, copy and paste them into Hue, or ssh into an edge node and use the command 

```hive -f join.hql```



## Sample Tableau Visualizations
In coordination with the project [timeline](Timeline_1.pdf), here are the visualizations I created. The fourth iteration is not in the timeline since it was technically just a redo of the third iteration and I consider it to be the true final 3rd iteration product.

[Iteration 1](https://public.tableau.com/profile/emilio.garcia4319#!/vizhome/MassSchoolData/EffectOfEducationQualityonHigherEducationProspects)

[Iteration 2](https://public.tableau.com/profile/emilio.garcia4319#!/vizhome/MassachusettsPublicSchoolDataRound2/GraduationandHigherEd)

[Iteration 3](https://public.tableau.com/profile/emilio.garcia4319#!/vizhome/MassSchoolandFinancialData/FinancialTelltales)

[Iteration 4](https://public.tableau.com/profile/emilio.garcia4319#!/vizhome/2014MassPublicSchoolData/Dashboard1?publish=yes)
