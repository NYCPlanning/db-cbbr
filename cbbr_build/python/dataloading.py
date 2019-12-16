from cook import Importer
import os
import time

def ETL():
    RECIPE_ENGINE = os.environ.get('RECIPE_ENGINE', '')
    BUILD_ENGINE=os.environ.get('BUILD_ENGINE', '')

    importer = Importer(RECIPE_ENGINE, BUILD_ENGINE)
    importer.import_table(schema_name='cbbr_submissions')
    importer.import_table(schema_name='dpr_parksproperties')

if __name__ == "__main__":
    beg_ts = time.time()
    ETL()
    end_ts = time.time()
    print(f'loading time: {(end_ts - beg_ts)/60:.3f} minutes')