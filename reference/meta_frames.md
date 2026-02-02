# Structured PxWebApi v2 metadata

Structures selected parts of table metadata into data frames.

## Usage

``` r
meta_frames(url_or_tableid, url_type = "ssb")
```

## Arguments

- url_or_tableid:

  A table id, a PxWebApi v2 URL to data or metadata, or previously
  retrieved metadata.

- url_type:

  Currently two possibilities: "ssb" (Norwegian) or "ssb_en" (English).

## Value

A named list of data frames. Additional metadata is stored as attributes
on the data frames. The data URL is stored in the comment attribute of
the returned object.

## Details

Metadata related to the categories of dimensional variables are returned
as data frames, with additional information stored as attributes.

## Examples

``` r
metaframes <- meta_frames(7459, url_type = "ssb_en")

names(metaframes)
#> [1] "Region"       "Kjonn"        "Alder"        "ContentsCode" "Tid"         

metaframes[["ContentsCode"]]
#>        code index   label unit.base unit.decimals
#> 1 Personer1     0 Persons    number             0
metaframes[["Kjonn"]]
#>   code index   label
#> 1    2     0 Females
#> 2    1     1   Males

# Extra information stored as an attribute on a data frame
attr(metaframes[["Region"]], "extra")[[1]][[1]]
#> [[1]]
#> [1] "1 January 2019, the municipality 1567 Rindal was moved from Møre og Romsdal to Trøndelag. 1 January 2020, the municipality 1571 Halsa was moved from Møre og Romsdal to Trøndelag. 1 January 2020, the municipality 1444 Hornindal was moved from Sogn og Fjordane to Møre og Romsdal."
#> 

# Code list information as a data frame stored as another attribute
attr(metaframes[["Region"]], "code_lists")
#>                      id                                          label
#> 1        agg_KommFylker          Counties 2024, aggregated time series
#> 2        agg_Fylker2024                                 Counties 2024-
#> 3        agg_Fylker2020                             Counties 2020-2023
#> 4       agg_KommForrige                       Municipalities 2020-2023
#> 5        agg_KommSummer    Municipalities 2024, aggregated time series
#> 6    agg_LandsdelKommun                                   Regions 2025
#> 7  agg_Politidistrikt16                           Police district 2016
#> 8       agg_RegionerBVF Regions (Child welfare and family counselling)
#> 9    agg_SentralIndeksA       Centrality (can not be used before 1977)
#> 10 agg_OkonomRegion2020                          Economic regions 2024
#> 11     agg_Valgdistrikt                            Electoral districts
#> 12            vs_Landet                              The whole country
#> 13            vs_Fylker                                   All counties
#> 14            vs_Kommun                             All municipalities
#>           type
#> 1  Aggregation
#> 2  Aggregation
#> 3  Aggregation
#> 4  Aggregation
#> 5  Aggregation
#> 6  Aggregation
#> 7  Aggregation
#> 8  Aggregation
#> 9  Aggregation
#> 10 Aggregation
#> 11 Aggregation
#> 12    Valueset
#> 13    Valueset
#> 14    Valueset
#>                                                                         links
#> 1        https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_KommFylker?lang=en
#> 2        https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_Fylker2024?lang=en
#> 3        https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_Fylker2020?lang=en
#> 4       https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_KommForrige?lang=en
#> 5        https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_KommSummer?lang=en
#> 6    https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_LandsdelKommun?lang=en
#> 7  https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_Politidistrikt16?lang=en
#> 8       https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_RegionerBVF?lang=en
#> 9    https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_SentralIndeksA?lang=en
#> 10 https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_OkonomRegion2020?lang=en
#> 11     https://data.ssb.no/api/pxwebapi/v2/codeLists/agg_Valgdistrikt?lang=en
#> 12            https://data.ssb.no/api/pxwebapi/v2/codeLists/vs_Landet?lang=en
#> 13            https://data.ssb.no/api/pxwebapi/v2/codeLists/vs_Fylker?lang=en
#> 14            https://data.ssb.no/api/pxwebapi/v2/codeLists/vs_Kommun?lang=en

# Information about elimination possibilities
attr(metaframes[["Region"]], "elimination")
#> [1] TRUE
attr(metaframes[["ContentsCode"]], "elimination")
#> [1] FALSE
sapply(metaframes, attr, "elimination") # elimination info for all variables
#>       Region        Kjonn        Alder ContentsCode          Tid 
#>         TRUE         TRUE         TRUE        FALSE        FALSE 
```
