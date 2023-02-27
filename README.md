# Community Board Budget Requests Database (CBBR)

The Community Board Budget Requests Database, a data product produced by the New York City Department of City Planning (DCP), is based on requests for future capital or expense projects submitted by each of NYC's 59 Community Boards to DCP.  DCP then disseminates this information to the Office of Management and Budget and each of NYC's agencies.  DCP adds value to the submitted budget requests by creating geometries where possible for requested projects, in the effort to map as many budget requests as possible.

The Community Board Budget Requests Database is a way to quickly and easily explore and learn about projects requested by NYC's 59 Community Boards.  It’s main purpose is to be a starting point for exploring potential projects and to better understand communities' perceived needs across NYC.  The spatial data provides an integrated view enabling a broad understanding of where communities have requested investments, and reveals opportunities for strategic neighborhood planning.

## Output files (FY2024)

- [cbbr_submissions.csv](https://raw.githubusercontent.com/NYCPlanning/db-cbbr/master/cbbr_build/output/FY2024/cbbr_submissions.csv)
- [cbbr_submissions_needgeoms.csv](https://raw.githubusercontent.com/NYCPlanning/db-cbbr/master/cbbr_build/output/FY2024/cbbr_submissions_needgeoms.csv)
- [cbbr_submissions_poly.csv](https://raw.githubusercontent.com/NYCPlanning/db-cbbr/master/cbbr_build/output/FY2024/cbbr_submissions_poly.csv)
- [cbbr_submissions_pts.csv](https://raw.githubusercontent.com/NYCPlanning/db-cbbr/master/cbbr_build/output/FY2024/cbbr_submissions_pts.csv)
- [cbbr_submissions_poly_shapefile.zip](https://raw.githubusercontent.com/NYCPlanning/db-cbbr/master/cbbr_build/output/FY2024/cbbr_submissions_poly_shapefile.zip)
- [cbbr_submissions_pts_shapefile.zip](https://raw.githubusercontent.com/NYCPlanning/db-cbbr/master/cbbr_build/output/FY2024/cbbr_submissions_pts_shapefile.zip)

### Limitations

The spatial data are not 100% reliable, accurate, or exhaustive

CBBR is primarily built for planning coordination and information purposes only

## Building Preparation

1. `cd cbbr_build` to navigate to the build directory
2. Create `cbbr_build/.env` and set environment variables `RECIPE_ENGINE`, `BUILD_ENGINE`, and `EDM_DATA`
3. In `cbbr_build/.version.env` set input dataset versions
4. Start a postgis docker container to create a local database:

    ```bash
    docker run --name <custom_container_name> -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgis/postgis
    ```

5. (Optional) Create and/or activate a python virtual environment
6. (Optional) `./dev_python_packages.sh` to install python packages

## Building Instructions

1. `./01_dataloading.sh` to load all source data into the postgresDB container
2. `./02_cbbr.sh` to normalize the agency and community district fields
3. `./03_spatial.sh` to geocode the dataset
4. `./04_export.sh` to export the dataset as csv
5. `./05_archive.sh` to archive the cbbr to EDM postgresDB