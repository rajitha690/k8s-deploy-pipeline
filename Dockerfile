FROM python:3.9-slim

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt
RUN pip install gunicorn

CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
