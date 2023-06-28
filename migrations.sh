#!/bin/bash

docker-compose up -d postgres_db
cd api
make sam db:setup