This project is authored by: Braedon Williams, Megan Naylor & Dana Cavanagh

This is an SQL database focusing on crime in the United States.
Our data can be found here: https://cde.ucr.cjis.gov/LATEST/webapp/#/pages/downloads
Everything in the dataset is accurate to the data source, EXCEPT the offender names are randomly generated.

Because our project required a large amount of data insertion, we decided to create a python script to parse
the data directly from the source into an SQL file full of data insertions. For each of the 50 states we have
between 20 and 300 offenders. We did not insert data for other areas like "Federal" or "Canal Zone" even though
these are in the data set. 


Setting up the database:
- The database is called "usa_crime"
- Insert the data files in the following order:
-- schema.sql 
-- insertCrimes.sql
-- insertStates.sql
-- insertData.sql
-- procedures.sql
-- functions.sql