# PX-Web API query URL

PX-Web API query URL

## Usage

``` r
query_url(
  url_or_tableid,
  ...,
  url_type = "ssb",
  use_index = FALSE,
  default_query = c(1, -2, -1)
)
```

## Arguments

- url_or_tableid:

  A table id, a PxWebApi v2 URL to data or metadata, or metadata
  returned by [`meta_data()`](meta_data.md) or
  [`meta_frames()`](meta_frames.md).

- ...:

  Specification of query for each variable. See ‘Details’ in
  [`api_data()`](api_data.md).

- url_type:

  Currently two possibilities: "ssb" (Norwegian) or "ssb_en" (English).

- use_index:

  Logical. If TRUE, numeric values are matched against the `index`
  variable in the metadata, which usually starts at 0. If FALSE
  (default), numeric values are interpreted as row numbers in the
  metadata, using standard R indexing. Negative values can be used to
  specify reversed row numbers.

- default_query:

  Specification for variables not included in `...`. The default is
  `default_query = c(1, -2, -1)`, which selects the first and the two
  last codes listed in the metadata. Use `default_query = TRUE` and omit
  specifying individual variables to retrieve entire tables.

## Value

A PxWeb API URL to data, with query parameters added according to the
input.

## Examples

``` r
query_url(4861, 
          Region = FALSE, 
          ContentsCode = "Bosatte", 
          Tid = c(1, 5, -1), 
          url_type = "ssb_en")
#> Warning converted to message: cannot open URL 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2': HTTP status was '429 Unknown Error'
#> No internet connection or resource not available: Error in open.connection(con, "rb") : 
#>   cannot open the connection to 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2'
#> NULL
          
          
query_url("https://data.ssb.no/api/pxwebapi/v2/tables/08991/data?lang=en",
          Fangst2 = FALSE,
          Elver = FALSE,
          ContentsCode = TRUE,  # same as "*"   
          Tid = "top(5)")       # same as 5i
#> Warning converted to message: cannot open URL 'https://data.ssb.no/api/pxwebapi/v2/tables/08991/metadata?lang=en&outputFormat=json-stat2': HTTP status was '429 Unknown Error'
#> No internet connection or resource not available: Error in open.connection(con, "rb") : 
#>   cannot open the connection to 'https://data.ssb.no/api/pxwebapi/v2/tables/08991/metadata?lang=en&outputFormat=json-stat2'
#> NULL
          
          
          
query_url("https://data.ssb.no/api/pxwebapi/v2/tables/07459/data?lang=en",
          Region = FALSE,
          Kjonn = TRUE,
          Alder = list(codelist = "agg_TodeltGrupperingB", 
                       valueCodes = c("H17", "H18"),
                       outputValues = "aggregated"),
         ContentsCode = 1,
         Tid = 4i)
#> Warning converted to message: cannot open URL 'https://data.ssb.no/api/pxwebapi/v2/tables/07459/metadata?lang=en&outputFormat=json-stat2': HTTP status was '429 Unknown Error'
#> No internet connection or resource not available: Error in open.connection(con, "rb") : 
#>   cannot open the connection to 'https://data.ssb.no/api/pxwebapi/v2/tables/07459/metadata?lang=en&outputFormat=json-stat2'
#> NULL
```
