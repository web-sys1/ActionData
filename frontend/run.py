# -*- coding: utf-8 -*-
"""
Spyder Editor
This is a python script to see how a Country is performing the managment of the COVID-19 cases
"""

import requests
import pandas as pd
from datetime import date, timedelta
import matplotlib.pyplot as plt
import numpy as np
from countryinfo import CountryInfo
import os



def make_graph(country, start_date, show_score = False):
    header = ['Province/State','Country/Region','Last Update','Confirmed','Deaths','Recovered','Latitude','Longitude']
    countries_split_in_provinces =  ['US', 'China', 'Canada', 'Australia']
    raw_link = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/{}.csv'
    end_date = date.today()
    delta = end_date - start_date
    graph_path = os.path.join(os.path.dirname(__file__), 'graph')
    data = list()
    
    if show_score:
        try:
            population = CountryInfo(country).population()
        except:
            country_correction = {'US': 'United States'}
            population = CountryInfo(country_correction[country]).population()
    
    for i in range(delta.days + 1):
        day = (start_date + timedelta(days=i)).strftime('%m-%d-%Y')
        r = requests.get(raw_link.format(day))
        
        if r.status_code == 404:
            break
        
        if country in countries_split_in_provinces:
            sub_total = {'posit':0, 'death':0, 'recov':0}
        
        rows = r.text.splitlines()
        for row in rows:
            if country in row:
                row_slice = row.split(',')
                
                # Some country have a comma that creates troubble
                if len(row_slice) == 7 or len(row_slice) == 9:
                    row_slice[0:2] = [''.join(row_slice[0:2])]

                if country in countries_split_in_provinces:
                    sub_total['posit'] += int(row_slice[3])
                    sub_total['death'] += int(row_slice[4])
                    sub_total['recov'] += int(row_slice[5])

        if country in countries_split_in_provinces:
            row_slice[3]= sub_total['posit']
            row_slice[4]= sub_total['death']
            row_slice[5]= sub_total['recov']
        
        try:
            data.append(row_slice)
        except:
            pass
    
    df = pd.DataFrame(data, columns=header)
    #df = df.drop(columns= ['Province/State','Country/Region','Latitude', 'Longitude'])
    df = df.drop(columns= ['Latitude', 'Longitude'])
    
    df['Confirmed'] = df['Confirmed'].astype('int')
    df['Recovered'] = df['Recovered'].astype('int')
    df['Deaths'] = df['Deaths'].astype('int')
    
    for i in range(1, df.shape[0]):
        if i == 1:
            df.at[0, 'Positives'] = df.at[0,'Confirmed'] - (df.at[0,'Recovered'] + df.at[0,'Deaths'])
            df.at[0, 'Last Update'] = df.at[0,'Last Update'][5:10]
            
        # Today
        t_confirmed = df.at[i,'Confirmed']
        t_recovered = df.at[i,'Recovered']
        t_deaths = df.at[i,'Deaths']
        t_positives = t_confirmed - (t_recovered + t_deaths)
        df.at[i, 'Positives'] = t_positives
        
        # Yesterday
        y_confirmed = df.at[i-1,'Confirmed']
        y_recovered = df.at[i-1,'Recovered']
        y_deaths = df.at[i-1,'Deaths']
        
        # Daily
        d_confirmed = t_confirmed - y_confirmed
        df.at[i, 'D-Confirmed'] = d_confirmed
        d_recovered = t_recovered - y_recovered
        df.at[i, 'D-Recovered'] = d_recovered
        d_deaths = t_deaths - y_deaths
        df.at[i, 'D-Deaths'] = d_deaths
        
        df.at[i, 'Last Update'] = df.at[i,'Last Update'][5:10]
        
        if show_score:
            # Edits for the score calulation
            if d_recovered <= 0: d_recovered = 0.1
            if d_confirmed <= 0: d_confirmed = 0.1
            if d_deaths <= 0: d_deaths = 0.1
            df.at[i, 'Score'] = round((d_recovered/t_positives)/((d_confirmed/(population/10000)) * (d_deaths/t_positives)))    
    
    df = df.fillna(0)
    df['Positives'] = df['Positives'].astype('int')
    df['D-Confirmed'] = df['D-Confirmed'].astype('int')
    df['D-Recovered'] = df['D-Recovered'].astype('int')
    df['D-Deaths'] = df['D-Deaths'].astype('int')
    if show_score:
        df['Score'] = df['Score'].astype('int')
    
    #print(df.to_string())
    
    bar_width = 0.2
    opacity = 0.7
    steps = bar_width * 3 + bar_width # between a group of three bars
    index = np.arange(0, df.shape[0]/(1/steps), steps) # position of the x-element on the plot
    
    fig, ax1 = plt.subplots()
    plt.xticks(index, df['Last Update'].to_list(), rotation=45)
    plt.xlabel('Date')
    plt.title('COVID-19 Infections in {}'.format(country))
    
    # Axis 1: Cases
    ax1.set_ylabel('Cases')
    ax1.bar(index, df['D-Confirmed'].to_list(), bar_width, color='b', alpha=opacity, label='Confirmed')
    ax1.bar(index + bar_width, df['D-Recovered'].to_list(), bar_width, color='g', alpha=opacity, label='Recovered')
    ax1.bar(index + bar_width * 2, df['D-Deaths'].to_list(), bar_width, color='r', alpha=opacity, label='Deaths')
    
    try:
        if not os.path.exists(graph_path):
            os.mkdir(graph_path)
    except OSError:
        print('Creation of the directory failed')
        
    if show_score:
        # Axis 2: Score
        ax2 = ax1.twinx()
        ax2.set_ylabel('Score')
        ax2.plot(index, df['Score'].to_list(), color='y', alpha=opacity, label='Score')
    
        # Create a single legend
        lines1, labels1 = ax1.get_legend_handles_labels()
        lines2, labels2 = ax2.get_legend_handles_labels()
        plt.legend(lines1 + lines2, labels1 + labels2, loc='upper left')
        plt.savefig(os.path.join(graph_path, '{}_{}_score'.format(country, date.today())))
    else:
        ax1.legend(loc='upper left')
        plt.savefig(os.path.join(graph_path,'{}_{}'.format(country, date.today())))
        
    plt.show()
    print('Graph for {} updated at {} created'.format(country, date.today()))

def main():
    start_date = date(2020, 2, 24)   # start date for the graphs

    make_graph('Country', start_date)
    make_graph('King County', start_date)
    make_graph('Westchester County', start_date)
    
    make_graph('Italy', start_date)
    make_graph('Iran', start_date)
    make_graph('France', start_date)
    make_graph('South Korea', start_date)
    
    make_graph('China', start_date)
    make_graph('Hubei', start_date)
    make_graph('Zhejiang', start_date)
    
    make_graph('Canada', start_date)
    make_graph('Toronto', start_date)
    
    make_graph('Australia', start_date)

    make_graph('Italy', start_date, True)
    make_graph('China', start_date, True)

if __name__ == "__main__":
    main()
    
