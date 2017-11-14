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
with open('cbbr.config.json') as conf:
    config = json.load(conf)

DBNAME = config['DBNAME']
DBUSER = config['DBUSER']

# connect to postgres db
engine = sql.create_engine('postgresql://{}@localhost:5432/{}'.format(DBUSER, DBNAME))

# load necessary environment variables
app_id = os.environ['GEOCLIENT_APP_ID']
app_key = os.environ['GEOCLIENT_APP_KEY']

# read in cbbr table
cbbr = pd.read_sql_query('SELECT * FROM cbbr_submissions WHERE streetsegment IS NOT NULL AND streetcross1 IS NOT NULL AND streetcross2 IS NOT NULL AND borough IS NOT NULL AND geom IS NULL;', engine)

# replace single quotes with doubled single quotes for psql compatibility 
cbbr['streetsegment'] = [i.replace("'", "''") for i in cbbr['streetsegment']]
cbbr['streetcross1'] = [i.replace("'", "''") for i in cbbr['streetcross1']]
cbbr['streetcross2'] = [i.replace("'", "''") for i in cbbr['streetcross2']]

# get the geo data
g = Geoclient(app_id, app_key)

# address_borough from the github page. not sure why it wasn't in module
def blockface(self, onStreet, crossStreetOne, crossStreetTwo, borough, boroughCrossStreetOne=None, boroughCrossStreetTwo=None, compassDirection=None):
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
    return self._request(u'blockface', onStreet=onStreet, crossStreetOne=crossStreetOne, crossStreetTwo=crossStreetTwo, borough=borough)

# bound it to the class
Geoclient.blockface = blockface

def get_loc(onStreet, crossStreetOne, crossStreetTwo, borough):
    geo = g.blockface(onStreet, crossStreetOne, crossStreetTwo, borough)
    try:
        fromX = geo['fromXCoordinate']
    except:
        fromX = 'none'
    try:
        fromY = geo['fromYCoordinate']
    except:
        fromY = 'none'
    try:
        toX = geo['toXCoordinate']
    except:
        toX = 'none'
    try:
        toY = geo['toYCoordinate']
    except:
        toY = 'none'
    loc = pd.DataFrame({'fromX' : [fromX],
                        'fromY' : [fromY],
                        'toX' : [toX],
                        'toY' : [toY]})
    return(loc)

locs = pd.DataFrame()
for i in range(len(cbbr)):
    new = get_loc(cbbr['streetsegment'][i],
                  cbbr['streetcross1'][i],
                  cbbr['streetcross2'][i],
                  cbbr['borough'][i]
    )
    locs = pd.concat((locs, new))
locs.reset_index(inplace = True)

# update cbbr geom based on lat and long
for i in range(len(cbbr)):
    if (locs['fromX'][i] != 'none') & (locs['fromY'][i] != 'none') & (locs['toX'][i] != 'none') & (locs['toY'][i] != 'none'):
        upd = "UPDATE cbbr_submissions a SET geom = ST_Transform(ST_MakeLine(ST_MakePoint(" + str(locs['fromX'][i]) + ", " + str(locs['fromY'][i]) + "),ST_MakePoint(" + str(locs['toX'][i]) + ", " + str(locs['toY'][i]) + ")), 4326), geomsource = 'geoclient', dataname='lat long', datasource='lion' WHERE streetsegment = '" + cbbr['streetsegment'][i] + "' AND a.streetcross1 = '"+ cbbr['streetcross1'][i] + "';"
        engine.execute(upd)


# not deleting because if I ever figure it out this is probably a better way of doing this... 
#md = sql.MetaData(engine)
#table = sql.Table('sca', md, autoload=True)
#upd = table.update(values={
