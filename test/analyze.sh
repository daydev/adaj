#!/bin/bash

set -e

results=$(dartanalyzer lib/adaj.dart)

echo "$results"
if [[ "$results" == *"warnings found"* || "$results" == *"error"* ]]; then
  exit 1
fi


