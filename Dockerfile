# Use the Python 3.10 slim-buster base image
FROM python:3.8

# Switch to the root user
USER root

# Set the working directory inside the container
WORKDIR /src

# Copy the requirements.txt file to the container
COPY ./analytics/requirements.txt requirements.txt

# Install Python dependencies from requirements.txt
RUN pip install -r requirements.txt

# Copy the entire analytics directory to the container
COPY ./analytics .

# Start the PostgreSQL service and run the Flask application
CMD service postgresql start && python app.py