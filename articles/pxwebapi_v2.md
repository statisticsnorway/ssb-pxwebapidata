# Using PxWebApi v2 with PxWebApiData

### Preface

This vignette describes the functionality in the R package
**PxWebApiData** related to PxWebApi v2. The new functions follow the
recommended snake_case naming convention.

For older functionality, see [Using PxWebApi v1 with
PxWebApiData](pxwebapi_v1.md).

The vignette first describes the function
[`get_api_data()`](../reference/get_api_data.md) for retrieving data
from a pre-made URL. Note that this function is not limited to PxWebApi.
At the end of the vignette, it is also shown how data from Eurostat can
be retrieved using [`get_api_data()`](../reference/get_api_data.md).

The main function for PxWebApi v2 in the package can be considered to be
[`api_data()`](../reference/api_data.md). It is closely related to
[`ApiData()`](../reference/ApiData.md) for PxWebApi v1. The function
[`api_data()`](../reference/api_data.md) retrieves data in one step.
Internally, the functions [`query_url()`](../reference/query_url.md) and
[`get_api_data()`](../reference/get_api_data.md) are called.

As described later in the vignette, the package also provides dedicated
functions for retrieving metadata associated with PxWebApi v2.

  

## `get_api_data()`: retrieve data from a pre-made URL

When a data URL is already available, the data can be retrieved using
[`get_api_data()`](../reference/get_api_data.md), as illustrated in the
example below.

``` r
url <- paste0(
  "https://data.ssb.no/api/pxwebapi/v2/tables/04861/data?lang=en",
  "&valueCodes[Region]=0301,324*",
  "&valueCodes[ContentsCode]=???????",
  "&valueCodes[Tid]=top(2)"
)

get_api_data(url)
```

    $`04861: Area and population of urban settlements, by region, contents and year`
             region            contents year  value
    1 Oslo - Oslove Number of residents 2024 714630
    2 Oslo - Oslove Number of residents 2025 720631
    3      Eidsvoll Number of residents 2024  23154
    4      Eidsvoll Number of residents 2025  23599
    5        Hurdal Number of residents 2024   1174
    6        Hurdal Number of residents 2025   1217

    $dataset
      Region ContentsCode  Tid  value
    1   0301      Bosatte 2024 714630
    2   0301      Bosatte 2025 720631
    3   3240      Bosatte 2024  23154
    4   3240      Bosatte 2025  23599
    5   3242      Bosatte 2024   1174
    6   3242      Bosatte 2025   1217

To return a single data frame with labels only, use the function
`get_api_data_1`. The function `get_api_data_2` returns codes only. To
return a data frame containing both labels and codes, use
`get_api_data_12`.

The output from [`get_api_data()`](../reference/get_api_data.md) is
identical to the output from [`api_data()`](../reference/api_data.md),
which is shown below. As shown, the functions
[`info()`](../reference/info.md) and [`note()`](../reference/info.md)
can also be used to display additional information.

  

## `query_url()`: generate a URL from specifications

The function [`query_url()`](../reference/query_url.md) can be used to
generate a data URL. The URL used in the example above can be generated
as follows:

``` r
query_url("https://data.ssb.no/api/pxwebapi/v2/tables/04861/data?lang=en", 
          Region = c("0301", "324*"), 
          ContentsCode = "???????", 
          Tid = "top(2)")
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2'

    NULL

The function [`query_url()`](../reference/query_url.md) can be used in
many different ways.

A more detailed description is given below in the section on
[`api_data()`](../reference/api_data.md). The input to the two functions
is identical.

  

## `api_data()`: specify and retrieve data in one step

### Specification by codes, `*`, `?`, and `top(n)`

The dataset considered here has three variables: `Region`,
`ContentsCode`, and `Tid`. These variables can be used as input
parameters.

Each variable can be specified using codes corresponding to the coding
used in PxWebApi URL queries.

Codes can be specified directly. It is also possible to truncate codes
using an asterisk (`*`) or to mask individual characters using a
question mark (`?`). In the example below, seven characters are masked.

Using `top(2)` returns the first two values from the start position.

``` r
api_data("https://data.ssb.no/api/pxwebapi/v2/tables/04861/data?lang=en", 
         Region = c("0301", "324*"), 
         ContentsCode = "???????", 
         Tid = "top(2)")
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2'

    NULL

A list of two data frames is returned: one with labels and one with
codes.

To return a single data frame with labels only, use the function
`api_data_1`. The function `api_data_2` returns codes only. To return a
data frame containing both labels and codes, use `api_data_12`.

Internally, a data URL is first constructed and the data are then
retrieved using the function
[`get_api_data()`](../reference/get_api_data.md).

To obtain the generated URL, replace
[`api_data()`](../reference/api_data.md) with
[`query_url()`](../reference/query_url.md). The URL for this example has
already been generated using [`query_url()`](../reference/query_url.md)
in the example above.

### Specification using (default) indexing

Numeric values are interpreted as indexing, either as row numbers in the
metadata or as indices. See the parameter `use_index` for further
details.

As specified by the parameter `default_query`, unspecified variables are
set to `c(1, -2, -1)`. In the example below, `Tid` is unspecified, which
therefore corresponds to the first and the two last years.

``` r
api_data_12("https://data.ssb.no/api/pxwebapi/v2/tables/04861/data?lang=en", 
           Region = 14:17, 
           ContentsCode = 2)
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2'

    NULL

### Specification using `TRUE`, `FALSE`, imaginary values (e.g. `3i`), and labels

All possible values are obtained by `TRUE` and this is equivalent to
`"*"`. Elimination of a variable is obtained by `FALSE`. Imaginary
values represent `top`, for example `3i` is equivalent to `"top(3)"`.

``` r
api_data_2("https://data.ssb.no/api/pxwebapi/v2/tables/04861/data?lang=en", 
          Region = FALSE, 
          ContentsCode = TRUE, 
          Tid = 3i)
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2'

    NULL

Labels can also be used as an alternative to codes.

``` r
obj <- api_data("https://data.ssb.no/api/pxwebapi/v2/tables/04861/data?lang=en", 
                Region = c("Asker", "Hurdal"), 
                ContentsCode = TRUE, 
                Tid = 2i)
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2'

To show either label version or code version.

``` r
obj[[1]]
```

    NULL

``` r
obj[[2]]
```

    NULL

### Use `default_query = TRUE` to retrieve entire tables

``` r
out <- api_data_2("https://data.ssb.no/api/pxwebapi/v2/tables/10172/data?lang=en", 
                   default_query = TRUE)
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/pxwebapi/v2/tables/10172/metadata?lang=en&outputFormat=json-stat2': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/pxwebapi/v2/tables/10172/metadata?lang=en&outputFormat=json-stat2'

``` r
out[14:20, ]  # 9 rows printed  
```

    NULL

In this case, the `NAstatus` variable is included. See the
[`api_data()`](../reference/api_data.md) parameter `make_na_status`.

### Show additional information

Use [`info()`](../reference/info.md) and
[`note()`](../reference/info.md) (or
[`comment()`](https://rdrr.io/r/base/comment.html)) to list additional
dataset information.

``` r
info(obj)
```

    Warning in max(nchar(com)): no non-missing arguments to max; returning -Inf

``` r
note(obj)
```

    Warning in max(nchar(com)): no non-missing arguments to max; returning -Inf

Use [`note()`](../reference/info.md) for explanation of NA status codes

``` r
note(out)
```

    Warning in max(nchar(com)): no non-missing arguments to max; returning -Inf

### Specification by `list()` for advanced queries

Advanced queries can be specified using named lists, where the names
correspond to the encoding used in PxWebApi URL queries.

``` r
 api_data_2("https://data.ssb.no/api/pxwebapi/v2/tables/07459/data?lang=en",
            Region = list(codelist = "agg_KommSummer", 
                          valueCodes = c("K-3101", "K-3103"), 
                          outputValues = "aggregated"),
            Kjonn = TRUE,
            Alder = list(codelist = "agg_TodeltGrupperingB", 
                         valueCodes = c("H17", "H18"),
                         outputValues = "aggregated"),
            ContentsCode = 1,
            Tid = 2i)  
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/pxwebapi/v2/tables/07459/metadata?lang=en&outputFormat=json-stat2': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/pxwebapi/v2/tables/07459/metadata?lang=en&outputFormat=json-stat2'

    NULL

In this case, the generated URL is:

``` r
 url <- query_url("https://data.ssb.no/api/pxwebapi/v2/tables/07459/data?lang=en",
            Region = list(codelist = "agg_KommSummer", 
                          valueCodes = c("K-3101", "K-3103"), 
                          outputValues = "aggregated"),
            Kjonn = TRUE,
            Alder = list(codelist = "agg_TodeltGrupperingB", 
                         valueCodes = c("H17", "H18"),
                         outputValues = "aggregated"),
            ContentsCode = 1,
            Tid = 2i)
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/pxwebapi/v2/tables/07459/metadata?lang=en&outputFormat=json-stat2': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/pxwebapi/v2/tables/07459/metadata?lang=en&outputFormat=json-stat2'

``` r
 cat(gsub("&", "\n&", url))
```

To improve readability, [`cat()`](https://rdrr.io/r/base/cat.html)
together with [`gsub()`](https://rdrr.io/r/base/grep.html) is used to
print the long URL across multiple lines.

This query is constructed using information available in the metadata;
see the section below.

  

## Obtaining metadata

### `meta_frames()`

Metadata for a data set can be obtained using
[`meta_frames()`](../reference/meta_frames.md).

``` r
mf <- meta_frames("https://data.ssb.no/api/pxwebapi/v2/tables/04861/data?lang=en")
```

    Warning converted to message: cannot open URL 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2': HTTP status was '429 Unknown Error'

    No internet connection or resource not available: Error in open.connection(con, "rb") : 
      cannot open the connection to 'https://data.ssb.no/api/pxwebapi/v2/tables/04861/metadata?lang=en&outputFormat=json-stat2'

``` r
print(mf)
```

    NULL

Information about whether variables can be eliminated is stored as an
attribute and can be retrieved for all variables at once:

``` r
sapply(mf, attr, "elimination") # elimination info for all variables
```

    list()

Code list information is stored as a data frame in another attribute:

``` r
attr(mf[["Region"]], "code_lists")
```

    NULL

### `meta_code_list()`

Metadata for code lists referenced in this output can be retrieved using
[`meta_code_list()`](../reference/meta_code_list.md).

### `meta_data()`

To download raw metadata without further processing, use
[`meta_data()`](../reference/meta_data.md).

Note that it does not matter whether the input URL refers to data or
metadata; this is handled automatically.

  

## Eurostat data

Eurostat REST API offers JSON-stat version 2. It is possible to use this
package to obtain data from Eurostat by using `get_api_data` or the
similar functions with `1`, `2` or `12` at the end

This example shows HICP total index, latest two periods for EU and
Norway. See [Eurostat
guidelines](https://ec.europa.eu/eurostat/web/user-guides/data-browser/api-data-access/api-detailed-guidelines/api-statistics)
for more.

``` r
url_eurostat <- paste0(   # Here the long url is split into several lines using paste0 
  "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/prc_hicp_mv12r", 
  "?format=JSON&lang=EN&lastTimePeriod=2&coicop=CP00&geo=NO&geo=EU")
url_eurostat
```

    [1] "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/prc_hicp_mv12r?format=JSON&lang=EN&lastTimePeriod=2&coicop=CP00&geo=NO&geo=EU"

``` r
get_api_data_12(url_eurostat)
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

  

## Background

PxWeb and it’s API, PxWebApi is used as output database (Statbank) by
many statistical agencies in the Nordic countries and several others,
i.e. Statistics Norway, Statistics Finland, Statistics Sweden. See [list
of
installations](https://www.scb.se/en/services/statistical-programs-for-px-files/px-web/pxweb-examples/).

For hints on using PxWebApi v2 in general see [PxWebApi v2 User
Guide](https://www.ssb.no/en/api/pxwebapiv2).
