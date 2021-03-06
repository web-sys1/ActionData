#!/bin/bash

# World JHU data
for typ in confirmed deaths recovered; do
  curl -sfL https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_${typ}_global.csv > covid19/data_sources/time_series_covid19_${typ}_global.csv  | bash
done;

# USA JHU data
for typ in confirmed deaths; do
  curl -sfL https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_${typ}_US.csv > covid19/data_sources/time_series_covid19_${typ}_US.csv  | bash
done;

# Italy official data
curl -sfL https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv > covid19/data_sources/dpc-covid19-ita-regioni.csv  | bash

# Spain official data
curl -sfL https://covid19.isciii.es/resources/serie_historica_acumulados.csv > covid19/data_sources/serie_historica_acumulados.csv
if ! head -2 covid19/data_sources/serie_historica_acumulados.csv | tail -1 | grep 2020 > /dev/null; then
  echo "WARNING: Spain data is missing dates"
  git checkout -- covid19/data_sources/serie_historica_acumulados.csv
fi
LC_ALL=C sed -n '/NOTA.*/q;p' covid19/data_sources/serie_historica_acumulados.csv > covid19/data_sources/spain.csv

# France official data
curl -sfL https://raw.githubusercontent.com/opencovid19-fr/data/master/dist/chiffres-cles.csv > covid19/data_sources/chiffres-cles.csv

# UK official data
curl -sfL https://raw.githubusercontent.com/tomwhite/covid-19-uk-data/master/data/covid-19-indicators-uk.csv > covid19/data_sources/covid-19-indicators-uk.csv
python ./bin/consolidate_uk.py > covid19/data_sources/uk.csv

# Germany official data
curl -sfL https://raw.githubusercontent.com/micgro42/COVID-19-DE/master/time_series/time-series_19-covid-Confirmed.csv > covid19/data_sources/time_series_covid19_confirmed_Germany.csv
curl -sfL https://raw.githubusercontent.com/micgro42/COVID-19-DE/master/time_series/time-series_19-covid-Deaths.csv > covid19/data_sources/time_series_covid19_deaths_Germany.csv
python ./bin/consolidate_germany.py > covid19/data_sources/germany.csv  | bash


# Population data
curl -sfL "https://docs.google.com/spreadsheets/d/1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0/export?format=csv&id=1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0&gid=0" > covid19/data_sources/population-World.csv
curl -sfL "https://docs.google.com/spreadsheets/d/1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0/export?format=csv&id=1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0&gid=1662739553" > covid19/data_sources/population-Australia.csv
curl -sfL "https://docs.google.com/spreadsheets/d/1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0/export?format=csv&id=1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0&gid=702355833" > covid19/data_sources/population-China.csv
curl -sfL "https://docs.google.com/spreadsheets/d/1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0/export?format=csv&id=1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0&gid=88045307" > covid19/data_sources/population-Canada.csv
curl -sfL "https://docs.google.com/spreadsheets/d/1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0/export?format=csv&id=1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0&gid=334671180" > covid19/data_sources/population-Italy.csv
curl -sfL "https://docs.google.com/spreadsheets/d/1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0/export?format=csv&id=1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0&gid=117825319" > covid19/data_sources/population-Spain.csv
curl -sfL "https://docs.google.com/spreadsheets/d/1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0/export?format=csv&id=1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0&gid=1500184457" > covid19/data_sources/population-UK.csv
curl -sfL "https://docs.google.com/spreadsheets/d/1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0/export?format=csv&id=1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0&gid=2101017542" > covid19/data_sources/population-Germany.csv
curl -sfL "https://docs.google.com/spreadsheets/d/1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0/export?format=csv&id=1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0&gid=1101367004" > covid19/data_sources/population-France.csv
curl -sfL "https://docs.google.com/spreadsheets/d/1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0/export?format=csv&id=1e703pe3GmBQt0i2yAOS0F6Bhxy91U1-NTB6JMRSTzc0&gid=1285380985" > covid19/data_sources/population-USA.csv


# Checkout bad files from errored queries
find covid19/data_sources -size 0 -exec git checkout -- {} \;

