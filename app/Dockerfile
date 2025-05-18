FROM ubuntu:latest

WORKDIR /app
COPY . .

RUN apt-get update -y
RUN apt-get install -y python3-pip python3-dev build-essential
RUN pip3 install --no-cache-dir --break-system-packages prometheus-client "fastapi[standard]"

RUN mkdir -p /app/logs && touch /app/logs/app.log

ENV APP_PORT=5000
ENV LOG_LEVEL=INFO
ENV WELCOME_MSG="Welcome to the custom app"

EXPOSE ${APP_PORT}

CMD ["sh", "-c", "fastapi run main.py --host 0.0.0.0 --port ${APP_PORT}"]
