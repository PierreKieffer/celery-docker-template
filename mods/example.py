#!/usr/bin/env python3
from celery import Celery
import os

REDIS=os.environ["REDIS"]
celery = Celery('tasks', broker=REDIS, backend=REDIS)

@celery.task
def task_worker(**kwargs):
    for k,v in kwargs.items():  
        print("key : {}, value : {}".format(k,v))

    return "task_worker",  "foobar"

