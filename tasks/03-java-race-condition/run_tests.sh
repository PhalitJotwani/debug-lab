#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
mvn test -q -B 2>&1
