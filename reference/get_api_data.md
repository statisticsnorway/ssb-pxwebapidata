# PX-Web Data by API (GET)

A function to read PX-Web data into R via API using GET.

## Usage

``` r
get_api_data(
  url,
  return_dataset = NULL,
  make_na_status = TRUE,
  verbose_print = FALSE,
  use_ensure_json_stat2 = "auto"
)

get_api_data_1(..., return_dataset = 1)

get_api_data_2(..., return_dataset = 2)

get_api_data_12(..., return_dataset = 12)
```

## Arguments

- url:

  A PxWeb API URL to data.

- return_dataset:

  Possible non-NULL values are `1`, `2` and `12`. Then a single data set
  is returned as a data frame.

- make_na_status:

  When TRUE and when dataPackage is `"rjstat"` and when missing entries
  in `value`, the function tries to add an additional variable, named
  `NAstatus`, with status codes. An explanation of these status codes is
  provided in the note part of the comment attribute, i.e. what you get
  with [`note()`](info.md). See the bottom example.

- verbose_print:

  When TRUE, printing to console

- use_ensure_json_stat2:

  `TRUE`, `FALSE`, or `"auto"` (default). If `"auto"`, the URL is
  modified by [`ensure_json_stat2()`](ensure_json_stat2.md) only when
  `"/v2/"` is detected in the URL.

- ...:

  Additional arguments passed to `get_api_data()`.

## Value

A data frame, or a list of data frames, depending on the input and
parameters.

## Examples

``` r
url <- paste0(
  "https://data.ssb.no/api/pxwebapi/v2/tables/03013/data?lang=en",
  "&valueCodes[Konsumgrp]=??",
  "&valueCodes[ContentsCode]=KpiIndMnd",
  "&valueCodes[Tid]=top(2)"
)
  
get_api_data_2(url)    
#>    Konsumgrp ContentsCode     Tid value
#> 1         01    KpiIndMnd 2025M11 141.6
#> 2         01    KpiIndMnd 2025M12 139.2
#> 3         02    KpiIndMnd 2025M11 132.1
#> 4         02    KpiIndMnd 2025M12 132.0
#> 5         03    KpiIndMnd 2025M11 105.9
#> 6         03    KpiIndMnd 2025M12 105.6
#> 7         04    KpiIndMnd 2025M11 143.7
#> 8         04    KpiIndMnd 2025M12 144.0
#> 9         05    KpiIndMnd 2025M11 142.0
#> 10        05    KpiIndMnd 2025M12 144.8
#> 11        06    KpiIndMnd 2025M11 133.2
#> 12        06    KpiIndMnd 2025M12 133.7
#> 13        07    KpiIndMnd 2025M11 140.0
#> 14        07    KpiIndMnd 2025M12 140.9
#> 15        08    KpiIndMnd 2025M11 133.1
#> 16        08    KpiIndMnd 2025M12 134.8
#> 17        09    KpiIndMnd 2025M11 148.9
#> 18        09    KpiIndMnd 2025M12 148.9
#> 19        10    KpiIndMnd 2025M11 148.2
#> 20        10    KpiIndMnd 2025M12 148.2
#> 21        11    KpiIndMnd 2025M11 150.0
#> 22        11    KpiIndMnd 2025M12 150.5
#> 23        12    KpiIndMnd 2025M11 122.2
#> 24        12    KpiIndMnd 2025M12 122.5
  
```
