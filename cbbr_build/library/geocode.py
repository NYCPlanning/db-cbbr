import os
from sqlalchemy import create_engine, text
import pandas as pd
import numpy as np
import copy
from multiprocessing import Pool, cpu_count
from geosupport import Geosupport, GeosupportError
from library.helper.geocode_utils import (
    GEOCODE_COLUMNS,
    parse_location,
    get_hnum,
    get_sname,
    geo_parser,
)

geo_client = Geosupport()


def geosupport_1B_address(input_record: dict) -> dict:
    """1B function - geocode based on the address number and street name"""
    borough = input_record.get("borough_code", "")
    house_number = input_record.get("addressnum", "")
    street_name = input_record.get("street_name", "")

    # use geosupport function
    geo_function_result = geo_client["1B"](
        borough=borough,
        street_name=street_name,
        house_number=house_number,
    )

    return geo_function_result


def geosupport_1B_place(input_record: dict) -> dict:
    """1B function - geocode based on the place name"""
    # TODO raise better errors, e.g. no place name currently yields "STREET NAME IS MISSING"
    borough = input_record.get("borough_code", "")
    street_name = input_record.get("facility_or_park_name", "")

    # use geosupport function
    geo_function_result = geo_client["1A"](
        borough=borough,
        street_name=street_name,
        house_number="",
    )

    return geo_function_result


def geosupport_1A_address(input_record: dict) -> dict:
    borough = input_record.get("borough_code", "")
    house_number = input_record.get("addressnum", "")
    street_name = input_record.get("street_name", "")

    # use geosupport function
    geo_function_result = geo_client["1A"](
        borough=borough,
        street_name=street_name,
        house_number=house_number,
    )

    return geo_function_result


GEOSUPPORT_FUNCTION_HIERARCHY = [
    geosupport_1B_address,
    geosupport_1B_place,
    # geosupport_1A_address,
    # geosupport_2,
]


def geocode_record(inputs: dict) -> dict:
    geo_error = None
    outputs = copy.deepcopy(inputs)

    input_location = inputs.get("location")
    if not input_location:
        outputs.update(dict(geo_function="NO LOCATION DATA"))
        return outputs

    if "district wide" in input_location.lower():
        outputs.update(dict(geo_function="LOCATION IS DISTRICT WIDE"))
        return outputs

    for geo_function in GEOSUPPORT_FUNCTION_HIERARCHY:
        last_attempted_geo_function = geo_function.__name__
        try:
            geo_result = geo_function(input_record=inputs)
            geo_result = geo_parser(geo_result)
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


def geocode_records(cbbr_data: pd.DataFrame) -> pd.DataFrame:
    cbbr_data[GEOCODE_COLUMNS] = None
    cbbr_data["addressnum"] = cbbr_data["address"].apply(get_hnum)
    cbbr_data["street_name"] = cbbr_data["address"].apply(get_sname)

    # cbbr_data["geo_from_x_coord"] = None
    # cbbr_data["geo_from_y_coord"] = None
    # cbbr_data["geo_to_x_coord"] = None
    # cbbr_data["geo_to_y_coord"] = None

    data_records = cbbr_data.to_dict("records")
    # Multiprocess
    with Pool(processes=cpu_count()) as pool:
        geocoded_records = pool.map(geocode_record, data_records, 10000)

    return pd.DataFrame(geocoded_records)


if __name__ == "__main__":
    print("start selecting data from DB ...")
    # connect to postgres db
    engine = create_engine(os.environ["BUILD_ENGINE"])
    select_query = text("SELECT * FROM _cbbr_submissions")
    with engine.begin() as conn:
        cbbr_data = pd.read_sql(select_query, conn)

    print("parsing location data for geocoding ...")
    cbbr_data = parse_location(cbbr_data)

    print("start geocoding ...")
    geocoded_cbbr_data = geocode_records(cbbr_data)
    print("start exporting to DB ...")
    # TODO formally move this to test files
    # geocoded_cbbr_data.to_csv("geocoded_cbbr_data.csv")
    geocoded_cbbr_data.to_sql(
        "_cbbr_submissions", engine, if_exists="replace", chunksize=500, index=False
    )
    print("done geocoding")
