from debian


WORKDIR /home

RUN apt-get update && apt-get install -y luarocks libenet-dev

RUN luarocks install enet
RUN luarocks install luasocket

COPY . .
