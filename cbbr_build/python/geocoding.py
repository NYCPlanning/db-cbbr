from multiprocessing import Pool, cpu_count
from sqlalchemy import create_engine
from geosupport import Geosupport, GeosupportError
from pathlib import Path
import pandas as pd
import usaddress
import json
import re
import os
import numpy as np

g = Geosupport()

def get_hnum(address):
    address = '' if address is None else address
    result = [k for (k,v) in usaddress.parse(address) \
            if re.search("Address", v)]
    result = ' '.join(result)
    fraction = re.findall('\d+[\/]\d+', address)
    if not bool(re.search('\d+[\/]\d+', result)) and len(fraction) != 0:
           result = f'{result} {fraction[0]}' 
    return result

def get_sname(address):
    result = [k for (k,v) in usaddress.parse(address) \
            if re.search("Street", v)]  if address is not None else ''
    result = ' '.join(result)
    if result == '':
        return address
    else: 
        return result

def clean_streetname(x, n):
    x = '' if x is None else x
    if (' at ' in x.lower())|(' and ' in x.lower())|('&' in x):
        x = re.split('&| AND | and | AT | at',x)[n]
    else: x = ''
    return x

def geocode(inputs):
    hnum = inputs.get('addressnum', '')
    sname = inputs.get('streetname', '')
    borough = inputs.get('borough', '')
    street_name_1 = inputs.get('streetname_1', '')
    street_name_2 = inputs.get('streetname_2', '')
    sname = inputs.get('streetname', '')
    cross_street_1 = inputs.get('street_name', '')
    cross_street_2 = inputs.get('between_cross_street_1', '')
    cross_street_3 = inputs.get('and_cross_street_2', '')

    hnum = str('' if hnum is None else hnum)
    sname = str('' if sname is None else sname)
    borough = str('' if borough is None else borough)
    street_name_1 = str('' if street_name_1 is None else street_name_1)
    street_name_2 = str('' if street_name_2 is None else street_name_2)
    cross_street_1 = str('' if cross_street_1 is None else cross_street_1)
    cross_street_2 = str('' if cross_street_2 is None else cross_street_2)
    cross_street_3 = str('' if cross_street_3 is None else cross_street_3)

    try:
        geo = g['1B'](street_name=sname, house_number=hnum, borough=borough)
        geo = geo_parser(geo)
        geo.update(dict(geo_function='1B'))
    except GeosupportError:
        try:
            if (street_name_1 != '')&(street_name_2 != ''):
                geo = g['2'](street_name_1=street_name_1, street_name_2=street_name_2, borough_code=borough)
                geo = geo_parser(geo)
                geo.update(dict(geo_function='Intersection-1'))
            else:
                geo = g['1B'](street_name=sname, house_number=hnum, borough=borough)
                geo = geo_parser(geo)
                geo.update(dict(geo_function='1B'))
        except GeosupportError:
            try:
                if (cross_street_1 != '')&(cross_street_2 != ''):
                    geo = g['2'](street_name_1=cross_street_1, street_name_2=cross_street_2, borough_code=borough)
                    geo = geo_parser(geo)
                    geo.update(dict(geo_function='Intersection-2'))
                else:
                    geo = g['1B'](street_name=sname, house_number=hnum, borough=borough)
                    geo = geo_parser(geo)
                    geo.update(dict(geo_function='1B'))
            except GeosupportError:
                try:
                    if (cross_street_1 != '')&(cross_street_3 != ''):
                        geo = g['2'](street_name_1=cross_street_1, street_name_2=cross_street_3, borough_code=borough)
                        geo = geo_parser(geo)
                        geo.update(dict(geo_function='Intersection-3'))
                    else:
                        geo = g['1B'](street_name=sname, house_number=hnum, borough=borough)
                        geo = geo_parser(geo)
                        geo.update(dict(geo_function='1B'))
                except GeosupportError:
                    try:
                        if (cross_street_2 != '')&(cross_street_3 != ''):
                            geo = g['2'](street_name_1=cross_street_2, street_name_2=cross_street_3, borough_code=borough)
                            geo = geo_parser(geo)
                            geo.update(dict(geo_function='Intersection-4'))
                        else:
                            geo = g['1B'](street_name=sname, house_number=hnum, borough=borough)
                            geo = geo_parser(geo)
                            geo.update(dict(geo_function='1B'))
                    # except GeosupportError:
                    #     try:
                    #         if (cross_street_1 != '')&(cross_street_2 != '')&(cross_street_3 != ''):
                    #             geo = g['3'](street_name_1=cross_street_1, street_name_2=cross_street_2, street_name_3=cross_street_3, borough_code=borough)
                    #             geo = geo_parser(geo)
                    #             geo.update(dict(geo_function='Segment'))
                    #         else:
                    #             geo = g['1B'](street_name=sname, house_number=hnum, borough=borough)
                    #             geo = geo_parser(geo)
                    #             geo.update(dict(geo_function='1B'))
                    except GeosupportError as e:
                        geo = e.result
                        geo = geo_parser(geo)
                        geo.update(dict(geo_function=''))

    geo.update(inputs)
    return geo

def geo_parser(geo):
    return dict(
        geo_housenum = geo.get('House Number - Display Format', ''),
        geo_streetname = geo.get('First Street Name Normalized', ''),
        geo_bbl = geo.get('BOROUGH BLOCK LOT (BBL)', {}).get('BOROUGH BLOCK LOT (BBL)', '',),
        geo_bin = geo.get('Building Identification Number (BIN) of Input Address or NAP', ''),
        geo_latitude = geo.get('Latitude', ''),
        geo_longitude = geo.get('Longitude', ''),
        geo_x_coord = geo.get('SPATIAL COORDINATES', {}).get('X Coordinate', ''),
        geo_y_coord = geo.get('SPATIAL COORDINATES', {}).get('Y Coordinate', ''),
        geo_grc = geo.get('Geosupport Return Code (GRC)', ''),
        geo_grc2 = geo.get('Geosupport Return Code 2 (GRC 2)', ''),
        geo_reason_code = geo.get('Reason Code', ''),
        geo_message = geo.get('Message', 'msg err')
    )

if __name__ == '__main__':
    # connect to postgres db
    engine = create_engine(os.environ['BUILD_ENGINE'])

    df = pd.read_sql('SELECT * FROM cbbr_submissions', engine)
    df.rename(columns={"boro": "borough"}, inplace=True)
    df['addressnum'] = df.address.apply(get_hnum)
    df['streetname'] = df.address.apply(get_sname)
    df['streetname_1'] = df['address'].apply(lambda x: clean_streetname(x, 0))
    df['streetname_2'] = df['address'].apply(lambda x: clean_streetname(x, -1))
    df['streetname_1'] = np.where(df.streetname_1 == '',df.street_name.apply(lambda x: clean_streetname(x, 0)),df.streetname_1)
    df['streetname_2'] = np.where(df.streetname_2 == '',df.street_name.apply(lambda x: clean_streetname(x, 0)),df.streetname_2)
    # df['between_cross_street_1'] = df.between_cross_street_1.apply(get_sname)
    # df['and_cross_street_2'] = df.and_cross_street_2.apply(get_sname)

    records = df.to_dict('records')
    
    print('start geocoding ...')
    # Multiprocess
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 10000)
    
    print('geocoding finished, dumping to postgres ...')
    df = pd.DataFrame(it)
    df.to_sql('cbbr_submissions', engine, if_exists='replace', chunksize=10000)