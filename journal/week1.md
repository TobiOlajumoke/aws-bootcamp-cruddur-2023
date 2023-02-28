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



## Created a notification feature (backend and frontend)

### Added this inside the openapi.yml file 
```sh
  /api/activities/notifications:
    get:
      description: 'Return a feed of activity for all the people i follow'
      tags:
        - activities
        
      parameters: []
      responses:
        '200':
          description: Returns an array of activities
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Activity'
```
![Alt text](../journal_images/openai%20notification.png)


### Inside the backend-flask/services created a notifications_activities file pasted the below:
```sh
from datetime import datetime, timedelta, timezone
class NotificationsActivities:
  def run():
    now = datetime.now(timezone.utc).astimezone()
    results = [{
      'uuid': '68f126b0-1ceb-4a33-88be-d90fa7109eee',
      'handle':  '3abuza',
      'message': 'I am a DevOps Engineer',
      'created_at': (now - timedelta(days=2)).isoformat(),
      'expires_at': (now + timedelta(days=5)).isoformat(),
      'likes_count': 5,
      'replies_count': 1,
      'reposts_count': 0,
      'replies': [{
        'uuid': '26e12864-1c26-5c3a-9658-97a10f8fea67',
        'reply_to_activity_uuid': '68f126b0-1ceb-4a33-88be-d90fa7109eee',
        'handle':  'Worf',
        'message': 'This post has no honor!',
        'likes_count': 0,
        'replies_count': 0,
        'reposts_count': 0,
        'created_at': (now - timedelta(days=2)).isoformat()
      }],
    },
   
    ]
    return results
```
![Alt text](../journal_images/backend%20notification.png)


### In the frontend-react-js/src/pages added a new page NotificationsFeedPage.js pasted the below:
```sh
import './NotificationsFeedPage.css';
import React from "react";

import DesktopNavigation  from '../components/DesktopNavigation';
import DesktopSidebar     from '../components/DesktopSidebar';
import ActivityFeed from '../components/ActivityFeed';
import ActivityForm from '../components/ActivityForm';
import ReplyForm from '../components/ReplyForm';

// [TODO] Authenication
import Cookies from 'js-cookie'

export default function NotificationsFeedPage() {
  const [activities, setActivities] = React.useState([]);
  const [popped, setPopped] = React.useState(false);
  const [poppedReply, setPoppedReply] = React.useState(false);
  const [replyActivity, setReplyActivity] = React.useState({});
  const [user, setUser] = React.useState(null);
  const dataFetchedRef = React.useRef(false);

  const loadData = async () => {
    try {
      const backend_url = `${process.env.REACT_APP_BACKEND_URL}/api/activities/notifications`
      const res = await fetch(backend_url, {
        method: "GET"
      });
      let resJson = await res.json();
      if (res.status === 200) {
        setActivities(resJson)
      } else {
        console.log(res)
      }
    } catch (err) {
      console.log(err);
    }
  };

  const checkAuth = async () => {
    console.log('checkAuth')
    // [TODO] Authenication
    if (Cookies.get('user.logged_in')) {
      setUser({
        display_name: Cookies.get('user.name'),
        handle: Cookies.get('user.username')
      })
    }
  };

  React.useEffect(()=>{
    //prevents double call
    if (dataFetchedRef.current) return;
    dataFetchedRef.current = true;

    loadData();
    checkAuth();
  }, [])

  return (
    <article>
      <DesktopNavigation user={user} active={'notifications'} setPopped={setPopped} />
      <div className='content'>
        <ActivityForm  
          popped={popped}
          setPopped={setPopped} 
          setActivities={setActivities} 
        />
        <ReplyForm 
          activity={replyActivity} 
          popped={poppedReply} 
          setPopped={setPoppedReply} 
          setActivities={setActivities} 
          activities={activities} 
        />
        <ActivityFeed 
          title="Notifications" 
          setReplyActivity={setReplyActivity} 
          setPopped={setPoppedReply} 
          activities={activities} 
        />
      </div>
      <DesktopSidebar user={user} />
    </article>
  );
}
```
![Alt text](../journal_images/frontend%20notification%20page.png)

### Add in the  frontend-react-js/src/app.js file we are gonna make 2 addition:
```sh
import NotificationsFeedPage from './pages/NotificationsFeedPage';
```

```sh
{
  path: "/notifications",
  element: <NotificationsFeedPage />
},
```
![Alt text](../journal_images/app%20js%20notification%20add.png)

## Refrence  
https://www.youtube.com/watch?v=k-_o0cCpksk

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

Example of using DynamoDB local
https://github.com/100DaysOfCloud/challenge-dynamodb-local

Dynamodb Local emulates a Dynamodb database in your local envirmoment
for rapid developement and table design interation

## Run Docker Local

```
docker-compose up
```

## Create a table

```sh
aws dynamodb create-table \
    --endpoint-url http://localhost:8000 \
    --table-name Music \
    --attribute-definitions \
        AttributeName=Artist,AttributeType=S \
        AttributeName=SongTitle,AttributeType=S \
    --key-schema AttributeName=Artist,KeyType=HASH AttributeName=SongTitle,KeyType=RANGE \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --table-class STANDARD
```

## Create an Item

```sh
aws dynamodb put-item \
    --endpoint-url http://localhost:8000 \
    --table-name Music \
    --item \
        '{"Artist": {"S": "No One You Know"}, "SongTitle": {"S": "Call Me Today"}, "AlbumTitle": {"S": "Somewhat Famous"}}' \
    --return-consumed-capacity TOTAL  
```

## List Tables

```sh
aws dynamodb list-tables --endpoint-url http://localhost:8000
```

## Get Records

```sh
aws dynamodb scan --table-name Music --query "Items" --endpoint-url http://localhost:8000
```

## For postgres
- Install a postgress extention
- open database explorer
- select postgres from  database tab
- input the conection name
- set password as `password`
- hit connect
![Alt text](../journal_images/postgres%20setup.png)

- On the terminal
`psql Upostgres --host localhost`
when asked type:
`password`
- use the to show list 
type: `\l`
- to quit 
tpye :`\q`

![Alt text](../journal_images/postgres%20login.png)

## References
https://www.youtube.com/watch?v=CbQNMaa6zTg

https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html

https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.CLI.html


## Implementing health check in the docker compose file 

In Docker Compose, a health check is a way to check the status of a container and ensure that it is running correctly. A health check can be defined in the docker-compose.yml file for a service using the healthcheck parameter.

A health check can be a simple command that runs inside the container to verify that the service is running correctly,When a health check is defined for a service, Docker Compose will periodically run the health check and determine whether the container is healthy or not. If a container fails a health check, Docker Compose can take various actions depending on the configuration, such as restarting the container or stopping the service.

>paste the code in your dockercompose.yml file 


```sh
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
    healthcheck:
      test: ["CMD-SHELL", "curl --fail http://localhost:4567/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5
  frontend-react-js:
    environment:
      REACT_APP_BACKEND_URL: "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    build: ./frontend-react-js
    ports:
      - "3000:3000"
    volumes:
      - ./frontend-react-js:/frontend-react-js
    healthcheck:
      test: ["CMD-SHELL", "curl --fail http://localhost:3000/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5

  dynamodb-local:
    user: root
    command: "-jar DynamoDBLocal.jar -sharedDb -dbPath ./data"
    image: "amazon/dynamodb-local:latest"
    container_name: dynamodb-local
    ports:
      - "8000:8000"
    volumes:
      - "./docker/dynamodb:/home/dynamodblocal/data"
    working_dir: /home/dynamodblocal
    healthcheck:
      test: ["CMD-SHELL", "curl --fail http://localhost:8000/shell || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5

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
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 30s
      timeout: 10s
      retries: 5


networks: 
  internal-network:
    driver: bridge
    name: cruddur

volumes:
  db:
    driver: local

```
![Alt text](../journal_images/dockercompose%20%20health%20check.png)

> The healthcheck section for the backend-flask service runs a command to check the health of the service every 30 seconds, with a timeout of 10 seconds.
- run :
```sh 
docker-compose up
```
```sh
docker ps
```

![Alt text](../journal_images/docker%20health%20status.png)


>The status shows us the health of the container 




