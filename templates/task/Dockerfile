FROM ubuntu:22.04

# Install tools here
# RUN apt-get update && apt-get install -y ...

WORKDIR /workspace
COPY . /workspace/

# Make scripts executable
RUN chmod +x /workspace/run_tests.sh
