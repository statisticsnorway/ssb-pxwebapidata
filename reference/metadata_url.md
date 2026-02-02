# Convert between data and metadata URLs

Converts a PxWebApi v2 data URL to a metadata URL, or vice versa.

## Usage

``` r
metadata_url(url, data_url = FALSE)
```

## Arguments

- url:

  A PxWebApi URL to data or metadata.

- data_url:

  Logical. When TRUE, return a data URL. When FALSE (default), return a
  metadata URL.

## Value

A character string (URL).

## Examples

``` r
metadata_url(make_url(4861))
#> [1] "https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=no"
metadata_url(make_url(4861, "ssb_en"), data_url = TRUE)
#> [1] "https://data.ssb.no/api/pxwebapi/v2/tables/04861/data?lang=en"
```
