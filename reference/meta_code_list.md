# PxWebApi v2 metadata for a code list

Retrieves metadata for a code list and returns it as an R object.

## Usage

``` r
meta_code_list(url, as_frame = TRUE)
```

## Arguments

- url:

  A PxWebApi v2 URL to metadata for a code list.

- as_frame:

  Logical. When TRUE, the metadata is structured as a data frame, with
  additional information stored in an attribute named `"extra"`.

## Value

An R object containing metadata for the code list. When
`as_frame = TRUE`, the result is a data frame.

## Examples

``` r
metaframes <- meta_frames(7459, url_type = "ssb_en")
url <- attr(metaframes[["Region"]], "code_lists")[["links"]][3]
print(url)
#> [1] "https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_Fylker2020?lang=en"

df <- meta_code_list(url)
#> Warning converted to message: cannot open URL 'https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_Fylker2020?lang=en&outputFormat=json-stat2': HTTP status was '429 Unknown Error'
#> No internet connection or resource not available: Error in open.connection(con, "rb") : 
#>   cannot open the connection to 'https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_Fylker2020?lang=en&outputFormat=json-stat2'

print(df)
#> NULL
print(attr(df, "extra")[1:3])
#> NULL
```
