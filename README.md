# qversity-data-2026-cali-victorvalencia
Qversity's final challenge



About Me
My name is Victor Valencia, i'm a system engineer student from the Universidad del Valle 


How to run the pipeline
prerequisites:
Docker installed and running
PowerBI
Python 3.11 or superior
Environment setup:
You need to create an .env file with the values specified inside the env.example file
How to star the program:
Once you have docker running, run the following command in the terminal
docker compose up -d --build
Now wait for the containers to be ready
Running the airflow DAGs
Go to your browser and enter in this URL
localhost:8080
login using the airflow default credentials
user:
admin
password:
admin
Once you login succesfully, you will see three separate DAGs
qversity_dag
This is the main DAG, This is the main DAG that runs the whole pipeline, it follows this task order
1. 
    Download the .json file to the local directory from the S3 server
2. 
    It's a senser that check if the file exist in the directory, if exists, the DAG continue
3. load_to_postgres_bronze
    Create a new schema and table called bronze and raw_fintech_data respectively in the database, 
    then save the raw records from the .json file in the new schema and table
4. bronze_to_silver
    Run a spark script that parse the raw records and convert them into a relational model (stg_customer), 
    then extract the transactions, accounts and loans columns, which are nested array columns, and flatten each one to put them on new tables staging tables
5. silver_to_gold
    Run the dbt run command to flatten nested objects digital_engagement and credit_info columns and normalize values and tables across all silver tables,
    then creates the main fact and dimension tables and create data marts for further analysis in PowerBI,
    have in mind that this DAG runs automatically when you run the containers for the first time

dbt_only_dag
This DAG only runs the fifth task from the qversity DAG to avoid creating new duplicated records on the raw_fintech_data table; Use it only in development

Architecture

Layers
Bronze
This is where the raw data exists, the data is ingested from an JSON file downloaded from a S3 amazon server, then is saved into the bronze database schema, each raw record is saved as a JSONB column in the raw_fintech_data table, along with a timestamp column to know when the record was saved, the records are extracted
Silver
The data is extracted from the bronze layer and loaded into spark, then the data is parsed as DataFrames and the nested array columns are flattened, then parsed and saved into new relational tables in the silver schema, also the data is deduplicated in the process