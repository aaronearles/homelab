https://fastapi.tiangolo.com/deployment/docker/#build-a-docker-image-for-fastapi
```
sudo docker build -t myfastapi .
sudo docker run -d --name fastapi-command -p 8222:80 myfastapi
```