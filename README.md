
<!-- README.md is generated from README.Rmd. Please edit that file -->

# epts

<!-- badges: start -->

[![R-CMD-check](https://github.com/george-wood/epts/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/george-wood/epts/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

epts is a package for reading data that follows the [Electronic
Performance and Tracking Systems (EPTS) standard data
format](https://www.fifa.com/technical/football-technology/standards/epts/research-development-epts-standard-data-format)
into R. It provides functions to parse metadata and data format
specifications, as provided in an `.xml` file. It uses these
specifications to imports the raw data `.txt` file and return a data
frame.

The package makes it easy to import any EPTS data that follows the
standard format into R.

## Installation

You can install the development version of epts from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("george-wood/epts")
```

## Usage

This example imports the [example data provided by
FIFA](https://www.fifa.com/technical/football-technology/standards/epts/research-development-epts-standard-data-format):

``` r
library(epts)

# player and ball tracking data
raw_data <- epts_example("fifa_example.txt")

# metadata and data format specification file
metadata <- epts_example("fifa_example.xml")

# import the example data
read_epts(raw_data, metadata)
#> Warning in readLines(data): incomplete final line found on
#> '/private/var/folders/qw/kjq09mn10l5cmw355f10qr2h0000gn/T/Rtmp7mL1rH/temp_libpath223d1ac4453/epts/extdata/fifa_example.txt'
#> Warning in read_xml.character(x = metadata): Unsupported version '1.1' [97]
#> Warning in read_xml.character(metadata): Unsupported version '1.1' [97]

#> Warning in read_xml.character(metadata): Unsupported version '1.1' [97]
#> Warning in split.default(x = seq_len(nrow(x)), f = f, drop = drop, ...): data
#> length is not a multiple of split variable
#> Warning in read_xml.character(metadata): Unsupported version '1.1' [97]
#> $`0`
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
