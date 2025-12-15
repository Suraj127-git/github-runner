#!/bin/sh
set -e

if [ -z "$GITHUB_RUNNER_URL" ]; then
  echo "GITHUB_RUNNER_URL is required"
  exit 1
fi

if [ -z "$GITHUB_RUNNER_TOKEN" ]; then
  echo "GITHUB_RUNNER_TOKEN is required"
  exit 1
fi

if [ -z "$GITHUB_RUNNER_NAME" ]; then
  GITHUB_RUNNER_NAME=$(hostname)
fi

if [ -z "$GITHUB_RUNNER_WORKDIR" ]; then
  GITHUB_RUNNER_WORKDIR=_work
fi

cd /actions-runner

echo "Using GITHUB_RUNNER_URL=$GITHUB_RUNNER_URL"
echo "Using GITHUB_RUNNER_NAME=$GITHUB_RUNNER_NAME"
echo "Using GITHUB_RUNNER_WORKDIR=$GITHUB_RUNNER_WORKDIR"
if [ -n "$GITHUB_RUNNER_LABELS" ]; then
  echo "Using GITHUB_RUNNER_LABELS=$GITHUB_RUNNER_LABELS"
fi

if [ ! -f .runner ]; then
  if [ -n "$GITHUB_RUNNER_LABELS" ]; then
    ./config.sh --unattended --url "$GITHUB_RUNNER_URL" --token "$GITHUB_RUNNER_TOKEN" --name "$GITHUB_RUNNER_NAME" --work "$GITHUB_RUNNER_WORKDIR" --labels "$GITHUB_RUNNER_LABELS" --replace
  else
    ./config.sh --unattended --url "$GITHUB_RUNNER_URL" --token "$GITHUB_RUNNER_TOKEN" --name "$GITHUB_RUNNER_NAME" --work "$GITHUB_RUNNER_WORKDIR" --replace
  fi
fi

cleanup() {
  ./config.sh remove --unattended --token "$GITHUB_RUNNER_TOKEN"
}

trap 'cleanup; exit 0' INT TERM

./run.sh "$@" &
wait $!
