# Make data url from table id

Make data url from table id

## Usage

``` r
make_url(id, url_type = "ssb")
```

## Arguments

- id:

  Table id (integer).

- url_type:

  Currently two possibilities: "ssb" (Norwegian) or "ssb_en" (English).

## Value

A character string (URL).

## Examples

``` r
make_url(4861)
#> [1] "https://data.ssb.no/api/pxwebapi/v2/tables/04861/data?lang=no"
make_url(4861, "ssb_en")
#> [1] "https://data.ssb.no/api/pxwebapi/v2/tables/04861/data?lang=en"
```
