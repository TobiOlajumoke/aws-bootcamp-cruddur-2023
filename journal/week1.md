# Week 1 — App Containerization

## What is Docker?
Docker is a platform that allows you to create, run, and manage applications in containers. Containers are a lightweight and portable way to package and distribute software, along with all of its dependencies and configuration settings. It is a tool that allows you to create and manage lightweight, portable containers that can run your applications in any environment, without worrying about dependencies or other environmental factors.

### Container
A Docker container is a running instance of an image. Containers are isolated from the host system and from other containers, but can communicate with each other through a network.

### Registries
A Docker registry is a centralized location where Docker images can be stored and shared. The most common registry is Docker Hub, which is a public repository of pre-built images.

### Dockerfile
A Dockerfile is a text file that contains instructions for building a Docker image. It contains a series of commands that are executed one after the other to create an image.

### Docker Compose
Docker Compose is a tool that allows you to define and run multi-container Docker applications. You can use it to define the services that make up your application, specify their dependencies and configuration, and run them all with a single command.

### Docker Image
A Docker image is a snapshot of an application and its dependencies. It's created by running the commands in a Dockerfile. You can think of an image as a blueprint for creating containers.

### Docker Container
A Docker container is a running instance of an image. You can think of a container as a lightweight, isolated virtual environment. Containers have their own file system, networking, and processes, but they share the kernel of the host operating system.

## What is container Security?
Container Security is the practice of protecting your application hosted on compute service like  containers.

## Why container is popular?
It is a angnostic way to run application.
Most people started developing apps on container due to the simplicity to pass the package without considering requirements.

## Best practices for writing Dockerfiles

- Use official base images: Start with an official, minimal base image that matches your application's needs. This can help ensure that your images are secure and up-to-date.

- Use a .dockerignore file: Create a .dockerignore file in the same directory as your Dockerfile to exclude unnecessary files and directories from your build context. This can help reduce the size of your images and speed up the build process.

- Minimize layers: Each instruction in a Dockerfile creates a new layer in the image. To minimize the number of layers, combine related commands into a single RUN instruction.

- Use specific versions: Specify exact versions for all dependencies and packages to ensure consistency and avoid surprises caused by updates or version changes.

- Clean up after yourself: Remove unnecessary files and dependencies after installation to reduce the size of the final image. Also, use the --no-cache option when running apt-get to avoid caching package metadata.

- Use environment variables: Use environment variables to make your Docker images more flexible and configurable. This can help you easily modify the behavior of your container at runtime.

- Use labels: Add metadata to your images using labels. This can help you keep track of important information, such as the version number, maintainer, or build date.

- Avoid running as root: Running a container as root can be a security risk. Instead, use a non-root user and set the appropriate permissions on files and directories.

- Keep images small: Keep your images as small as possible by removing unnecessary files and dependencies, and using a multistage build process to minimize the number of layers.

- Test your images: Test your Docker images to ensure that they work as expected and are free of vulnerabilities. This can help you catch issues early and avoid problems in production.



## VSCode Docker Extension

Docker for VSCode makes it easy to work with Docker

https://code.visualstudio.com/docs/containers/overview

We'll be using Gitpod here it as docker preinstalled 


# Step 1

## Containerize Backend

### Run Python

```sh
cd backend-flask
export FRONTEND_URL="*"
export BACKEND_URL="*"
python3 -m flask run --host=0.0.0.0 --port=4567
cd ..
```

- make sure to unlock the port on the port tab
- open the link for 4567 in your browser
- append to the url to `/api/activities/home`
- you should get back json



### Add Dockerfile

Create a file here: `backend-flask/Dockerfile`

```dockerfile
FROM python:3.10-slim-buster

WORKDIR /backend-flask

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

COPY . .

ENV FLASK_ENV=development

EXPOSE ${PORT}

# python3 -m  flask  run --host=0.0.0.0  --port=4567
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=4567"]
```
![Alt text](../journal_images/backend%20docker%20file.png)




### Build Container

```sh
docker build -t  backend-flask ./backend-flask
```

```
docker images
```
### Run Container

Run 

```
docker container run --rm -p 4567:4567 -d backend-flask
```

 docker container run is idiomatic, docker run is legacy syntax but is commonly used.

### Get Container Images or Running Container Ids

```
docker ps 
```
```
docker ps -a 
```



### Send Curl to Test Server

```sh
curl -X GET http://localhost:4567/api/activities/home -H "Accept: application/json" -H "Content-Type: application/json"
```



### Check Container Logs

```sh
docker logs CONTAINER_ID -f
docker logs backend-flask -f
docker logs $CONTAINER_ID -f
```

###  Debugging  adjacent containers with other containers

```sh
docker run --rm -it curlimages/curl "-X GET http://localhost:4567/api/activities/home -H \"Accept: application/json\" -H \"Content-Type: application/json\""
```

busybosy is often used for debugging since it install a bunch of thing

```sh
docker run --rm -it busybosy
```

### Gain Access to a Container

```sh
docker exec CONTAINER_ID -it /bin/bash
```

> You can just right click a container and see logs in VSCode with Docker extension

### Delete an Image

```sh
docker image rm backend-flask --force
```

> docker rmi backend-flask is the legacy syntax, you might see this is old docker tutorials and articles.

> There are some cases where you need to use the --force

### Overriding Ports

```sh
FLASK_ENV=production PORT=8080 docker run -p 4567:4567 -it backend-flask
```

> Look at Dockerfile to see how ${PORT} is interpolated

## Containerize Frontend

## Run NPM Install

We have to run NPM Install before building the container since it needs to copy the contents of node_modules

```
cd frontend-react-js
npm i
```

### Create Docker File

Create a file here: `frontend-react-js/Dockerfile`

```dockerfile
FROM node:16.18

ENV PORT=3000

COPY . /frontend-react-js
WORKDIR /frontend-react-js
RUN npm install
EXPOSE ${PORT}
CMD ["npm", "start"]
```

### Build Container

```sh
docker build -t frontend-react-js ./frontend-react-js
```

### Run Container

```sh
docker run -p 3000:3000 -d frontend-react-js
```

## Multiple Containers

### Create a docker-compose file

Create `docker-compose.yml` at the root of your project.

```yaml
version: "3.8"
services:
  backend-flask:
    environment:
      FRONTEND_URL: "https://3000-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
      BACKEND_URL: "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    build: ./backend-flask
    ports:
      - "4567:4567"
    volumes:
      - ./backend-flask:/backend-flask
  frontend-react-js:
    environment:
      REACT_APP_BACKEND_URL: "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    build: ./frontend-react-js
    ports:
      - "3000:3000"
    volumes:
      - ./frontend-react-js:/frontend-react-js

# the name flag is a hack to change the default prepend folder
# name when outputting the image names
networks: 
  internal-network:
    driver: bridge
    name: cruddur
```

## Adding DynamoDB Local and Postgres

We are going to use Postgres and DynamoDB local in future labs
We can bring them in as containers and reference them externally

Lets integrate the following into our existing docker compose file:

### Postgres

```yaml
services:
  db:
    image: postgres:13-alpine
    restart: always
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
    ports:
      - '5432:5432'
    volumes: 
      - db:/var/lib/postgresql/data
volumes:
  db:
    driver: local
```

To install the postgres client into Gitpod

```sh
  - name: postgres
    init: |
      curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
      echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
      sudo apt update
      sudo apt install -y postgresql-client-13 libpq-dev
```

### DynamoDB Local

```yaml
services:
  dynamodb-local:
    # https://stackoverflow.com/questions/67533058/persist-local-dynamodb-data-in-volumes-lack-permission-unable-to-open-databa
    # We needed to add user:root to get this working.
    user: root
    command: "-jar DynamoDBLocal.jar -sharedDb -dbPath ./data"
    image: "amazon/dynamodb-local:latest"
    container_name: dynamodb-local
    ports:
      - "8000:8000"
    volumes:
      - "./docker/dynamodb:/home/dynamodblocal/data"
    working_dir: /home/dynamodblocal
```

Example of using DynamoDB local
https://github.com/100DaysOfCloud/challenge-dynamodb-local

## Volumes

directory volume mapping

```yaml
volumes: 
- "./docker/dynamodb:/home/dynamodblocal/data"
```

named volume mapping

```yaml
volumes: 
  - db:/var/lib/postgresql/data

volumes:
  db:
    driver: local
```