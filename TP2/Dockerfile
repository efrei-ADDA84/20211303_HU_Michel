FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8-slim

WORKDIR /app

COPY TP2.py .

RUN pip install fastapi
RUN pip install requests
RUN pip install uvicorn

CMD ["python", "TP2.py"]