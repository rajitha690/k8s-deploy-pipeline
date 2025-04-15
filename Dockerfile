FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the contents of the current directory into the /app directory in the container
COPY . .

# Install the required dependencies from requirements.txt
RUN pip install -r requirements.txt

# Install Gunicorn (production-ready WSGI server)
RUN pip install gunicorn

# Set the command to run the app using Gunicorn (binding to 0.0.0.0:5000 to accept external traffic)
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
