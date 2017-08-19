#!/bin/bash -ex
pg_dump -d language_learning_kotlin -t exposures > exposures.sql
