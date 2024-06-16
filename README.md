
<!-- README.md is generated from README.Rmd. Please edit that file -->

# OvertureMaps R Package

This package provides functions to interact with OvertureMaps datasets.
It includes utilities for fetching data from S3 and converting it to sf
objects for spatial analysis.

<!-- badges: start -->

[![R-CMD-check](https://github.com/denironyx/overturemapsr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/denironyx/overturemapsr/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

Overture Maps provides free and open geospatial map data, from many
different sources and normalized to a common schema. This tool helps to
download Overture data within a region of interest and converts it to a
few different file formats.

## Installation

To install this package, you need to have the necessary dependencies
installed. You can install the package using the following commands:

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

## Functions

- `get_all_overture_types`: This function returns all available
  OvertureMaps theme types.
- `dataset_path`: This function returns the S3 path for the specified
  Overture dataset type.
- `record_batch_reader`: This function retrieves a filtered dataset from
  the specified Overture dataset type, optionally within a bounding box,
  and converts it to an sf object.

#### Parameters

- overture_type: Character. Required. The type of feature to select.
  Examples include ‘building’, ‘place’, etc. To learn more, run
  get_all_overture_types().
- bbox: Numeric vector. Optional. A bounding box specified as c(xmin,
  ymin, xmax, ymax). It is recommended to use a bounding box to limit
  the dataset size and processing time. Without a bounding box,
  processing the entire dataset (e.g., buildings over 2 billion) can be
  time-consuming.

[Bounding Box Tool from
Klokantech](https://boundingbox.klokantech.com/): Use this tool to find
and specify bounding boxes of interest for your data queries.

### Notes

This repository and project are based on [OvertureMaps Python
Repository](https://github.com/OvertureMaps/overturemaps-py/tree/main).
The functionality are similar and things are likely to change, including
the user interface, until a stable release. We will keep the
documentation here up-to-date.

##### License

This package is licensed under the MIT License.
