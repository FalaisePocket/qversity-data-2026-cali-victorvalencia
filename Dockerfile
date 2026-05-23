
FROM apache/airflow:2.7.1-python3.11

USER root

RUN apt-get update && \
    apt-get install -y \
    openjdk-17-jdk \
    docker.io \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/airflow/jars && \
    curl -o /opt/airflow/jars/postgresql.jar \
    https://jdbc.postgresql.org/download/postgresql-42.7.3.jar

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

USER airflow

RUN pip install --no-cache-dir \
    pyspark \
    pandas \
    boto3 \
    psycopg2-binary \
    dbt-core \
    dbt-postgres