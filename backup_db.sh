#!/bin/bash -ex
pg_dump --clean -d language_learning_kotlin > backup.sql
