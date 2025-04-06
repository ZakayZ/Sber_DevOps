import json
import os
import typing as tp

from fastapi import FastAPI


LOGS_FILE: tp.Final[str] = '/app/logs/app.log'
WELCOME_MSG: tp.Final[str] = os.environ.get('WELCOME_MSG', 'Welcome to the custom app')
LOG_LEVEL: tp.Final[str] = os.environ.get('LOG_LEVEL', 'INFO')

app = FastAPI()


@app.get("/")
async def root():
    return WELCOME_MSG


@app.get("/status")
async def get_status():
    return {"status": "ok"}


@app.post("/log")
async def post_logs(log: tp.Dict[str, str]):
    with open(LOGS_FILE, 'a') as f:
        f.write(json.dumps(log) + '\n')    


@app.get("/logs")
async def get_logs():
    with open(LOGS_FILE, 'r') as f:
        return list(map(json.loads, f))
