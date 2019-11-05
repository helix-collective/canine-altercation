from mhndev/docker-lua

WORKDIR /home

RUN apt-get update && apt-get install -y libenet-dev
RUN luarocks install enet
RUN luarocks install luasocket

COPY . .
