FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl ca-certificates tar docker.io && rm -rf /var/lib/apt/lists/*

WORKDIR /actions-runner

ARG RUNNER_VERSION=2.320.0

RUN curl -L --retry 5 --retry-delay 3 https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -o actions-runner.tar.gz && tar xzf actions-runner.tar.gz && rm actions-runner.tar.gz

RUN ./bin/installdependencies.sh

COPY runner-entrypoint.sh /runner-entrypoint.sh

RUN chmod +x /runner-entrypoint.sh

RUN useradd -m runner && chown -R runner:runner /actions-runner && usermod -aG docker runner

USER runner

ENTRYPOINT ["/runner-entrypoint.sh"]
