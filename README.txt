This project is authored by: Braedon Williams, Megan Naylor & Dana Cavanagh

This is an SQL database focusing on crime in the United States.
Our dataset can be found here: ##FIXME



Setting up the database: (recap of class2 + order of operations)
Step 1: make sure you have a postgres account (ex: 'abc' with password 'abcd'). See class 2.
Step 1: use command "sudo -u postgres psql"      -- this will log into the postgres account.
Step 2: use command "CREATE DATABASE usa_crime;" -- this creates the empty database.
Step 3: use "\l" to confirm the database was created.
Step 4: exit the prompt with '\q'.
Step 5: use "cd" to navigate to the location of your sql files (Project_1_350).
Step 6: use "psql -U <USERNAME> -d usa_crime -h localhost" --this logs into the database using your user account. It will prompt for your password.
Step 7:  "\i schema.sql"       -- sets up the database schema
Step 8:  "\i insertCrimes.sql" -- inserts data into Crime table.
Step 9:  "\i insertStates.sql" -- inserts data into State table.
Step 10: "\i insertData.sql"   -- inserts the rest of the data. This may take a while.
Step 11: "\i procedures.sql"   -- inserts the procedures.

Now the database is set up with everything we have so far.

Step 12: "quit;" to exit the psql prompt. 
Step 13: type "pgadmin4" into your terminal to open pgadmin4
Step 14: under "databases" you should see "usa_crime" (DM me if that is not the case, and i can help with setup! :] )