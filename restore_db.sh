#!/bin/bash -ex
cat backup.sql | psql -d language_learning_kotlin
