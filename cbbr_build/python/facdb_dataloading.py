from sqlalchemy import create_engine
from pathlib import Path
import pandas as pd
import numpy as np
import os 

if __name__ == '__main__':
    # connect to postgres db
    edm_data = create_engine(os.environ['EDM_DATA'])
    engine = create_engine(os.environ['BUILD_ENGINE'])

    df = pd.read_sql('SELECT * FROM facilities.latest', edm_data)
    df.to_sql('facdb_facilities', engine, if_exists='replace', chunksize=10000)
    