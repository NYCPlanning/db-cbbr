# db-cbbr - Community Board Budget Requests Database

The Community Board Budget Requests Database, a data product produced by the New York City Department of City Planning (DCP), is based on requests for future capital or expense projects submitted by each of NYC's 59 Community Boards to DCP.  DCP then disseminates this information to the Office of Management and Budget and each of NYC's agencies.  DCP adds value to the submitted budget requests by creating geometries where possible for requested projects, in the effort to map as many budget requests as possible.

The Community Board Budget Requests Database is a way to quickly and easily explore and learn about projects requested by NYC's 59 Community Boards.  It’s main purpose is to be a starting point for exploring potential projects and to better understand communities' perceived needs across NYC.  The spatial data provides an integrated view enabling a broad understanding of where communities have requested investments, and reveals opportunities for strategic neighborhood planning.

#### Limitations
The spatial data are not 100% reliable, accurate, or exhaustive

CBBR is primarly built for planning coordination and information purposes only

## How to build the Community Board Budget Requests Database

### Prerequisites:

1. Bash > 4.0

2. node.js

3. psql 9.5.5

4. Ability to attach PostGIS extension and the fuzzystrmatch extension to postgres databases
   
5. If psql role you intend to use is not your unix name, set up a .pgpass file like this:
    *:*:*:dbadmin:dbadmin_password
    ~/.pgpass should have permissions 0600 (chmod 0600 ~/.pgpass)

6. FTP set up:
 ~/.netrc should include: machine 23.246.114.130 login [login] password [pw]
 ~/.netrc permissions should be 0600 (chmod 0600 ~/.netrc)

7. python modules
- xmltodict
- shapely
- pandas
- geopandas
- subprocess
- os
- sqlalchemy
- nyc-geoclient
https://github.com/talos/nyc-geoclient - py2 only
https://github.com/ResidentMario/nyc-geoclient - py3 but didn't work?

8. python setup
python should run Anaconda Python 3+

There also needs to be a python 2 conda environment named py2
py2 needs:
- pandas
- subprocess
- os
- sqlalchemy
- nyc_geoclient

### Development workflow

Fill in configuration files:

#### cbbr.config.json

Your config file should look something like this:
{
"DBNAME":"databasename",
"DBUSER":"databaseuser",
"GEOCLIENT_APP_ID":"id",
"GEOCLIENT_APP_KEY":"key"
}

#### Prepare data-loading-scripts

Clone and properly configure the data-loading-scripts repo: https://github.com/NYCPlanning/data-loading-scripts 
Make sure the database data-loading-scripts uses is the same one you listed in your cbbr.config.json file.

#### Community Board Budget Requests Database Build Process

Run the scripts in cbbr_build in order:

#### 01_dataloading.sh
This script runs the data-loading-scripts scripts for the datasets needed.  In addition to loading the raw cbbr data this script loads other dependent datasets.

#### 02_cbbr.sh
Create the primary cbbr table based on the source data.

#### 03_spatial.sh
Add geometries onto the Community Board Budget Requests.
Steps:
* Geocode records by address, bbl, intersection, or street segment via GeoClient
* Append geometries that were created manually
* Match on DPR's parks properties dataset for DCP's facilities databse

#### 04_export.sh
Export geojson and csv files for Carto
