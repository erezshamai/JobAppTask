FROM python:3.12-slim
WORKDIR /app
COPY docker/web/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY ../../app .
CMD ["python", "main.py"]