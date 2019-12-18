from cook import Importer
import os
from sqlalchemy import create_engine
import pandas as pd

def ETL():
    RECIPE_ENGINE = os.environ.get('RECIPE_ENGINE', '')
    BUILD_ENGINE=os.environ.get('BUILD_ENGINE', '')

    importer = Importer(RECIPE_ENGINE, BUILD_ENGINE)
    importer.import_table(schema_name='cbbr_submissions')
    importer.import_table(schema_name='dpr_parksproperties')
    importer.import_table(schema_name='doitt_buildingfootprints')

def FACDB():
    EDM_DATA = os.environ.get('EDM_DATA', '')
    BUILD_ENGINE=os.environ.get('BUILD_ENGINE', '')

    importer = Importer(EDM_DATA, BUILD_ENGINE)
    importer.import_table(schema_name='facilities')

def old_cbbr_submissions():
    engine = create_engine(os.environ['BUILD_ENGINE'])
    url = 'https://planninglabs.carto.com/api/v2/sql?skipfields=cartodb_id&q=SELECT%20*%20FROM%20cbbr_fy19_pts_v1%20UNION%20SELECT%20*%20FROM%20cbbr_fy19_poly_v1&format=csv&filename=cb-budgetrequests_complete_2019-12-17'
    df = pd.read_csv(url)
    df.to_sql('old_cbbr_submissions', engine, if_exists='replace', chunksize=10000)

if __name__ == "__main__":
    ETL()
    FACDB()
    old_cbbr_submissions()