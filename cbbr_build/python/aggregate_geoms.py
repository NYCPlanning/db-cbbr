from sqlalchemy import create_engine
from pathlib import Path
import os
import json
import pandas as pd

if __name__ == '__main__':
    engine = create_engine(os.environ['BUILD_ENGINE'])

    sourcePath = Path(__file__).resolve().parent.parent/'geometries'
    json_data = [sourcePath/each for each in os.listdir(sourcePath) if each.endswith('.json')]
    data = []
    for f in json_data:
        with open(f,encoding='utf-8', errors='ignore') as json_data:
            info = json.load(json_data, strict=False)
        name = str(f)[str(f).find('geometries/')+len('geometries/'):-5]
        result = dict(
            regid = name,
            type = info['type'], 
            geom = info['coordinates']
        )
        data.append(result)

    df = pd.DataFrame.from_dict(data)
    df.to_sql('cbbr_geoms', engine, if_exists='replace', chunksize=10000)
