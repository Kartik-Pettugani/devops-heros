Docker Homework

Task 1

Node.js Application

What it does:
Creates a simple Node.js application, builds it into a Docker image,
runs it as a container, and accesses it through the browser.


![Node.js Setup](screenshots/1.png)

![Node.js Docker Build](screenshots/2.png)

![Node.js Container](screenshots/3.png)

![Node.js Browser Output](screenshots/4.png)

Python Application

What it does:
Creates a simple Python application, builds it into a Docker image, runs
it as a container, and accesses it through the browser.

![Node.js Setup](screenshots/5.png)

![Node.js Docker Build](screenshots/6.png)

![Node.js Container](screenshots/7.png)

![Node.js Browser Output](screenshots/8.png)

Java Application

What it does:
Creates a simple Java application, builds it into a Docker image, runs
it as a container, and accesses it through the browser.

![Node.js Setup](screenshots/9.png)

![Node.js Docker Build](screenshots/10.png)

![Node.js Container](screenshots/11.png)

![Node.js Browser Output](screenshots/12.png)

Apache Application

What it does:
Creates a simple HTML page, serves it using Apache inside a Docker
container, and accesses it through the browser.

![Node.js Setup](screenshots/13.png)

![Node.js Docker Build](screenshots/14.png)

![Node.js Container](screenshots/15.png)

React Application

What it does:
Creates a simple React-style webpage, serves it using Nginx inside a
Docker container, and accesses it through the browser.

![Node.js Setup](screenshots/16.png)

![Node.js Docker Build](screenshots/17.png)

![Node.js Container](screenshots/18.png)

Nginx Application

What it does:
Creates a simple HTML page, serves it using Nginx inside a Docker
container, and verifies the running container.

![Node.js Setup](screenshots/19.png)

![Node.js Docker Build](screenshots/20.png)

![Node.js Container](screenshots/21.png)

Docker Commands Used

docker build -t <image-name> .
docker images
docker run -d -p <host-port>:<container-port> --name <container-name> <image-name>
docker ps

Conclusion

This homework demonstrates how to create Dockerfiles, build Docker
images, run Docker containers, map ports, and access containerized
applications through a web browser.