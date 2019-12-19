# db-cbbr - Community Board Budget Requests Database

The Community Board Budget Requests Database, a data product produced by the New York City Department of City Planning (DCP), is based on requests for future capital or expense projects submitted by each of NYC's 59 Community Boards to DCP.  DCP then disseminates this information to the Office of Management and Budget and each of NYC's agencies.  DCP adds value to the submitted budget requests by creating geometries where possible for requested projects, in the effort to map as many budget requests as possible.

The Community Board Budget Requests Database is a way to quickly and easily explore and learn about projects requested by NYC's 59 Community Boards.  It’s main purpose is to be a starting point for exploring potential projects and to better understand communities' perceived needs across NYC.  The spatial data provides an integrated view enabling a broad understanding of where communities have requested investments, and reveals opportunities for strategic neighborhood planning.

#### Limitations
The spatial data are not 100% reliable, accurate, or exhaustive

CBBR is primarly built for planning coordination and information purposes only

## Building Preparation:
1. `cd cbbr_build` navigate to the building directory
2. set CONTAINER_PORT in `config.sh` to a port number is not used
3. Set RECIPE_ENGINE, BUILD_ENGINE and EDM_DATA in `.env`

## Building Instructions:
1. `./01_dataloading.sh` to load all source data into the postgresDB container
5. `./05_archive.sh` to archive the cbbr to EDM postgresDB
6. `./06_cleanup.sh` note: the clean up step will remove postgresDB container
