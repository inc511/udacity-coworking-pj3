# Use the Python 3.10 slim-buster base image
FROM python:3.10

# Switch to the root user
USER root

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements.txt file to the container
COPY ./analytics/. /app

# Install Python dependencies from requirements.txt
RUN pip install -r requirements.txt

# Make port 5153 available to the world outside this container
EXPOSE 5153

# Copy the entire analytics directory to the container
COPY ./analytics .

# Run app.py when the container launches
CMD ["sh", "-c", "DB_USERNAME=postgres DB_PASSWORD=42qtvLkHH0 python app.py"]