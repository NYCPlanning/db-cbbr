# test boilerplate approaches used in other test files
import pytest
import pandas as pd
import numpy as np

from ..python.geocode_utils import parse_location

# from ..python.geocode import geosupport_1B_address


def test_always_passes():
    assert True


@pytest.mark.xfail(reason="expected to always fail")
def test_expect_always_fails():
    assert False


@pytest.mark.skip(reason="skipping always fails")
def test_skip_always_fails():
    assert False
