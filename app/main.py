import asyncio
import json
import os
import time
import typing as tp

from fastapi import FastAPI, Request, Response
from prometheus_client import Counter, Histogram, generate_latest, REGISTRY


LOGS_FILE: tp.Final[str] = '/app/logs/app.log'
WELCOME_MSG: tp.Final[str] = os.environ.get('WELCOME_MSG', 'Welcome to the custom app')
LOG_LEVEL: tp.Final[str] = os.environ.get('LOG_LEVEL', 'INFO')

LOG_CALLS = Counter('service.log_calls_total', 'Total /log calls')
LOG_SUCCESS = Counter('service.log_success_total', 'Successful /log calls')
LOG_FAILURES = Counter('service.log_failures_total', 'Failed /log calls')
REQUEST_TIME = Histogram('service.log_duration_seconds', '/log Request processing time')


with open(LOGS_FILE, 'w') as f:
    f.write(json.dumps({'logs': 'start'}) + '\n')

app = FastAPI()


@app.get("/")
async def root():
    return WELCOME_MSG


@app.get("/status")
async def get_status():
    return {"status": "ok"}


@app.post("/log")
async def post_logs(request: Request):
    body = await request.json()
    with open(LOGS_FILE, 'a') as f:
        f.write(json.dumps(body) + '\n')


@app.post("/log_timeout")
async def post_logs_timeout(request: Request):
    await asyncio.sleep(2)
    await post_logs(request)


@app.get("/logs")
async def get_logs():
    start_time = time.time()

    try:
        with open(LOGS_FILE, 'r') as f:
            return list(map(json.loads, f))

        LOG_SUCCESS.inc()
    except:
        LOG_FAILURES.inc()
        raise
    finally:
        REQUEST_TIME.observe(time.time() - start_time)
        LOG_CALLS.inc()


@app.get("/metrics")
async def metrics():
    return Response(generate_latest(REGISTRY), media_type="text/plain")
