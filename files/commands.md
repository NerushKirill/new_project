### Poetry
```bash
pip install poetry

poetry init
poetry add pydantic-settings
```

### Git
```bash
git config --global user.name "Kirill Nerush"
git config --global user.email nerush.kirill@gmail.com

git init
git add .
git commit -m "%project_name%"
git branch -M main
git remote add origin git@github.com:NerushKirill/%project_name%.git
git push -u origin main

git check branch

# Copy files from other branch

git checkout <branch_name> -- <path/neme.txt>

git checkout new-feature
git fetch origin new-feature
git reset --hard origin/new-feature
```

### Docker
```bash
docker compose up -d
docker compose down

docker ps -a
docker start $(docker ps -q)
docker stop $(docker ps -q)
docker rm $(docker ps -qa)

docker volume ls
docker volume rm $(docker volume ls -q)

docker inspect <container_id>
docker logs <container_id>

docker images -q
docker rmi <image_id>

# Connect to container
docker exec -it <container_name> /bin/bash

## Temp container mount currents created volume
docker run -it --name temp_container -v <volume_name>:/mnt ubuntu /bin/bash
docker rm temp_container

# Network settings
docker network ls
docker network inspect mynetwork

docker network create mynetwork

# Examples
docker run -d --network=mynetwork --name=vertica -p 5433:5433 -p 5444:5444 vertica/vertica

Backup postgres
docker exec -t your-db-container pg_dumpall -c -U postgres > dump_`date +%Y-%m-%d"_"%H_%M_%S`.sql

# gzip
docker exec -t your-db-container pg_dumpall -c -U postgres | gzip > dump_`date +%Y-%m-%d"_"%H_%M_%S`.sql.gz
# brotli
docker exec -t your-db-container pg_dumpall -c -U postgres | brotli --best > dump_`date +%Y-%m-%d"_"%H_%M_%S`.sql.br
# bzip2
docker exec -t your-db-container pg_dumpall -c -U postgres | bzip2 --best > dump_`date +%Y-%m-%d"_"%H_%M_%S`.sql.bz2
# resolve
cat your_dump.sql | docker exec -i your-db-container psql -U postgres
```
