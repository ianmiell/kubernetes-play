docker build -t kub .
docker run -ti -v /var/run/docker.sock:/var/run/docker.sock --privileged kub
