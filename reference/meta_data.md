# PxWebApi v2 metadata for a table

Retrieves metadata for a table using the PxWebApi v2 endpoint and
returns it as an R object via
[`jsonlite::read_json()`](https://jeroen.r-universe.dev/jsonlite/reference/read_json.html).

## Usage

``` r
meta_data(url_or_tableid, url_type = "ssb")
```

## Arguments

- url_or_tableid:

  Either a numeric table id or a PxWebApi v2 URL to data. When a data
  URL is supplied, it is internally converted to a metadata URL.

- url_type:

  Currently two possibilities: "ssb" (Norwegian) or "ssb_en" (English).

## Value

A list containing table metadata read by
[`jsonlite::read_json()`](https://jeroen.r-universe.dev/jsonlite/reference/read_json.html)
after internal URL adjustments via
[`ensure_json_stat2()`](ensure_json_stat2.md). The data URL is stored in
the comment attribute of the returned object.

## Examples

``` r
metadata1 <- meta_data(8991, url_type = "ssb_en")
metadata2 <- meta_data(
  "https://statistikdatabasen.scb.se/api/v2/tables/TAB1525/data?lang=en"
)

print(metadata1[1:4])
#> $version
#> [1] "2.0"
#> 
#> $class
#> [1] "dataset"
#> 
#> $label
#> [1] "08991: River fishing. Catch, by river/watercourse, fish species and disposition of catch 1993-2024"
#> 
#> $source
#> [1] "Statistics Norway"
#> 
print(metadata2[1:4])
#> $version
#> [1] "2.0"
#> 
#> $class
#> [1] "dataset"
#> 
#> $label
#> [1] "Livestock by county/country and type of animal. Year 1981-2007"
#> 
#> $source
#> [1] "Swedish Board of Agriculture"
#> 
```
