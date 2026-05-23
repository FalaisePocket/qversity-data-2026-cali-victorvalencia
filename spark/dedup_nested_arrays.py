from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, explode_outer, col, to_json
import psycopg2
import os
from dotenv import load_dotenv
from spark.schemas import customer_schema, credit_info_schema, digital_engagement_schema, loan_schema

def bronze_to_silver():

    

    def flatten_array_column(main_df, parent_table_id, array_col_name,alias="object"):
        """
        Flattens a nested array column in a DataFrame
        Parameters:
        - main_df: The input DataFrame containing the nested array column.
        - parent_table_id: The name of the column that identifies the parent table (e.g
        customer_id for accounts and transactions, account_id for loans).
        - array_col_name: The name of the nested array column to be flattened.
        - alias: The alias to be used for the exploded array elements (default is "object").
        """
        exploded_df = main_df.select(
            col(parent_table_id),
            explode_outer(col(array_col_name)).alias(alias)
        )

        flattened_df = exploded_df.select(
            col(parent_table_id),
            col(f"{alias}.*")
        )

        return flattened_df


    def save_to_silver(df, table_name, mode="append"):
        """
        writes a DataFrame to a Postgres table in the silver schema using JDBC. 
        The function takes care of the connection details and allows 
        specifying the write mode (overwrite, append, ignore, error).

        Parameters:
        - df: Spark DataFrame
        - table_name: table name with the schema name  schema.table
        - mode: overwrite | append | ignore | error
        """

        

        df.write \
            .format("jdbc") \
            .option("url", "jdbc:postgresql://postgres:5432/qversity") \
            .option("dbtable", table_name) \
            .option("user", "qversity-admin") \
            .option("password", "qversity-admin") \
            .option("driver", "org.postgresql.Driver") \
            .mode(mode) \
            .save()
        print(f"Data saved to {table_name} in silver schema.")

    def flatten_and_dedup(parent_df, parent_id_col_name, array_col_name, dedup_cols, alias="object"):
        
        print(f"Processing array column: {array_col_name}...")


        df = flatten_array_column(parent_df, parent_id_col_name, array_col_name, alias=alias)
        
        ##################################################
        ##counting the number of records in each dataframe
        ##################################################

        
        original_count = df.count()


        ######################
        ###dropping duplicates
        ######################
        
        deduped_df = df.dropDuplicates(dedup_cols)
        
        

        #############################################################################
        ###counting the number of records in each dataframe after dropping duplicates
        #############################################################################

        deduped_count = deduped_df.count()
        print(f"[{array_col_name}] Original: {original_count} | After dedup: {deduped_count} | Removed: {original_count - deduped_count}")
        

        ###################
        ##staging to silver
        ###################

        save_to_silver(deduped_df, f"silver.stg_{array_col_name}")
        #deduped_df.unpersist(blocking=True)

        print(f"Finished processing array column: {array_col_name}.")
        


    print("Starting Spark session...")

    #spark = SparkSession.builder \
        #.appName("Silver Staging") \
        #.getOrCreate()
    spark = SparkSession.builder \
    .appName("Silver Staging") \
    .config("spark.jars", "/opt/airflow/jars/postgresql.jar") \
    .getOrCreate()


    df = spark.read \
        .format("jdbc") \
        .option("url", f"jdbc:postgresql://{os.getenv('POSTGRES_HOST')}:5432/{os.getenv('POSTGRES_DB')}") \
        .option("dbtable", "(SELECT data FROM bronze.raw_fintech_data) AS t") \
        .option("user", f"{os.getenv('POSTGRES_USER')}") \
        .option("password", f"{os.getenv('POSTGRES_PASSWORD')}") \
        .option("driver", "org.postgresql.Driver") \
        .load()
    #.option("dbtable", "bronze.raw_fintech_data")


    ###parsing bronze data from string to json
    ###Parse data jsonb column using the bronze schema
    print("Parsing bronze data...")

    parsed_df = df.withColumn(
        "parsed",
        from_json(col("data").cast("string"), customer_schema)
    ).cache()

    customer_df = parsed_df.select("parsed.*")
    #customer_df.cache()
    #base_df = customer_df
    

    ##Flattenning the nested arrays, parsing them and finally 
    ##putting them in a new table
    print("Flattening and deduplicating nested arrays...")


    #accounts
    flatten_and_dedup(customer_df,"customer_id", "accounts", ["account_id","account_type", "opened_date"] , alias="account")
    
    #transactions
    flatten_and_dedup(customer_df,"customer_id", "transactions", ["amount", "currency", "date","transaction_id"], alias="transaction")
    
    #loans
    flatten_and_dedup(customer_df,"customer_id", "loans", ["start_date", "end_date"], alias="loan")

    #saving customer data without the nested arrays to a new table in silver for later use in transformations and gold tables
    
    new_customer_df = (
        customer_df
        .withColumn("credit_info", to_json(col("credit_info")))
        .withColumn("digital_engagement", to_json(col("digital_engagement")))
        .drop("accounts", "transactions", "loans")
        .dropDuplicates(["customer_id"])
        .cache()
    )
    print("Checking duplicates in customer data...")
    print(new_customer_df.count())
    print(new_customer_df.select("customer_id").distinct().count())

    print("saving customer data to silver staging table...")
    
    save_to_silver( new_customer_df,"silver.stg_customer",mode="append")

    #new_customer_df.unpersist()

    print("Finished processing nested arrays and deduplication. Data is now in silver staging tables.")

    
