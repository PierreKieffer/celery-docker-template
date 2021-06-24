# -----------------------
# Celery Docker Template
# -----------------------


# -------------------------
# User settings :
CONCURRENCY=2
MOD_PATH=mods/example.py
# -------------------------


# -------------------------
#  Global
MOD_NAME=$(shell basename $(MOD_PATH) .py)
MOD_NAME_EXT=$(shell basename $(MOD_PATH))
REDIS_PS=$(shell docker ps -q --filter name=redis)
WORKER_NAME=celery-worker-${MOD_NAME}
SHARED_MOUNT_POINT=/tmp/celery/$(WORKER_NAME)
# -------------------------

# -------------------------
build : start-redis build-worker

run : start-worker 

start-redis:
ifeq ($(strip $(REDIS_PS)),)
	@echo " --------------------- "
	@echo " ---- START REDIS ---- "
	@echo " --------------------- "
	@docker run -d -p 6379:6379 --name redis redis
else 
	@echo " redis host : $(shell docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" redis) " 
endif

build-worker:
	@echo " ----------------------------- "
	@echo " ---- BUILD CELERY WORKER ---- "
	@echo " ----------------------------- "
	@echo " worker : $(WORKER_NAME) "
	@sed 's/REDIS=/REDIS="redis:\/\/$(shell docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" redis)"/' template/Dockerfile.template > template/Dockerfile
	@sed -i 's/concurrency=/concurrency=$(CONCURRENCY)/' template/Dockerfile
	@sed -i 's/MOD_NAME/$(MOD_NAME)/' template/Dockerfile
	@echo ""
	@$(shell cp $(MOD_PATH) template/)
	@cd template && cat Dockerfile
	@echo ""
	@cd template && docker build -t $(WORKER_NAME) . 
	@cd template && rm Dockerfile
	@cd template && rm $(MOD_NAME_EXT)


start-worker:
	@echo " ----------------------------- "
	@echo " ---- START CELERY WORKER ---- "
	@echo " ----------------------------- "
	@echo " worker : $(WORKER_NAME) "
	@docker run -d --network host --volume $(SHARED_MOUNT_POINT):/mnt --name $(WORKER_NAME) $(WORKER_NAME)

redis-host:
	@echo " redis host : $(shell docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" redis) " 
# -------------------------






