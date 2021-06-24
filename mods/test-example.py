#!/usr/bin/env python3
import os
from example import * 
import time

if __name__=="__main__":

    print("trigger task")
    t = task_worker.delay(foo = "bar", value= 42)
    task_id = t.task_id
    print("task id : {}, task state : {}".format(task_id, t.state))

    time.sleep(1)
    t = task_worker.AsyncResult(task_id)
    print(t.result)




    

