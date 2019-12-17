from cook import Importer
import os
import time

def ETL():
    RECIPE_ENGINE = os.environ.get('RECIPE_ENGINE', '')
    BUILD_ENGINE=os.environ.get('BUILD_ENGINE', '')

    importer = Importer(RECIPE_ENGINE, BUILD_ENGINE)
    importer.import_table(schema_name='cbbr_submissions')
    importer.import_table(schema_name='dpr_parksproperties')

def FACDB():
    RECIPE_ENGINE = os.environ.get('EDM_DATA', '')
    BUILD_ENGINE=os.environ.get('BUILD_ENGINE', '')

    importer = Importer(RECIPE_ENGINE, BUILD_ENGINE)
    importer.import_table(schema_name='facilities')

if __name__ == "__main__":
    ETL()
    FACDB()