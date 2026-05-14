from pyspark.sql.types import StructType, StructField, FloatType, BooleanType, StringType, IntegerType,ArrayType



##Nested arrays schemas
account_schema = StructType([
    StructField("account_id", StringType(),True),
    StructField("account_type", StringType(),True),
    StructField("currency", StringType(),True),
    StructField("balance", FloatType(),True),
    StructField("credit_limit", FloatType(),True),
    StructField("interest_rate", FloatType(),True),
    StructField("opened_date", StringType(),True),
    StructField("status", StringType(),True),
    StructField("branch_code", StringType(),True),
])

transaction_schema = StructType([
    StructField("transaction_id", StringType(),True),
    StructField("account_id", StringType(),True),
    StructField("date", StringType(),True),
    StructField("amount", FloatType(),True),
    StructField("currency", StringType(),True),
    StructField("type", StringType(),True),
    StructField("category", StringType(),True),
    StructField("merchant", StringType(),True),
    StructField("channel", StringType(),True),
    StructField("status", StringType(),True),
    StructField("description", StringType(),True)
])

loan_schema = StructType([
        StructField("loan_id", StringType(), True),
        StructField("type", StringType(), True),
        StructField("currency", StringType(), True),
        StructField("principal", FloatType(), True),
        StructField("outstanding_balance", FloatType(), True),
        StructField("interest_rate", FloatType(), True),
        StructField("term_months", IntegerType(), True),
        StructField("monthly_payment", FloatType(), True),
        StructField("start_date", StringType(), True),
        StructField("end_date", StringType(), True),
        StructField("status", StringType(), True),
        StructField("days_past_due", IntegerType(), True),
        StructField("collateral_type", StringType(), True),
])

##nested objects schemas
credit_info_schema = StructType([
    StructField("credit_score", IntegerType(), True),
    StructField("currency", StringType(), True),
    StructField("utilization_pct", FloatType(), True),
    StructField("total_limit", FloatType(), True),
    StructField("total_used", FloatType(), True),
    StructField("num_credit_accounts", IntegerType(), True),
    StructField("oldest_account_age_months", IntegerType(), True),
    StructField("late_payments_12m", IntegerType(), True),
    StructField("inquiries_6m", IntegerType(), True),
    StructField("bankruptcy_flag", BooleanType(), True),
])

digital_engagement_schema = StructType([
    StructField("mobile_app_registered", BooleanType(), True),
    StructField("web_banking_registered", BooleanType(), True),
    StructField("last_login_date", StringType(), True),
    StructField("avg_monthly_logins", IntegerType(), True),
    StructField("preferred_channel", StringType(), True),
    StructField("push_notifications", BooleanType(), True),
    StructField("paperless_statements", BooleanType(), True),
])



customer_schema = StructType([
    StructField("customer_id", StringType(),True),
    StructField("first_name", StringType(),True),
    StructField("last_name", StringType(),True),
    StructField("email", StringType(),True),
    StructField("phone_number", StringType(),True),
    StructField("date_of_birth", StringType(),True),
    StructField("gender", StringType(),True),
    StructField("nationality", StringType(),True),
    StructField("city", StringType(),True),
    StructField("country", StringType(),True),
    StructField("adress", StringType(),True),
    StructField("lat", FloatType(),True),
    StructField("lon", FloatType(),True),
    StructField("registration_date", StringType(),True),
    StructField("kyc_status", StringType(),True),
    StructField("risk_score", FloatType(),True),
    StructField("customer_segment", StringType(),True),
    StructField("relationship_manager", StringType(),True),
    StructField("status", StringType(),True),
    
    # nested arrays
    StructField(
        "accounts",
        ArrayType(account_schema),
        True),

    StructField(
        "transactions",
        ArrayType(transaction_schema),
        True
    ),

    StructField(
        "loans",
        ArrayType(loan_schema),
        True
    ),

    # nested objects
    StructField(
        "credit_info",
        credit_info_schema,
        True
    ),

    StructField(
        "digital_engagement",
        digital_engagement_schema,
        True
    )

])



'''#age additional field
    StructField("age", IntegerType(),True),
    #age_buckets additional field
    StructField("age_buckets", StringType(),True),
    #tenure additional field
    StructField("tenure", IntegerType(),True),'''



'''from pyspark.sql.types import StructType

def flatten_structs(df):
    flat_cols = []

    for field in df.schema.fields:
        if isinstance(field.dataType, StructType):
            for nested in field.dataType.fields:
                flat_cols.append(
                    col(f"{field.name}.{nested.name}")
                    .alias(f"{field.name}_{nested.name}")
                )
        else:
            flat_cols.append(col(field.name))

    return df.select(flat_cols)'''