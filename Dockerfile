FROM apache/airflow:2.3.0
COPY requirements.txt /home/user1/airflow/requirements.txt
RUN pip install --user --upgrade pip
RUN pip install --no-cache-dir --user -r /home/user1/airflow/requirements.txt
ENV PYTHONPATH /home/user1/airflow
ENV PYTHONDONTWRITEBYTECODE 1
