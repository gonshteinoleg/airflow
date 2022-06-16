# Развертывание Airflow на виртуальной машине через Docker Compose

## Шаг 1. Подключитесь к виртуальной машине по SSH
<img width="736" alt="image" src="https://user-images.githubusercontent.com/97543975/174013696-8b5049e2-5a55-4932-81bd-6453c63ce162.png">

## Шаг 2. Клонируйте этот репозиторий на виртуальную машину
```
sudo apt install git
git clone https://github.com/gonshteinoleg/airflow.git
```
<img width="738" alt="image" src="https://user-images.githubusercontent.com/97543975/174015597-83734b74-1679-4f9e-a8b2-fe7f5e6fe248.png">

## Шаг 3. Добавьте необходимые библиотеки в файл requirements.txt
```
nano requirements.txt
```
<img width="734" alt="image" src="https://user-images.githubusercontent.com/97543975/174016037-4e827328-1c54-47ee-b6d2-1319435719c0.png">

## Шаг 4. Создайте репозиторий для хранения дагов
<img width="922" alt="image" src="https://user-images.githubusercontent.com/97543975/174017085-fc8ae021-69d2-4348-8dd5-aa9621aa76f8.png">

## Шаг 5. Добавьте в созданный репозиторий даг
В качестве примера, можете использовать этот
```
from datetime import datetime
from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator

def print_hello():
    return 'Hello world!'

dag = DAG('hello_world', description='Hello World DAG',
          schedule_interval='0 12 * * *',
          start_date=datetime(2017, 3, 20), catchup=False)

hello_operator = PythonOperator(task_id='hello_task', 
                                python_callable=print_hello, 
                                dag=dag)

hello_operator
```

## Шаг 6. Скопируйте токен GitHub и вставьте его в файл docker-compose.yml
Для генерации токена перейдите в настройки, далее в левом меню кликните на Developer Settings, провалитесь в Personal access tokens и создайте токен.
<img width="1184" alt="image" src="https://user-images.githubusercontent.com/97543975/174017976-51067614-1a40-42c9-af03-84386d537c95.png">
<img width="805" alt="image" src="https://user-images.githubusercontent.com/97543975/174018233-a38c84bc-b6f7-4127-9aa3-4caca389450c.png">

Далее, откройте на виртуальной машине файл docker-compose.yml и вставьте в контейнер git-sync ваш токен и пользователя.
<img width="1025" alt="image" src="https://user-images.githubusercontent.com/97543975/174019114-b577bc92-3582-4471-9dfe-4f29fc7baf1b.png">

```
Хранение токена в коде это не самый безопасный способ и несет за собой риски.
```

## Шаг 7. Установите Docker и Docker Compose
Выполните в консоли виртуальной машины следующие команды:
```
sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

Далее, смените пароль для root и пользователя (в моем случае user1)
```
sudo passwd
sudo passwd user1
```

И настройте группы докера
```
sudo groupadd docker
sudo usermod -aG docker ${USER}
su -s /bin/bash ${USER}
```

Если все было сделано верно, команда
```
docker run hello-world
```
выведит следующее:

<img width="735" alt="image" src="https://user-images.githubusercontent.com/97543975/174040284-f42055a6-075b-45c9-9904-c478517e5c47.png">

## Шаг 8. Запустите сборку контейнера
```
cd airflow
docker build . --tag airflow:latest
```
<img width="738" alt="image" src="https://user-images.githubusercontent.com/97543975/174025494-f4b36b54-2919-40a3-9977-1052907e6aeb.png">

## Шаг 9. Установите Docker Compose
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

## Шаг 10. Запустите монтирование образов с помощью Docker Compose
```
docker compose up -d
```
