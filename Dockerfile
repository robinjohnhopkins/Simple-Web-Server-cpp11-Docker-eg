FROM gcc:4.9
COPY . /HelloWorld
WORKDIR /HelloWorld
RUN ls -al
RUN g++ --version
RUN cat /etc/issue
#lsb_release -a
#debian so above doesn't work. use apt-get instead of yum
RUN apt-get update
RUN apt-get -y install cmake
RUN apt-get -y install libboost-all-dev

RUN mkdir -p build
RUN rm -rf ./build/*
RUN cd build;pwd
#/HelloWorld/build
RUN pwd
#/HelloWorld

RUN cd build; cmake ..;make
# RUN g++ -o HelloWorld HelloWorld.cpp
RUN ls -al
RUN ls -al ./build/http_examples

CMD ["./build/http_examples"]
#this builds the image from the Dockerfile. -t specifies ‘name:tag'
#docker build -t  helloworld:v1 .

# this runs the image mapping internal_port:external_port
#docker run -p 8080:8080  -it --rm --name HelloWorld helloworld:v1

# Direct your favorite browser to for instance http://localhost:8080/
#http://localhost:8080/match/1234
#REST GET /match/[number]
#otherwise static content from /web e.g. / returns web/index.html
#// GET-example simulating heavy work in a separate thread
#  server.resource["^/work$"]["GET"]

