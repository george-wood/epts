
<!-- README.md is generated from README.Rmd. Please edit that file -->

# epts

<!-- badges: start -->

[![R-CMD-check](https://github.com/george-wood/epts/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/george-wood/epts/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/george-wood/epts/branch/master/graph/badge.svg?token=ZM8CUR8P13)](https://codecov.io/gh/george-wood/epts)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

epts is a package for reading [Electronic Performance and Tracking
Systems](https://www.fifa.com/technical/football-technology/standards/epts)
(EPTS) data.

## Overview

EPTS is a broad term for camera-based and wearable technologies that
measure and track players and the ball in football (soccer). This
includes positioning systems that track player and ball positions,
accelerometers, gyroscopes, and other technologies. The data produced by
EPTS is widely used for analytics. However, as the number of vendors
providing EPTS data has increased, so has the complexity of integrating
this data into analytical pipelines, as noted by FIFA[^1]:

> Alongside the increasing adoption of these devices, the variety of
> brands and vendors have also increased up to tens of providers in this
> timeframe. While more data is being generated, the operational
> maintenance and integration of this information becomes everyday more
> complex. A central issue is that each different vendor defines its own
> format and specification for the data that is being provided. While is
> typical to also provide software to interpret this data, the
> increasing availability of sources of information and the need of data
> centralization makes very difficult for clubs to keep the growing pace
> of this industry, regarding the needs for continuous integration and
> maintainability of data. Also, the ad-hoc nature of provided formats
> makes harder to integrate information from different sources, making
> progress in this area slower.

In response to this problem, FIFA and FC Barcelona have developed a
standard format for exchanging EPTS data. The standard format requires
that vendors produce two files when exchanging data:

- A raw data file, which contains the actual data in a format that can
  be parsed line by line
- An xml file, which contains a data format specification that defines
  the format of the raw data file alongside other metadata

The epts package makes it easy to read the raw data file according to
the data format specification.

## Features

With epts, you can:

- Import the raw data file according to the data format specification
- Extract metadata, including specific fields such as the frame rate or
  team name

When importing raw data, epts always returns a `data.frame` with column
names as defined in the data format specification. For flexibility, the
metadata is extracted as a `list`.

## Installation

You can install the development version of epts from
[GitHub](https://github.com/) using:

``` r
# install.packages("devtools")
devtools::install_github("george-wood/epts")
```

## Usage

``` r
library(epts)
```

The package includes [example
data](https://www.fifa.com/technical/football-technology/standards/epts/research-development-epts-standard-data-format)
provided by FIFA:

``` r
# txt file including player and ball tracking data
raw_data <- epts_example("fifa_example.txt")
readLines(raw_data, warn = FALSE)
#> [1] "1779143:-769,-2013,-500,100,9.63,9.80,4,5,177,182;-461,-615,-120,99,900,9.10,4,5,170,179;-2638,3478,120,110,1.15,5.20,3,4,170,175;:-2656,367,100:"
#> [2] "1779144:-218,1193,2000,100,1.23,3.10,3,3,170,170;1188,1930,1000,100,3.25,3.70,3,3,177,179;-235,-1522,-100,100,2.72,3.20,3,3,180,182;:-521,816,11:"

# xml file including metadata and format specification
metadata <- epts_example("fifa_example.xml")
```

Import the raw data according to the format specification:

``` r
read_epts(raw_data, metadata)
#>   frameCount player1_x player1_y player1_z player1_distance player1_avg_speed
#> 1    1779143      -769     -2013      -500              100              9.63
#> 2    1779144      -218      1193      2000              100              1.23
#>   player1_max_speed player1_acceleration player1_max_acceleration
#> 1               9.8                    4                        5
#> 2               3.1                    3                        3
#>   player1_heartbeat player1_max_heartbeat player2_x player2_y player2_z
#> 1               177                   182      -461      -615      -120
#> 2               170                   170      1188      1930      1000
#>   player2_distance player2_avg_speed player2_max_speed player2_acceleration
#> 1               99            900.00               9.1                    4
#> 2              100              3.25               3.7                    3
#>   player2_max_acceleration player2_heartbeat player2_max_heartbeat player3_x
#> 1                        5               170                   179     -2638
#> 2                        3               177                   179      -235
#>   player3_y player3_z player3_distance player3_avg_speed player3_max_speed
#> 1      3478       120              110              1.15               5.2
#> 2     -1522      -100              100              2.72               3.2
#>   player3_acceleration player3_max_acceleration player3_heartbeat
#> 1                    3                        4               170
#> 2                    3                        3               180
#>   player3_max_heartbeat     x   y   z
#> 1                   175 -2656 367 100
#> 2                   182  -521 816  11
```

The example data provided by FIFA is misspecified: the raw data includes
frames that are not defined in the data format specification. The user
is warned about this.

[^1]: [FIFA Standard Data Transfer
    Format](https://digitalhub.fifa.com/m/477d8daa7f0ac4c9/original/standard-transfer-format-documentation.pdf)
