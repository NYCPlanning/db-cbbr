import geopandas as gpd 
import pandas as pd
from pathlib import Path
from sqlalchemy import create_engine

# connect to postgres db
engine = create_engine(os.environ['BUILD_ENGINE'])
df = pd.read_sql('SELECT * FROM cbbr_submissions', engine)

geojson_filename = "final_mapped_CBBR_FY21.geojson"
geojson_path = Path(__file__).resolve().parent.parent/'geometries'/geojson_filename
gdf = gpd.read_file(geojson_path)[['unique_id','geometry']]

df_both = df.merge(gdf, how='left', on='unique_id')
df_both.loc[df_both['geometry'] != None, geom] = df_both['geometry']

