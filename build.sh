docker rm -f kubernetes
docker build -t kubernetes .
docker run -d --name kubernetes --net=host -v /var/run/docker.sock:/var/run/docker.sock --privileged kub
docker logs -f kubernetes
docker exec -ti kubernetes bash
