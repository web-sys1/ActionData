#!/bin/bash


# Vaccination data
curl -sfL "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.csv" > covid19/data_sources/vaccinations.csv
python3 ./bin/consolidate_vaccines.py > covid19/data_sources/vaccines.csv

# World JHU data
for typ in confirmed deaths recovered; do
  curl -sfL https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_${typ}_global.csv > covid19/data_sources/time_series_covid19_${typ}_global.csv
done;

# USA JHU data
for typ in confirmed deaths; do #testing was removed.
  curl -sfL https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_${typ}_US.csv > covid19/data_sources/time_series_covid19_${typ}_US.csv
done;

# Italy official data
curl -sfL https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv > covid19/data_sources/dpc-covid19-ita-regioni.csv

# Spain official data
curl -sfL https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv > covid19/data_sources/casos_hosp_uci_def_sexo_edad_provres.csv
python3 ./bin/consolidate_spain.py > covid19/data_sources/spain.csv

# France official data
curl -sfL https://raw.githubusercontent.com/opencovid19-fr/data/master/dist/chiffres-cles.csv > covid19/data_sources/chiffres-cles.csv
curl -sfL https://dashboard.covid19.data.gouv.fr/data/code-FRA.json > covid19/data_sources/france-ehpad.json
for typ in deces hospitalisations soins_critiques retour_a_domicile cas_positifs vaccins_premiere_dose vaccins_vaccines; do
  curl -sfL https://data.widgets.dashboard.covid19.data.gouv.fr/$typ.json > covid19/data_sources/france-$typ.json
done
python3 ./bin/consolidate_france.py

# UK official data
curl -sfL "https://api.coronavirus.data.gov.uk/v2/data?areaType=nation&metric=covidOccupiedMVBeds&metric=cumCasesBySpecimenDate&metric=cumDeaths28DaysByDeathDate&metric=hospitalCases&format=csv" > covid19/data_sources/covid-19-indicators-uk.csv
curl -sfL "https://api.coronavirus.data.gov.uk/v2/data?areaType=nation&metric=cumPeopleVaccinatedCompleteByVaccinationDate&metric=cumPeopleVaccinatedCompleteByPublishDate&metric=cumPeopleVaccinatedFirstDoseByVaccinationDate&metric=cumPeopleVaccinatedFirstDoseByPublishDate&format=csv" > covid19/data_sources/covid-19-vaccines-uk.csv
python3 ./bin/consolidate_uk.py > covid19/data_sources/uk.csv

# Germany official data
curl -sfL "https://opendata.arcgis.com/api/v3/datasets/dd4580c810204019a7b8eb3e0b329dd6_0/downloads/data?format=csv&spatialRefId=4326" > covid19/data_sources/covid-germany-landkreisen.csv
python3 ./bin/consolidate_germany.py > covid19/data_sources/germany.csv
rm -f covid19/data_sources/covid-germany-landkreisen.csv

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
