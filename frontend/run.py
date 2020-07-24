#Author: Klaus

from selenium import webdriver
import time
import re
import requests
from selenium.webdriver.chrome.options import Options
import matplotlib.pyplot as plt


class covidData:
    def __init__(self):
        self.chrome_options = Options()
        self.chrome_options.add_argument("--headless")
        self.driver = webdriver.Chrome(options=self.chrome_options)
        self.driver.set_window_size(1000, 30000)
        self.country=None
        self.countryCode = {}
        self.getCountryCode()
        self.countryCase = {}
        self.date = []
        self.newAdd = []
        self.newDeath = []
        self.totalCas=[]
        self.totalRec=[]
        self.totalDea=[]
        self.countryNews = {}
        self.getNews()

    def getCountryCode(self):
        self.driver.get('https://thevirustracker.com/api#indexpage')
        countries = self.driver.find_elements_by_xpath("//table[@id='indexpage']/tbody/tr/td")
        for i in range(len(countries)//3):
            self.countryCode[countries[i*3].text] = countries[1+(i*3)].text[:2]

    def showCountry(self):
        for cc in self.countryCode:
            print(cc + ': '+self.countryCode[cc])

    def getTimeline(self,country):
        self.country=country
        html = requests.get('https://api.thevirustracker.com/free-api?countryTimeline={}'.format(self.countryCode[country])).text
        self.date = re.findall(r'\d+/\d+/\d+',html)
        self.newAdd = re.findall(r'"new_daily_cases":(-\d+|\d+)',html)
        self.newDeath = re.findall(r'"new_daily_deaths":(-\d+|\d+)',html)
        self.totalCas = re.findall(r'"total_cases":(-\d+|\d+)',html)
        self.totalRec=re.findall(r'"total_recoveries":(-\d+|\d+)',html)
        self.totalDea=re.findall(r'"total_deaths":(-\d+|\d+)',html)
        i = len(self.date)-1
        while i>0:
            if len(self.date)==len(self.newAdd)==len(self.newDeath)==len(self.totalCas)==len(self.totalRec)==len(self.totalDea):
                print("Date: {}; New case: {}; New death: {}; total: {}; total recovery: {}; total death:{}".format\
                          (self.date[i],self.newAdd[i],self.newDeath[i],self.totalCas[i],self.totalRec[i],self.totalDea[i]))
            i=i-1

    def getNews(self):
        self.driver.get('https://www.imf.org/en/Topics/imf-and-covid19/Policy-Responses-to-COVID-19')
        countries = self.driver.find_elements_by_xpath("//h3")
        for country in countries:
            text = country.text.split(",")[0]
            new = self.driver.find_elements_by_xpath("//h3[contains(text(),'{}')]/following-sibling::p".format(text))
            new = new[0].text.replace(".",".\n")
            self.countryNews[(country.text).split(",")[0]] = new

    def showNews(self,country):
        if country=='USA':
            country='United States of America'
        print(self.countryNews[country])

    def drawGraph(self,country,dataType):
        self.getTimeline(country)
        x = self.date
        if dataType =='case':
            y=self.totalCas
        elif dataType =='recover':
            y=self.totalRec
        elif dataType == 'death':
            y=self.totalDea
        else:
            return "Error Data Type"
        plt.plot(x,y)
        plt.xlabel('Timeslot')
        plt.ylabel('Total Case')
        plt.title(country + '-' + dataType)
        plt.axis('off')
        plt.show()



if __name__ == '__main__':
    help = '---------------------------------------------------------------------------------------\n' \
           'select options:\n' \
           '1.help                          - show help interface. Input help can get this page as well\n' \
           '2.get $country                  - input the country you want to get data\n' \
           '3.show countries                - show available countries and Code\n' \
           '4.get country news              - get covid news of a country\n' \
           '5.get data graph                - draw data graph of data\n' \
           '6.exit                          - exit program. Input exit can quit\n'
    print('Initializing, please wait')
    a = covidData()
    print(help)
    command = input('Please input command:\n')
    while command != 'exit' or command!='6':
        if command=='1' or command=='help':
            print(help)
        elif command == 'show countries' or command=='3':
            a.showCountry()
        elif command=='2':
            country=input("please input a country:\n")
            condition=True
            while condition:
                try:
                    a.getTimeline(country)
                    condition=False
                except:
                    print('Please input a valid country name')
                    command = input('Please input a country:\n')

        elif command == '4':
            country = input("please input a country:\n")
            condition = True
            while condition:
                try:
                    a.showNews(country)
                    condition = False
                except:
                    print('Please input a valid country name')
                    command = input('Please input a country:\n')
        elif command == '5':
            country = input("Please input a country:\n")
            dataType = input("Please select a data type-('case','recover','death'):\n")
            while True:
                result = a.drawGraph(country, dataType)
                if result == 'Error Data Type':
                    print(result)
                    dataType = input("Please select a data type-('case','recover','death')")
                else:
                    break

        command = input('Please input command:\n')
    print('Enjoy the program')
