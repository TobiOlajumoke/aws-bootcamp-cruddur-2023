FROM python:3.10-slim-buster

# Inside the container
# Make a new folder inside container
WORKDIR /backend-flask

# Outside the container -> inside container
# This contains the libaries we want to install to run the app
COPY requirements.txt requirements.txt

# Inside container
# Install the python libaries used for the app
RUN pip3 install -r requirements.txt

# Outside the container -> inside container
# . means in the current directory
# First period . - /backend-flask (outside container)
# Second period .  /backend-flask (inside container)
COPY . .

# Set Environment vairables (Env Vars)
# Inside container and will remain set when the container is running
ENV FLASK_ENV=development

EXPOSE ${PORT}

# CMD (Command)
# python3 -m  flask  run --host=0.0.0.0  --port=4567
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=4567"]