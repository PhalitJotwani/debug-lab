FROM python:3.11.7-slim

WORKDIR /workspace

RUN pip install --no-cache-dir pytest

COPY . /workspace/

RUN chmod +x run_tests.sh
