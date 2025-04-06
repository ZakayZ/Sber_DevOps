FROM ubuntu:latest

WORKDIR /app
COPY . .

RUN apt-get update -y
RUN apt-get install -y python3-pip python3-dev build-essential
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p /app/logs

ENV APP_PORT=5000
ENV LOG_LEVEL=INFO

EXPOSE ${APP_PORT}

CMD ["fastapi", "run", "main.py",  "--host", "0.0.0.0", "--port ${APP_PORT}"]
