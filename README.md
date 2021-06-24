# Celery Docker Template

Template to build Celery Docker distributed systems.  

```bash
┌──────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                      │
│ Docker                              ┌─────────┐                                      │
│                                     │         │                                      │
│              ┌──────────────────────┤  Redis  ├───────────────────────┐              │
│              │                      │         │                       │              │
│              │                      └────┬────┘                       │              │
│              │                           │                            │              │
│              │                           │                            │              │
│              │                           │                            │              │
│     ┌────────┴────────┐         ┌────────┴────────┐         ┌─────────┴────────┐     │
│     │                 │         │                 │         │                  │     │
│     │ celery-worker-1 │         │ celery-worker-2 │         │ celery-worker-...│     │
│     │                 │         │                 │         │                  │     │
│     └────────┬────────┘         └────────┬────────┘         └─────────┬────────┘     │
│              │                           │                            │              │
└──────────────┼───────────────────────────┼────────────────────────────┼──────────────┘
               │                           │                            │
               │                           │                            │
               │              ┌────────────┴───────────┐                │
               │              │                        │                │
               └──────────────┤   Shared mount point   ├────────────────┘
                              │                        │
                              └────────────────────────┘
```

* [Prerequisites](#prerequisites)
* [Makefile configuration](#makefile-configuration)
* [Build](#build)
* [Deploy](#deploy)
* [Shared mount point](#shared-mount-point)

## Prerequisites 
- make : All deployment is provided under `Makefile`. 
```bash 
sudo apt install -y make 
```
- docker 

## Makefile configuration 
- `CONCURRENCY` : 
```bash
CONCURRENCY=2
```
Max value is number of available cores on the machine. 

For high intensity tasks, it's better to set a lower concurrency value to save memory and cpu allocation for running tasks. 

- `MOD_PATH` : 
```bash
MOD_PATH=mods/tasks.py
```
Module file path with @celery.task who needs to to be deployed. 


## Build 
Build celery worker image. 
```bash 
make build 
```
Redis instance is needed to build services (host resolution), so this command will first start Redis container if a Redis host is not found. 

Celery worker image name is `celery-worker-$MOD_NAME` with `MOD_NAME` the module file name deployed. 

## Deploy 
Deploy a worker container : 
```bash 
make run 
```
## Shared mount point 
Back up and share data through the shared mount point. 

On host, shared mount point is set to `/tmp/celery/celery-worker-$MOD_NAME`
```bash
>/tmp$ 
   ├── celery
   │   └── celery-worker-example
```








