
<!-- README.md is generated from README.Rmd. Please edit that file -->

### ⭐ **Star the Repo**  
If you find this project valuable, **star** ⭐ this repository to support the work and help others discover it!  

---

# OvertureMaps R Package

This package provides functions to interact with OvertureMaps datasets.
It includes utilities for fetching data from S3 and converting it to sf
objects for spatial analysis.

<!-- badges: start -->

[![R-CMD-check](https://github.com/denironyx/overturemapsr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/denironyx/overturemapsr/actions/workflows/R-CMD-check.yaml)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/overturemapsr)](https://CRAN.R-project.org/package=overturemapsr)
[![CRAN_Downloads](https://cranlogs.r-pkg.org/badges/grand-total/overturemapsr)](https://cranlogs.r-pkg.org/badges/overturemapsr)

<!-- badges: end -->

Overture Maps provides free and open geospatial map data, from many
different sources and normalized to a common schema. This tool helps to
download Overture data within a region of interest and converts it to a
few different file formats.

## Installation

To install this package, you need to have the necessary dependencies
installed. You can install the package using the following commands:

#### Prod

``` r
install.packages('overturemapsr')
```

#### Dev

``` r
# install.packages("devtools")
devtools::install_github("denironyx/overturemapsr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(overturemapsr)
## basic example code
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.

## Usage

``` r
library(arrow)
#> 
#> Attaching package: 'arrow'
#> The following object is masked from 'package:utils':
#> 
#>     timestamp
```

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

``` r
library(sf)
#> Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.3.1; sf_use_s2() is TRUE
```

``` r
library(overturemapsr)

# Bounding box of lisbon city
ls_bbox <- c(-9.181056,38.696137,-9.095569,38.750243)

# Fetching overture building data
ls_building <- record_batch_reader('building', bbox = ls_bbox)
```

## Functions

- `get_all_overture_schema_types`: This function returns all available
  OvertureMaps theme types.
- `dataset_path`: This function returns the S3 path for the specified
  Overture dataset type.
- `record_batch_reader`: This function retrieves a filtered dataset from
  the specified Overture dataset type, optionally within a bounding box,
  and converts it to an sf object.

#### Parameters

- schema_type: Character. Required. The type of feature to select.
  Examples include ‘building’, ‘place’, etc. To learn more, run
  get_all_overture_schema_types().
- release_date: Character. Optional. The dataset release date (format:
  ‘YYYY-MM-DD’). Defaults to the latest available release ‘2025-01-22’ -
  <https://docs.overturemaps.org/release/latest/>
- bbox: Numeric vector. Optional. A bounding box specified as c(xmin,
  ymin, xmax, ymax). It is recommended to use a bounding box to limit
  the dataset size and processing time. Without a bounding box,
  processing the entire dataset (e.g., buildings over 2 billion) can be
  time-consuming.

[Bounding Box Tool from
Klokantech](https://boundingbox.klokantech.com/): Use this tool to find
and specify bounding boxes of interest for your data queries.

## Sponsored By

<figure>
<img src="img/unpatterned.png" alt="https://unpatterned.org" />
<figcaption aria-hidden="true"><a href="https://unpatterned.org"
class="uri">https://unpatterned.org</a></figcaption>
</figure>
