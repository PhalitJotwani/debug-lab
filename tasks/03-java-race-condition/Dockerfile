FROM eclipse-temurin:17.0.9_9-jdk

RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY . /workspace/

RUN cd /workspace/repo && mvn dependency:resolve -q
RUN chmod +x /workspace/run_tests.sh
