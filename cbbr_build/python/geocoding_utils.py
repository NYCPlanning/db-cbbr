import pandas as pd
import numpy as np
from typing import Union

# location components ordered by the observed pattern in data from right to left
# each component is paired with the column to store its value in for geocoding
# Site Name: xxx Street Name: xxx Cross Street 1 xxx Cross Street 2
LOCATION_PREFIX_TO_COLUMN = [
    ("Cross Street 2:", "and_cross_street_2"),
    ("Cross Street 1:", "between_cross_street_1"),
    ("Street Name:", "address"),
    ("Site Name:", "facility_or_park_name"),
]


def get_location_value_from_end(
    full_location_value: str, location_value_prefix: str
) -> Union[str, float]:
    """Extract a prefixed location value from the end of a location string.
    Will return all text to the right of the prefix.

    Examples
        'Site Name: A', 'Site Name:' -> 'A'
        'Site Name: A Cross Street: B', 'Cross Street:' -> 'B'
        'Site Name: A Cross Street: B', 'Site Name:' -> 'A Cross Street: B'
    """
    if pd.isna(full_location_value):
        return np.nan
    if location_value_prefix not in full_location_value:
        return np.nan

    all_substrings = full_location_value.split(location_value_prefix)

    invalid_substrings = ["", " "]
    valid_substrings = [
        substring.strip()
        for substring in all_substrings
        if substring not in invalid_substrings
    ]
    location_value = valid_substrings[-1]

    return location_value


def remove_location_value_from_end(
    full_location_value: str, location_value_prefix: str
) -> Union[str, float]:
    """Remove a prefixed location value from the end of a location string.
    Will return all text to the right of the prefix.

    Examples
        'Site Name: A', 'Site Name:' -> np.nan
        'Site Name: A Cross Street: B', 'Cross Street:' -> 'Site Name: A'
        'Site Name: A Cross Street: B', 'Site Name:' -> np.nan
    """
    if pd.isna(full_location_value):
        return np.nan
    if location_value_prefix not in full_location_value:
        return full_location_value.strip()

    return full_location_value.split(location_value_prefix)[0].strip()


def parse_location(data: pd.DataFrame) -> pd.DataFrame:
    """Parses address data in a location column.

    Splits substrings from the location column into separate columns for geocoding
    via Geosupport.

    Args:
        data:
            A dataframe with a location column

    Returns:
        A dataframe with additional columns for each component
    """
    temp_location_column = "location_parsing"
    data[temp_location_column] = data["location"]
    for location_prefix_column_pair in LOCATION_PREFIX_TO_COLUMN:
        # get prefix and column name for this pair
        location_component_prefix = location_prefix_column_pair[0]
        new_column = location_prefix_column_pair[1]
        # get the location component
        data[new_column] = data[temp_location_column].apply(
            lambda x: get_location_value_from_end(x, location_component_prefix)
        )
        # remove the location prefix and component
        data[temp_location_column] = data[temp_location_column].apply(
            lambda x: remove_location_value_from_end(x, location_component_prefix)
        )

    data = data.drop([temp_location_column], axis=1)
    data = data.where(pd.notnull(data), None)

    return data
