# Docker Networking & Volume Homework

## Task 1

### Create Docker Networks

**What it does:**  
Created three Docker networks: frontend-net, backend-net, and database-net.

![Docker Networks](screenshots/1.png)

### Create Containers

![Docker Containers](screenshots/2.png)

### Backend Network Configuration

![Backend Networks](screenshots/3.png)

### Container Connectivity

![Container Connectivity](screenshots/4.png)

## Task 2

### Apache Host Network

![Apache Host Network](screenshots/5.png)

### Apache Website

![Apache Website](screenshots/6.png)

## Task 3

### Create index.html

![Index HTML](screenshots/7.png)

### Nginx Bind Mount

![Nginx Bind Mount](screenshots/8.png)

### Initial Website

![Initial Website](screenshots/9.png)

### Updated File

![Updated File](screenshots/10.png)

### Updated Website

![Updated Website](screenshots/11.png)


## Task 4: Overlay Network

### What is an Overlay Network?

An overlay network is a Docker network that allows containers running
on different Docker hosts to communicate with each other.

It is mainly used with Docker Swarm for multi-host container
communication.

### Use Cases

- Communication between containers on different Docker hosts.
- Docker Swarm applications.
- Microservices running across multiple servers.
- Distributed applications.

### How it works

Docker creates a virtual network that spans multiple Docker hosts.
Containers connected to the same overlay network can communicate
with each other even when they are running on different machines.

### Command

![Overlay Network](screenshots/12.png)

```bash
docker swarm init

docker network create -d overlay my-overlay-network

docker network ls

