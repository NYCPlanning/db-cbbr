# test geocoding logic
import pytest
import pandas as pd
import numpy as np

from ..python.geocode_utils import (
    get_location_value_from_end,
    remove_location_value_from_end,
    parse_location,
)


def assert_string_or_nan_equality(actual_value, expected_value):
    if isinstance(expected_value, float):  # testing np.nan equality
        assert actual_value is expected_value
    else:
        assert actual_value == expected_value


@pytest.fixture
def example_cbbr_data():
    return pd.DataFrame.from_dict(
        {
            "test_id": [
                "null_values",
                "site_name_only",
                "no_site_name",
            ],
            "boro_name": [
                np.nan,
                "Brooklyn",
                "Brooklyn",
            ],
            "location": [
                np.nan,
                "Site Name: Linden Park Comfort Station",
                "Street Name: Atlantic Avenue;    Cross Street 1: Crescent Street;",
            ],
        }
    )


@pytest.fixture
def example_cbbr_data_parsed():
    return pd.DataFrame.from_dict(
        {
            "test_id": [
                "null_values",
                "site_name_only",
                "no_site_name",
            ],
            "boro_name": [
                np.nan,
                "Brooklyn",
                "Brooklyn",
            ],
            "location": [
                np.nan,
                "Site Name: Linden Park Comfort Station",
                "Street Name: Atlantic Avenue;    Cross Street 1: Crescent Street;",
            ],
            "and_cross_street_2": [
                np.nan,
                np.nan,
                np.nan,
            ],
            "between_cross_street_1": [
                np.nan,
                np.nan,
                "Crescent Street",
            ],
            "address": [
                np.nan,
                np.nan,
                "Atlantic Avenue",
            ],
            "facility_or_park_name": [
                np.nan,
                "Linden Park Comfort Station",
                np.nan,
            ],
        }
    )


def test_validate_example_data(example_cbbr_data, example_cbbr_data_parsed):
    assert isinstance(example_cbbr_data, pd.DataFrame)
    assert (
        example_cbbr_data["test_id"]
        .drop_duplicates()
        .equals(example_cbbr_data["test_id"])
    )
    assert isinstance(example_cbbr_data_parsed, pd.DataFrame)
    assert (
        example_cbbr_data_parsed["test_id"]
        .drop_duplicates()
        .equals(example_cbbr_data_parsed["test_id"])
    )


@pytest.mark.parametrize(
    "location_value, expected_value",
    [
        (np.nan, np.nan),
        (None, np.nan),
        ("", np.nan),
        ("a", np.nan),
        ("Site Name: A", "A"),
        ("Site Name: Park A ", "Park A"),
        ("Site Name: Park A;", "Park A"),
        ("Site Name: Park A Cross Street 1: B Drive", "Park A Cross Street 1: B Drive"),
        ("Cross Street 1: B Drive", np.nan),
    ],
)
def test_get_site_name(location_value, expected_value):
    location_value_prefix = "Site Name:"
    assert_string_or_nan_equality(
        get_location_value_from_end(location_value, location_value_prefix),
        expected_value,
    )


@pytest.mark.parametrize(
    "location_value, expected_value",
    [
        (np.nan, np.nan),
        (None, np.nan),
        ("", np.nan),
        ("a", np.nan),
        ("Site Name: Park A ", np.nan),
        ("Cross Street 1: B Drive", "B Drive"),
        (
            "Cross Street 1: B Drive Cross Street 2: C Drive",
            "B Drive Cross Street 2: C Drive",
        ),
        ("Site Name: Park A Cross Street 1: B Drive", "B Drive"),
    ],
)
def test_get_cross_street_1(location_value, expected_value):
    location_value_prefix = "Cross Street 1:"
    assert_string_or_nan_equality(
        get_location_value_from_end(location_value, location_value_prefix),
        expected_value,
    )


@pytest.mark.parametrize(
    "location_value, expected_value",
    [
        (np.nan, np.nan),
        (None, np.nan),
        ("", ""),
        ("a", "a"),
        ("Site Name: Park A ", "Site Name: Park A"),
        ("Site Name: Park A Cross Street 1: B Drive", "Site Name: Park A"),
        (" Cross Street 1: B Drive", ""),
    ],
)
def test_remove_cross_street_1_name(location_value, expected_value):
    location_value_prefix = "Cross Street 1:"
    assert_string_or_nan_equality(
        remove_location_value_from_end(location_value, location_value_prefix),
        expected_value,
    )


# @pytest.mark.skip(reason="dev in progress")
def test_parse_location_site(example_cbbr_data, example_cbbr_data_parsed):
    parsed_data = parse_location(example_cbbr_data)

    pd.testing.assert_frame_equal(parsed_data, example_cbbr_data_parsed)
