FROM python:3.11.7-slim

RUN apt-get update && apt-get install -y git patch && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY . /workspace/

RUN chmod +x /workspace/run_tests.sh /workspace/repo/setup_history.sh
