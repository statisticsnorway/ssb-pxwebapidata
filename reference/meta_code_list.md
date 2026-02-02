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

print(df)
#>    code                                              label valueMap
#> 1    30                                  Viken (2020-2023)       30
#> 2    03                                      Oslo - Oslove       03
#> 3    34                                          Innlandet       34
#> 4    38                   Vestfold og Telemark (2020-2023)       38
#> 5    42                                              Agder       42
#> 6    11                                           Rogaland       11
#> 7    46                                           Vestland       46
#> 8    15                                    Møre og Romsdal       15
#> 9    50                            Trøndelag - Trööndelage       50
#> 10   18                              Nordland - Nordlánnda       18
#> 11   54 Troms og Finnmark - Romsa ja Finnmárku (2020-2023)       54
#> 12   21                                           Svalbard       21
print(attr(df, "extra")[1:3])
#> $id
#> [1] "agg_Fylker2020"
#> 
#> $label
#> [1] "Counties 2020-2023"
#> 
#> $language
#> [1] "en"
#> 
```
