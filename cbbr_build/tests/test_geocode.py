import pytest
import pandas as pd
import numpy as np
import copy

from library.helper.geocode_utils import GEOCODE_COLUMNS
from library.geocode import geocode_records


@pytest.fixture
def example_cbbr_data_geocoded() -> pd.DataFrame:
    return pd.read_csv(
        "tests/test_data/geocoded_cbbr_data.csv",
        dtype=str,
    ).replace(np.nan, None)


@pytest.fixture
def example_cbbr_data() -> pd.DataFrame:
    geocoded = pd.read_csv(
        "tests/test_data/geocoded_cbbr_data.csv",
        dtype=str,
    ).replace(np.nan, None)
    return geocoded.drop(GEOCODE_COLUMNS, axis=1)


def test_validate_example_data(example_cbbr_data, example_cbbr_data_geocoded):
    assert isinstance(example_cbbr_data_geocoded, pd.DataFrame)
    assert (
        example_cbbr_data_geocoded["test_id"]
        .drop_duplicates()
        .equals(example_cbbr_data_geocoded["test_id"])
    )
    assert len(example_cbbr_data_geocoded.columns) - len(
        example_cbbr_data.columns
    ) == len(GEOCODE_COLUMNS)


def test_geocode(example_cbbr_data, example_cbbr_data_geocoded):
    geocoded_data = geocode_records(example_cbbr_data)
    pd.testing.assert_frame_equal(geocoded_data, example_cbbr_data_geocoded)
