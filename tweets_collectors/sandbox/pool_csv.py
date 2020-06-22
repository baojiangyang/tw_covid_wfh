import tweepy
import csv
import json
import pandas as pd
import sys

if(False):
    df1 = pd.read_csv('')
    df2 = pd.read_csv('.csv')
    df3 = pd.read_csv('.csv')
    df4 = pd.read_csv('.csv')
    df5 = pd.read_csv('.csv')

    df = df1.append([df2, df3, df4, df5])
    print(df.head(5))
    print(df.shape)
    df.to_csv('output_data/wfh_0301_0601.csv')

## wfh
if(False):
    df1 = pd.read_csv('wfh_2019-03-01_2019-03-15.csv')
    df2 = pd.read_csv('wfh_2019-03-15_2019-06-01.csv')
    df3 = pd.read_csv('wfh_2020-03-01_2020-03-15.csv')
    df4 = pd.read_csv('wfh_2020-03-15_2020-05-03.csv')
    df5 = pd.read_csv('wfh_2020-05-03_2020-06-02.csv')

    df = df1.append([df2, df3, df4, df5])
    print(df.head(5))
    print(df.shape)
    df.to_csv('output_data/wfh_0301_0601.csv')

## work from home
if(False):
    df1 = pd.read_csv('work_from_home_2019-03-01_2019-06-01.csv')
    df2 = pd.read_csv('work_from_home_2020-03-01_2020-03-15.csv')
    df3 = pd.read_csv('work_from_home_2020-03-15_2020-05-03.csv')
    df4 = pd.read_csv('work_from_home_2020-05-03_2020-06-02.csv')

    df = df1.append([df2, df3, df4])
    print(df.head(5))
    print(df.shape)
    df.to_csv('output_data/work_from_home_0301_0601.csv')


## working from home
if(False):
    df1 = pd.read_csv('working_from_home_2019-03-01_2019-06-01.csv')
    df2 = pd.read_csv('working_from_home_2020-03-01_2020-03-15.csv')
    df3 = pd.read_csv('working_from_home_2020-03-15_2020-04-19.csv')
    df4 = pd.read_csv('working_from_home_2020-04-19_2020-05-02.csv')
    df5 = pd.read_csv('working_from_home_2020-05-02_2020-05-03.csv')
    df6 = pd.read_csv('working_from_home_2020-05-03_2020-06-02.csv')
    df = df1.append([df2, df3, df4, df5, df6])
    print(df.head(5))
    print(df.shape)
    df.to_csv('output_data/working_from_home_0301_0601.csv')


## work remotely
if(False):
    df1 = pd.read_csv('work_remotely_2019-03-01_2019-06-01.csv')
    df2 = pd.read_csv('work_remotely_2020-03-01_2020-03-15.csv')
    df3 = pd.read_csv('work_remotely_2020-03-15_2020-05-03.csv')
    df4 = pd.read_csv('work_remotely_2020-05-03_2020-06-02.csv')

    df = df1.append([df2, df3, df4])
    print(df.head(5))
    print(df.shape)
    df.to_csv('output_data/work_remotely_0301_0601.csv')



## working remotely
if(False):
    df1 = pd.read_csv('working_remotely_2019-03-01_2019-06-01.csv')
    df2 = pd.read_csv('working_remotely_2020-03-01_2020-03-15.csv')
    df3 = pd.read_csv('working_remotely_2020-03-15_2020-05-03.csv')
    df4 = pd.read_csv('working_remotely_2020-05-03_2020-05-07.csv')
    df5 = pd.read_csv('working_remotely_2020-05-07_2020-06-02.csv')

    df = df1.append([df2, df3, df4, df5])
    print(df.head(5))
    print(df.shape)
    df.to_csv('output_data/working_remotely_0301_0601.csv')



## remote work
if(False):
    df1 = pd.read_csv('remote_work_2019-03-01_2019-06-01.csv')
    df2 = pd.read_csv('remote_work_2020-03-01_2020-03-15.csv')
    df3 = pd.read_csv('remote_work_2020-03-15_2020-05-03.csv')
    df4 = pd.read_csv('remote_work_2020-05-03_2020-06-02.csv')

    df = df1.append([df2, df3, df4])
    print(df.head(5))
    print(df.shape)
    df.to_csv('output_data/remote_work_0301_0601.csv')


## remote working

if(True):
    df1 = pd.read_csv('remote_working_2019-03-01_2019-06-01.csv')
    df2 = pd.read_csv('remote_working_2020-03-01_2020-03-15.csv')
    df3 = pd.read_csv('remote_working_2020-03-15_2020-06-02.csv')

    df = df1.append([df2, df3])
    print(df.head(5))
    print(df.shape)
    df.to_csv('output_data/remote_working_0301_0601.csv')
