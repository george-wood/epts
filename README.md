
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
measure and track football (soccer) players. This includes positioning
systems that track player and ball positions, accelerometers,
gyroscopes, and other technologies. Such data is widely used in sports
analytics.

FIFA and FC Barcelona have developed a standard format for exchanging
EPTS data. The standard format requires data providers to produce two
documents when exchanging data:

- A raw data file, which contains the actual data in a format that can
  be parsed line by line.
- An xml file containing metadata and a data format specification that
  defines the format of the raw data file.

The epts package makes it easy to read the raw data file according to
the data format specification.

## Features

With epts, you can:

- Import the raw data file according to the data format specification.
- Extract metadata, including specific fields such as the frame rate or
  team names.

When importing raw data, epts returns a `data.frame` with column names
as defined in the data format specification. For flexibility, the
metadata is extracted as a `list`.

## Installation

You can install the development version of epts from
[GitHub](https://github.com/) with:

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
# player and ball tracking data
raw_data <- epts_example("fifa_example.txt")
readLines(raw_data, warn = FALSE)
#> [1] "1779143:-769,-2013,-500,100,9.63,9.80,4,5,177,182;-461,-615,-120,99,900,9.10,4,5,170,179;-2638,3478,120,110,1.15,5.20,3,4,170,175;:-2656,367,100:"
#> [2] "1779144:-218,1193,2000,100,1.23,3.10,3,3,170,170;1188,1930,1000,100,3.25,3.70,3,3,177,179;-235,-1522,-100,100,2.72,3.20,3,3,180,182;:-521,816,11:"

# xml file including metadata and format specification
metadata <- epts_example("fifa_example.xml")
```

Import the raw data using the format specification:

``` r
read_epts(raw_data, metadata)
#> Warning in split.default(x = seq_len(nrow(x)), f = f, drop = drop, ...): data
#> length is not a multiple of split variable
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
