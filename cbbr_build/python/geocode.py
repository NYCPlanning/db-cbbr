import os
from multiprocessing import Pool, cpu_count
from sqlalchemy import create_engine, text
from geosupport import Geosupport, GeosupportError
import pandas as pd
import numpy as np
from geocoding_utils import (
    parse_location,
    get_hnum,
    get_sname,
    clean_streetname,
    geo_parser,
)

geo_client = Geosupport()


def geosupport_1B_address(input_record: dict) -> dict:
    """1B function - geocode based on the address number and street name"""
    borough = input_record.get("borough_code", "")
    house_number = input_record.get("addressnum", "")
    street_name = input_record.get("streetname", "")

    # use geosupport function
    geo_function_result = geo_client["1B"](
        borough=borough,
        street_name=street_name,
        house_number=house_number,
    )
    geo_function_result = geo_parser(geo_function_result)
    # geo_result.update(geo_function_result)

    return geo_function_result


def geosupport_1B_place(input_record: dict) -> dict:
    """1B function - geocode based on the place name"""
    borough = input_record.get("borough_code", "")
    street_name = input_record.get("facility_or_park_name", "")

    # use geosupport function
    geo_function_result = geo_client["1A"](
        borough=borough,
        street_name=street_name,
        house_number="",
    )
    geo_function_result = geo_parser(geo_function_result)

    return geo_function_result


def geosupport_1A_address(input_record: dict) -> dict:
    borough = input_record.get("borough_code", "")
    house_number = input_record.get("addressnum", "")
    street_name = input_record.get("streetname", "")

    # use geosupport function
    geo_function_result = geo_client["1A"](
        borough=borough,
        street_name=street_name,
        house_number=house_number,
    )
    geo_function_result = geo_parser(geo_function_result)

    return geo_function_result


GEOSUPPORT_FUNCTION_HIERARCHY = [
    geosupport_1B_address,
    geosupport_1B_place,
    # geosupport_1A_address,
    # geosupport_2,
]


def geocode(inputs: dict):
    geo_error = None
    outputs = inputs

    input_location = inputs.get("location")
    if not input_location:
        outputs.update(dict(geo_function="NO LOCATION DATA"))
        return outputs

    if "district wide" in input_location.lower():
        outputs.update(dict(geo_function="LOCATION IS DISTRICT WIDE"))
        return outputs

    for geo_function in GEOSUPPORT_FUNCTION_HIERARCHY:
        try:
            last_attempted_geo_function = geo_function.__name__
            geo_result = geo_function(inputs)
            outputs.update(dict(geo_function=last_attempted_geo_function))
            outputs.update(geo_result)

            return outputs

        except GeosupportError as e:
            # try the next function but remember this error
            geo_error = e
            continue

    geo_result_error = geo_error.result
    geo_result_error = geo_parser(geo_result_error)
    outputs.update(dict(geo_function=f"{last_attempted_geo_function} FAILED"))
    outputs.update(geo_result_error)

    return outputs


if __name__ == "__main__":
    print("hi I'm geocoding.py main")
    # print("creating fake data ...")
    # cbbr_data = pd.DataFrame.from_dict(
    #     {
    #         "id": [
    #             "fake_park",
    #             "fake_address",
    #             "real_address_works",
    #             "real_address_fails",
    #         ],
    #         "borough_code": [
    #             "3",
    #             "3",
    #             "3",
    #             "3",
    #         ],
    #         "location": [
    #             "Site Name: Little Park",
    #             "Site Name: Home; Street Name: 1991 August Ave",
    #             "Site Name: Pena-Herrera Park;   Street Name: 4601 3 Avenue",
    #             # "Site Name: Kosciuszko Pool;   Street Name: 670 Marcy Avenue, Brooklyn, New York, NY",
    #             "Site Name: Kosciuszko Pool;   Street Name: 658 DEKALB AVENUE, Brooklyn, New York, NY",
    #         ],
    #     }
    # )

    # connect to postgres db
    engine = create_engine(os.environ["BUILD_ENGINE"])
    select_query = text("SELECT * FROM _cbbr_submissions")
    with engine.begin() as conn:
        cbbr_data = pd.read_sql(select_query, conn)

    print("parsing data for geocoding ...")
    # parse components of location column
    cbbr_data = parse_location(cbbr_data)
    cbbr_data["addressnum"] = cbbr_data.address.apply(get_hnum)
    cbbr_data["streetname"] = cbbr_data.address.apply(get_sname)

    cbbr_data["geo_from_x_coord"] = np.nan
    cbbr_data["geo_from_y_coord"] = np.nan
    cbbr_data["geo_to_x_coord"] = np.nan
    cbbr_data["geo_to_y_coord"] = np.nan
    cbbr_data["geo_to_y_coord"] = np.nan
    cbbr_data["geo_to_y_coord"] = np.nan

    print("start geocoding ...")
    cbbr_data_records = cbbr_data.to_dict("records")
    # Multiprocess
    with Pool(processes=cpu_count()) as pool:
        geocoded_records = pool.map(geocode, cbbr_data_records, 10000)

    geocoded_cbbr_data = pd.DataFrame(geocoded_records)
    print("done geocoding")
    # geocoded_cbbr_data.to_csv("geocoded_cbbr_data.csv")
    geocoded_cbbr_data.to_sql(
        "_cbbr_submissions", engine, if_exists="replace", chunksize=500, index=False
    )
