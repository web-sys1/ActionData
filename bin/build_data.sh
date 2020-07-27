#!/bin/bash

cd $(dirname $0) /..
cd covid19 & mkdir -p data-sources

sh ./bin/update_sources.sh

# Version data
if git diff data/*.csv | grep . > /dev/null; then
  echo "Data updated!"
  git commit -m "update source data" covid-19/data-sources/*.csv

  # Build agregated data for dashboard
 python ./bin/export-main-countries.py
  git commit -m "update data" data/coronavirus-countries.json

  git push
fi
