from datetime import datetime
import pandas as pd
import numpy as np
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.hooks.postgres_hook import PostgresHook

# Define constants
ACTION_TYPES = ["walk", "run", "sit", "sleep"]
PERSON_IDS = range(1, 5)


# Function to generate random data
def generate_random_data():
    num_rows = 1000
    data = {
        "action_type": np.random.choice(ACTION_TYPES, num_rows),
        "timestamp": pd.date_range(start="2021-01-01", periods=num_rows, freq="T"),
        "person_id": np.random.choice(PERSON_IDS, num_rows),
    }
    df = pd.DataFrame(data)
    df.to_csv("/tmp/activity_data.csv", index=False)


# Function to ingest data to PostgreSQL
def ingest_data_to_postgres():
    # Initialize the PostgreSQL hook and SQLAlchemy engine
    hook = PostgresHook(postgres_conn_id="postgres_dw")
    engine = hook.get_sqlalchemy_engine()

    # Read the data from CSV and insert into the table
    (
        pd.read_csv("/tmp/activity_data.csv").to_sql(
            "activities", engine, if_exists="replace", index=False, method="multi"
        )
    )


# Define the default arguments for the DAG
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
}

# Define the DAG
dag = DAG(
    "generate_and_ingest_activity_data",
    default_args=default_args,
    description="Generate random activity data and ingest into PostgreSQL",
    schedule_interval="@once",
    start_date=datetime(2023, 1, 1),
    catchup=False,
)

# Define the tasks
t1 = PythonOperator(
    task_id="generate_random_data",
    python_callable=generate_random_data,
    dag=dag,
)

t2 = PythonOperator(
    task_id="ingest_data_to_postgres",
    python_callable=ingest_data_to_postgres,
    dag=dag,
)

# Set the task dependencies
t1 >> t2
