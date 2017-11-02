import pandas as pd
import subprocess
import os
import sqlalchemy as sql
import json
from nyc_geoclient import Geoclient

# make sure we are at the top of the repo
wd = subprocess.check_output('git rev-parse --show-toplevel', shell = True)
os.chdir(wd[:-1]) #-1 removes \n

# load config file
with open('cpdb.config.json') as conf:
    config = json.load(conf)

DBNAME = config['DBNAME']
DBUSER = config['DBUSER']

# connect to postgres db
engine = sql.create_engine('postgresql://{}@localhost:5432/{}'.format(DBUSER, DBNAME))

# load necessary environment variables
app_id = os.environ['GEOCLIENT_APP_ID']
app_key = os.environ['GEOCLIENT_APP_KEY']

# read in lcgms table
lcgms = pd.read_sql_query('SELECT * FROM doe_facilities_lcgms WHERE primaryaddress IS NOT NULL;', engine)

# replace single quotes with doubled single quotes for psql compatibility 
lcgms['primaryaddress'] = [i.replace("'", "''") for i in lcgms['primaryaddress']]

# get the geo data
g = Geoclient(app_id, app_key)

# address_zip from the github page. not sure why it wasn't in module
def address_zip(self, houseNumber, street, zip):
    """
    Like the above address function, except it uses "zip code" instead of borough

    :param houseNumber:
            The house number to look up.
    :param street:
            The name of the street to look up
    :param zip:
            The zip code of the address to look up.

    :returns: A dict with blockface-level, property-level, and political
            information.

    """
    return self._request(u'address', houseNumber=houseNumber, street=street, zip=zip)

# bound it to the class
Geoclient.address_zip = address_zip

def get_loc(num, street, zipc):
    geo = g.address_zip(num, street, zipc)
    try:
        b_in = geo['buildingIdentificationNumber']
    except:
        b_in = 'none'
    try:
        lat = geo['latitude']
    except:
        lat = 'none'
    try:
        lon = geo['longitude']
    except:
        lon = 'none'
    loc = pd.DataFrame({'bin' : [b_in],
                        'lat' : [lat],
                        'lon' : [lon]})
    return(loc)

locs = pd.DataFrame()
for i in range(len(lcgms)):
    new = get_loc(lcgms['primaryaddress'][i].split(' ',1)[0],
                  lcgms['primaryaddress'][i].split(' ',1)[1],
                  lcgms['zip'][i]
    )
    locs = pd.concat((locs, new))
locs.reset_index(inplace = True)

# update lcgms geom based on bin
for i in range(len(lcgms)):
    if locs['bin'][i] != 'none': 
        upd = "UPDATE doe_facilities_lcgms a SET geom = ST_Centroid(b.geom) FROM doitt_buildingfootprints b WHERE a.primaryaddress = '"+ lcgms['primaryaddress'][i] + "' AND b.bin = '"+ locs['bin'][i] + "';"
        engine.execute(upd)
    elif (locs['lat'][i] != 'none') & (locs['lon'][i] != 'none'):
        upd = "UPDATE doe_facilities_lcgms a SET geom = ST_SetSRID(ST_MakePoint(" + str(locs['lon'][i]) + ", " + str(locs['lat'][i]) + "), 4326) WHERE primaryaddress = '" + lcgms['primaryaddress'][i] + "';"
        engine.execute(upd)


# not deleting because if I ever figure it out this is probably a better way of doing this... 
#md = sql.MetaData(engine)
#table = sql.Table('sca', md, autoload=True)
#upd = table.update(values={
