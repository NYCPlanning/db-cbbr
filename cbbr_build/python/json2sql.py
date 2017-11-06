#!/usr/bin/python
'''
USAGE: ./json2sql.py regid regid.json

'''
import re
import json
import sys
import os

# load config file
with open('cbbr_build/cbbr.config.json') as conf:
    config = json.load(conf)

DBNAME = config['DBNAME']
DBUSER = config['DBUSER']

# assign command line parameters
regid = sys.argv[1]
input_file = sys.argv[2]

with open(input_file) as data_file:
    data = json.load(data_file)

sql_cmd =re.escape("UPDATE cbbr_submissions " +\
                   "SET geomsource = 'dcp_geojson', " +\
                   '''geom = ST_SetSRID(ST_GeomFromGeoJSON('{"type":"''' + str(data['type']) + '''","coordinates":''' + str(data['coordinates']) + '''}'),4326) ''' +\
                   "WHERE regid = '" + regid + "';")

    
sys_cmd = "psql -U {} -d{} -c ".format(DBUSER, DBNAME) + sql_cmd
os.system(sys_cmd)
