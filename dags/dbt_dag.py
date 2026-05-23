from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

with DAG(
    dag_id="dbt_only_DAG",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    is_paused_upon_creation=False,
) as dag:

    silver_normalization_dbt = BashOperator(
        task_id="silver_normalization_dbt",
        bash_command="""
        docker exec dbt bash -c "
            cd /dbt &&
            dbt deps &&
            dbt run --profiles-dir /dbt --target dev &&
            dbt test --profiles-dir /dbt --target dev
        "
        """
    )