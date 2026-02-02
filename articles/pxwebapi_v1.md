# Using PxWebApi v1 with PxWebApiData

### Preface

This vignette describes the functionality in the R package
**PxWebApiData** related to PxWebApi v1.

Most of the content in this vignette was written before PxWebApi v2 was
introduced.

For PxWebApi v2 functionality, see [Using PxWebApi v2 with
PxWebApiData](pxwebapi_v2.md).

An introduction to the R package PxWebApiData (for PxWebApi v1) is given
below. Six calls to the main function, `ApiData`, are demonstrated.
First, two calls for reading data sets are shown. The third call
captures meta data. However, in practise, one may look at the meta data
first. Then three more examples and some background is given.

Note: Earlier versions of this vignette demonstrated *“readymade
datasets by GetApiData”*. As Statistics Norway will remove the readymade
API during 2025, these examples are now replaced. The new *PxWebApi 2*
is now the primary API for Statistics Norway.

## Specification by variable indices and variable id’s

The dataset below has three variables, Region, ContentsCode and Tid. The
variables can be used as input parameters. Here two of the parameters
are specified by variable id’s and one parameter is specified by
indices. Negative values are used to specify reversed indices. Thus, we
here obtain the two first and the two last years in the data.

A list of two data frames is returned; the label version and the id
version.

``` r
ApiData("https://data.ssb.no/api/v0/en/table/04861",
        Region = c("1103", "0301"), ContentsCode = "Bosatte", Tid = c(1, 2, -2, -1))
```

    $`04861: Area and population of urban settlements, by region, contents and year`
             region            contents year  value
    1 Oslo - Oslove Number of residents 2000 504348
    2 Oslo - Oslove Number of residents 2002 508134
    3 Oslo - Oslove Number of residents 2024 714630
    4 Oslo - Oslove Number of residents 2025 720631
    5     Stavanger Number of residents 2000 106804
    6     Stavanger Number of residents 2002 108271
    7     Stavanger Number of residents 2024 142897
    8     Stavanger Number of residents 2025 143972

    $dataset
      Region ContentsCode  Tid  value
    1   0301      Bosatte 2000 504348
    2   0301      Bosatte 2002 508134
    3   0301      Bosatte 2024 714630
    4   0301      Bosatte 2025 720631
    5   1103      Bosatte 2000 106804
    6   1103      Bosatte 2002 108271
    7   1103      Bosatte 2024 142897
    8   1103      Bosatte 2025 143972

To return a single dataset with only labels use the function `ApiData1`.
The function `Apidata2` returns only id’s. To return a dataset with both
labels and id’s in one dataframe use `ApiData12`.

``` r
ApiData12("https://data.ssb.no/api/v0/en/table/04861",
        Region = c("1103", "0301"), ContentsCode = "Bosatte", Tid = c(1, 2, -2, -1))
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/v0/en/table/04861': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/v0/en/table/04861'

    NULL

## Specification by TRUE, FALSE and imaginary values (e.g. 3i).

All possible values is obtained by TRUE and corresponds to filter
`"all": "*"` in the api query. Elimination of a variable is obtained by
FALSE. An imaginary value corresponds to filter `"top"` in the api
query.

``` r
x <- ApiData("https://data.ssb.no/api/v0/en/table/04861",
        Region = FALSE, ContentsCode = TRUE, Tid = 3i)
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/v0/en/table/04861': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/v0/en/table/04861'

To show either label version or id version

``` r
x[[1]]
```

    NULL

``` r
x[[2]]
```

    NULL

## Show additional information

Use [`info()`](../reference/info.md) and
[`note()`](../reference/info.md) (or
[`comment()`](https://rdrr.io/r/base/comment.html)) to list additional
dataset information.

``` r
info(x)
```

    Warning in max(nchar(com)): no non-missing arguments to max; returning -Inf

``` r
note(x)
```

    Warning in max(nchar(com)): no non-missing arguments to max; returning -Inf

## Obtaining meta data

Meta information about the data set can be obtained by
`returnMetaFrames = TRUE`.

``` r
ApiData("https://data.ssb.no/api/v0/en/table/04861",  returnMetaFrames = TRUE)
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/v0/en/table/04861': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/v0/en/table/04861'

    NULL

## Aggregations using filter *agg:*

PxWebApi offers two more filters for groupings, `agg:` and `vs:`. You
can see these filters in the code “API Query for this table” when you
have made a table in PxWeb.

`agg`: is used for readymade aggregation groupings.

This example shows the use of aggregation in age groups and aggregated
timeseries for the new Norwegian municipality structure from 2020. Also
note the url where `/en` is replaced by `/no`. That returns labels in
Norwegian instead of in English.

``` r
ApiData("https://data.ssb.no/api/v0/no/table/07459",
        Region = list("agg:KommSummer", c("K-3101", "K-3103")),
        Tid = 4i,
        Alder = list("agg:TodeltGrupperingB", c("H17", "H18")),
        Kjonn = TRUE)
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/v0/no/table/07459': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/v0/no/table/07459'

    NULL

There are two limitations in the PxWebApi using these filters.

1.  The name of the filter and the id’s are not shown in metadata, only
    in the code “API Query for this table”.
2.  The filters `agg:` and `vs:` can only take single elements as input.
    Filter `"all":"*"` eg. TRUE, does not work with agg: and vs:.

The other filter `vs:`, specify the grouping value sets, which is a part
of the value pool. As it is only possible to give single elements as
input, it is easier to query the value pool. This means that `vs:` is
redundant.

In this example Region is the value pool and Fylker (counties) is the
value set. As `vs:Fylker` is redundant, both will return the same:

``` r
  Region = list("vs:Fylker",c("01","02"))
  Region = c("01","02")
```

## Return the API query as JSON

In PxWebApi the original query is formulated as JSON. Using the
parameter returnApiQuery is useful for debugging.

``` r
ApiData("https://data.ssb.no/api/v0/en/table/04861",  returnApiQuery = TRUE)
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/v0/en/table/04861': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/v0/en/table/04861'

    NULL

To convert an original JSON API query to a PxWebApiData query there is
also a simple webpage [PxWebApiData call
creator](https://radbrt-px-converter-px-converter-3mdstf.streamlit.app).

## PxWebApi 2 examples with GetApiData

The text in this section was written before the new functionality
described in [Using PxWebApi v2 with PxWebApiData](pxwebapi_v2.md).

The legacy function [`GetApiData()`](../reference/ApiData.md) is
therefore used here. However, the same examples can now be run in
exactly the same way using
[`get_api_data()`](../reference/get_api_data.md) instead.

Statistics Norway has announced that PxWebApi 2 is now the primary API
for Statbank Norway’s 7500 public tables. This API supports GET queries
defined entirely in a URL.

Version 1 of PxWebApi will continue to exist in parallel for a period of
time, but only supports POST queries. The limited API with “readymade
datasets” will be removed during 2025, since PxWebApi 2 offers GET
queries.

The `GetApiData` function can be used with URLs for PxWebApi 2 in a
similar way as it was previously used for “readymade datasets”. It
corresponds to using the parameter `getDataByGET = TRUE` in the
`ApiData` function. Corresponding wrapper functions `GetApiData1`,
`GetApiData2` and `GetApiData12` are available for `ApiData1`,
`ApiData2` and `ApiData12`.

``` r
# Example dataset
url1 <- "https://data.ssb.no/api/pxwebapi/v2/tables/05810/data?lang=en"
x <- GetApiData(url1)
```

    Not available - 429

``` r
x[[1]]    # Label version of the dataset
```

    NULL

``` r
comment(x)
```

    Warning in max(nchar(com)): no non-missing arguments to max; returning -Inf

``` r
# More specific query with selected dimensions
url2 <- paste0(
  "https://data.ssb.no/api/pxwebapi/v2/tables/03013/data?lang=en",
  "&valueCodes[Konsumgrp]=??",
  "&valueCodes[ContentsCode]=KpiIndMnd",
  "&valueCodes[Tid]=top(2)"
)

x2 <- GetApiData2(url2)
```

    Not available - 429

``` r
x2  # id version of the dataset
```

    NULL

## Eurostat data

Eurostat REST API offers JSON-stat version 2. It is possible to use this
package to obtain data from Eurostat by using `GetApiData` or the
similar functions with `1`, `2` or `12` at the end

This example shows HICP total index, latest two periods for EU and
Norway. See [Eurostat
guidelines](https://ec.europa.eu/eurostat/web/user-guides/data-browser/api-data-access/api-detailed-guidelines/api-statistics)
for more.

``` r
urlEurostat <- paste0(   # Here the long url is split into several lines using paste0 
  "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/prc_hicp_mv12r", 
  "?format=JSON&lang=EN&lastTimePeriod=2&coicop=CP00&geo=NO&geo=EU")
urlEurostat
```

    [1] "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/prc_hicp_mv12r?format=JSON&lang=EN&lastTimePeriod=2&coicop=CP00&geo=NO&geo=EU"

``` r
GetApiData12(urlEurostat)
```

    No encoding supplied: defaulting to UTF-8.

      Time frequency                         Unit of measure
    1        Monthly Moving 12 months average rate of change
    2        Monthly Moving 12 months average rate of change
    3        Monthly Moving 12 months average rate of change
    4        Monthly Moving 12 months average rate of change
      Classification of individual consumption by purpose (COICOP)
    1                                               All-items HICP
    2                                               All-items HICP
    3                                               All-items HICP
    4                                               All-items HICP
                                                                                       Geopolitical entity (reporting)
    1 European Union (EU6-1958, EU9-1973, EU10-1981, EU12-1986, EU15-1995, EU25-2004, EU27-2007, EU28-2013, EU27-2020)
    2 European Union (EU6-1958, EU9-1973, EU10-1981, EU12-1986, EU15-1995, EU25-2004, EU27-2007, EU28-2013, EU27-2020)
    3                                                                                                           Norway
    4                                                                                                           Norway
         Time freq         unit coicop geo    time value
    1 2025-11    M RCH_MV12MAVR   CP00  EU 2025-11   2.5
    2 2025-12    M RCH_MV12MAVR   CP00  EU 2025-12   2.5
    3 2025-11    M RCH_MV12MAVR   CP00  NO 2025-11   2.7
    4 2025-12    M RCH_MV12MAVR   CP00  NO 2025-12   2.8

## Practical example

We would like to extract the number of female R&D personel in the
services sector of the Norwegian business life for the years 2019 and
2020.

1.  Locate the relevant table at <https://www.ssb.no> that contains
    information on R&D personel. Having obtained the relevant table,
    table 07964, we create the link
    <https://data.ssb.no/api/v0/no/table/07964/>

2.  Load the package.

``` r
library(PxWebApiData)
```

3.  Check which variables that exist in the data.

``` r
variables <- ApiData("https://data.ssb.no/api/v0/no/table/07964/",
                     returnMetaFrames = TRUE)
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/v0/no/table/07964/': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/v0/no/table/07964/'

``` r
names(variables)
```

    NULL

4.  Check which values each variable contains.

``` r
values <- ApiData("https://data.ssb.no/api/v0/no/table/07964/",
                  returnMetaData = TRUE)
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/v0/no/table/07964/': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/v0/no/table/07964/'

``` r
values[[1]]$values
```

    NULL

``` r
values[[2]]$values
```

    NULL

``` r
values[[3]]$values
```

    NULL

5.  Define these variables in the query to sort out the values we want.

``` r
mydata <- ApiData("https://data.ssb.no/api/v0/en/table/07964/",
                Tid = c("2021", "2022"), # Define year to 2021 and 2022
                NACE2007 = "G-N", # Define the services sector
                ContentsCode = c("KvinneligFoUpers")) # Define women R&D personell
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/v0/en/table/07964/': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/v0/en/table/07964/'

``` r
mydata <- mydata[[1]] # Extract the first list element, which contains full variable names.

head(mydata)
```

    NULL

6.  Show additional information.

``` r
comment(mydata)
```

    Warning in max(nchar(com)): no non-missing arguments to max; returning -Inf

## Background

PxWeb and it’s API, PxWebApi is used as output database (Statbank) by
many statistical agencies in the Nordic countries and several others,
i.e. Statistics Norway, Statistics Finland, Statistics Sweden. See [list
of
installations](https://www.scb.se/en/services/statistical-programs-for-px-files/px-web/pxweb-examples/).

For hints on using PxWebApi in general see [PxWebApi User
Guide](https://www.ssb.no/en/api/pxwebapi/_/attachment/inline/3031ae43-a881-4ae6-b4c9-c04e190b1504:df8c31920354e37f30e21be5641df2d93a16ef6c/Api_user_manual.pdf).
