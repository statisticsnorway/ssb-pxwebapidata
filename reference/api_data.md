# PX-Web Data by API

This function constructs a PxWebApi v2 data URL using
[`query_url()`](query_url.md) and retrieves the data using
[`get_api_data()`](get_api_data.md).

## Usage

``` r
api_data(
  url_or_tableid,
  ...,
  url_type = "ssb",
  use_index = FALSE,
  default_query = c(1, -2, -1),
  return_dataset = NULL,
  make_na_status = TRUE,
  verbose_print = FALSE
)

api_data_1(..., return_dataset = 1)

api_data_2(..., return_dataset = 2)

api_data_12(..., return_dataset = 12)
```

## Arguments

- url_or_tableid:

  A table id, a PxWebApi v2 URL to data or metadata, or metadata
  returned by [`meta_data()`](meta_data.md) or
  [`meta_frames()`](meta_frames.md).

- ...:

  Specification of query for each variable. See ‘Details’.

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

## Value

A data frame, or a list of data frames, depending on the input and
parameters.

## Details

Each variable is specified by using the variable name as an input
parameter.

The value can be specified either as a vector or as a list.

**Vector input**

When specified as a vector, this results in a `valueCodes`
specification. The vector can be specified in the same way as in a
PxWebApi URL. In addition, the specification method inherited from the
legacy [`ApiData()`](ApiData.md) function for PxWebApi v1 can be used:

- `TRUE` means all values and is equivalent to `"*"`.

- `FALSE` means eliminated, which is equivalent to removing the variable
  from the URL. This is meaningful for variables that can be eliminated;
  see the lower examples in [`meta_frames()`](meta_frames.md).

- Imaginary values represent `top`, e.g. `3i` is equivalent to
  `"top(3)"`.

- Numeric values are interpreted as row numbers (negative values
  allowed) or as indices; see the parameter description of `use_index`.

- Codes can be specified directly, including the use of wildcards such
  as `"*"` and `"??"`. Labels may also be used as an alternative to
  codes.

**List input**

When the input is a named list, the URL is constructed directly from the
names and elements of the list (see examples). It is also possible to
omit the name of a list element. In this case, the element results in a
`valueCodes` specification and is processed in the same way as vector
input.

## Examples

``` r
obj <- api_data(14162, Region = FALSE, InnKvartering1 = FALSE, Landkoder2 = FALSE, 
                ContentsCode = TRUE, Tid = 3i, url_type = "ssb_en")
          
obj[[1]]    # The label version of the dataset, as returned by api_data_1()
#>       contents   month   value
#> 1 Guest nights 2025M09 3394329
#> 2 Guest nights 2025M10 2634827
#> 3 Guest nights 2025M11 2221173
obj[[2]]    # The code version of the dataset, as returned by api_data_2()
#>    ContentsCode     Tid   value
#> 1 Overnattinger 2025M09 3394329
#> 2 Overnattinger 2025M10 2634827
#> 3 Overnattinger 2025M11 2221173
names(obj)
#> [1] "14162: Guest nights, by contents and month"
#> [2] "dataset"                                   
info(obj)   # Similar to comment(); see also note() below
#>                                        label 
#> "14162: Guest nights, by contents and month" 
#>                                       source 
#>                          "Statistics Norway" 
#>                                      updated 
#>                       "2026-01-07T07:00:00Z" 
#>                                      tableid 
#>                                      "14162" 
#>                                     contents 
#>                       "14162: Guest nights," 

 # same as above 
 # api_data("https://data.ssb.no/api/pxwebapi/v2/tables/14162/data?lang=en", 
 #           default_query = FALSE, ContentsCode = "*", Tid = "top(3)")
 
 # also same as above 
 # api_data(14162, url_type = "ssb_en", default_query = FALSE,
 #          ContentsCode = list(valueCodes = "*"), 
 #          Tid = list(valueCodes = "top(3)"))

 api_data_1("https://data.ssb.no/api/pxwebapi/v2/tables/09546/data?lang=en",
            Region = FALSE, SkoleSTR = "07", GrSkolOrgForm = "4", 
            EierforhSkole = 1:2, ContentsCode = TRUE, Tid = "202?") 
#>      number of pupils organisational structure       ownership contents year
#> 1  500 pupils or more   Lower secondary school    Municipality  Schools 2020
#> 2  500 pupils or more   Lower secondary school    Municipality  Schools 2021
#> 3  500 pupils or more   Lower secondary school    Municipality  Schools 2022
#> 4  500 pupils or more   Lower secondary school    Municipality  Schools 2023
#> 5  500 pupils or more   Lower secondary school    Municipality  Schools 2024
#> 6  500 pupils or more   Lower secondary school    Municipality  Schools 2025
#> 7  500 pupils or more   Lower secondary school Inter-municipal  Schools 2020
#> 8  500 pupils or more   Lower secondary school Inter-municipal  Schools 2021
#> 9  500 pupils or more   Lower secondary school Inter-municipal  Schools 2022
#> 10 500 pupils or more   Lower secondary school Inter-municipal  Schools 2023
#> 11 500 pupils or more   Lower secondary school Inter-municipal  Schools 2024
#> 12 500 pupils or more   Lower secondary school Inter-municipal  Schools 2025
#>    value
#> 1     27
#> 2     35
#> 3     34
#> 4     36
#> 5     38
#> 6     37
#> 7      0
#> 8      0
#> 9      0
#> 10     0
#> 11     0
#> 12     0
            
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
#>    Region Kjonn Alder ContentsCode  Tid value
#> 1  K-3101     2   H17    Personer1 2024  2944
#> 2  K-3101     2   H17    Personer1 2025  2926
#> 3  K-3101     2   H18    Personer1 2024 12843
#> 4  K-3101     2   H18    Personer1 2025 12954
#> 5  K-3101     1   H17    Personer1 2024  3078
#> 6  K-3101     1   H17    Personer1 2025  3021
#> 7  K-3101     1   H18    Personer1 2024 13070
#> 8  K-3101     1   H18    Personer1 2025 13137
#> 9  K-3103     2   H17    Personer1 2024  4839
#> 10 K-3103     2   H17    Personer1 2025  4784
#> 11 K-3103     2   H18    Personer1 2024 21332
#> 12 K-3103     2   H18    Personer1 2025 21671
#> 13 K-3103     1   H17    Personer1 2024  5059
#> 14 K-3103     1   H17    Personer1 2025  5044
#> 15 K-3103     1   H18    Personer1 2024 20821
#> 16 K-3103     1   H18    Personer1 2025 21147
            
 # codes and labels can be mixed            
 api_data_12(4861, 
             Region = c("Sarpsborg", "3103", "402?"), 
             ContentsCode = "Bosatte", 
             Tid = c(1, -1), 
             url_type = "ssb_en") 
#>           region            contents year Region ContentsCode  Tid value
#> 1           Moss Number of residents 2000   3103      Bosatte 2000     0
#> 2           Moss Number of residents 2025   3103      Bosatte 2025 50591
#> 3      Sarpsborg Number of residents 2000   3105      Bosatte 2000     0
#> 4      Sarpsborg Number of residents 2025   3105      Bosatte 2025 55163
#> 5  Midt-Telemark Number of residents 2000   4020      Bosatte 2000     0
#> 6  Midt-Telemark Number of residents 2025   4020      Bosatte 2025  6231
#> 7        Seljord Number of residents 2000   4022      Bosatte 2000     0
#> 8        Seljord Number of residents 2025   4022      Bosatte 2025  1483
#> 9       Hjartdal Number of residents 2000   4024      Bosatte 2000     0
#> 10      Hjartdal Number of residents 2025   4024      Bosatte 2025     0
#> 11          Tinn Number of residents 2000   4026      Bosatte 2000     0
#> 12          Tinn Number of residents 2025   4026      Bosatte 2025  3716
#> 13     Kviteseid Number of residents 2000   4028      Bosatte 2000     0
#> 14     Kviteseid Number of residents 2025   4028      Bosatte 2025   811
             
 
 # A Statistics Sweden example             
 api_data_12("https://statistikdatabasen.scb.se/api/v2/tables/TAB4537/data?lang=en", 
             Region = "??", 
             Kon = FALSE)                      
#>   region observations year Region ContentsCode  Tid    value
#> 1 Sweden       Number 2015     00     000000VK 2015  9851017
#> 2 Sweden       Number 2023     00     000000VK 2023 10551707
#> 3 Sweden       Number 2024     00     000000VK 2024 10587710

 
 # Use default_query = TRUE to retrieve entire tables
 out <- api_data_2("https://data.ssb.no/api/pxwebapi/v2/tables/10172/data?lang=en", 
                            default_query = TRUE)
 out[14:22, ]  # 9 rows printed      
#>    Vekst  ContentsCode  Tid value NAstatus
#> 14    50   VarigKultur 2015    NA        :
#> 15    50   VarigKultur 2020    NA        .
#> 16    51  Veksthusbedr 2012    NA       ..
#> 17    51  Veksthusbedr 2015    94     <NA>
#> 18    51  Veksthusbedr 2020    89     <NA>
#> 19    51   BedrMedBiol 2012    NA       ..
#> 20    51   BedrMedBiol 2015    67     <NA>
#> 21    51   BedrMedBiol 2020    61     <NA>
#> 22    51 Veksthusareal 2012    NA       ..

 
 # Use note() for explanation of status codes (see api_data() parameter makeNAstatus)                       
 note(out)
#> [1] ". = Category not applicable. Figures do not exist at this time, because the category was not in use when the figures were collected."
#> [2] ": = Confidential. Figures are not published so as to avoid identifying persons or companies."                                        
#> [3] ".. = Data not available. Figures have not been entered into our databases or are too unreliable to be published."                    
 
 # info() and note() return parts of the comment attribute
 info(out)
#>                                                                                label 
#> "10172: Use of biological control agents in greenhouses, by crop, contents and year" 
#>                                                                               source 
#>                                                                  "Statistics Norway" 
#>                                                                              updated 
#>                                                               "2023-04-24T06:00:00Z" 
#>                                                                              tableid 
#>                                                                              "10172" 
#>                                                                             contents 
#>                            "10172: Use of biological control agents in greenhouses," 
 comment(out)
#>                                                                                                                                  label 
#>                                                   "10172: Use of biological control agents in greenhouses, by crop, contents and year" 
#>                                                                                                                                 source 
#>                                                                                                                    "Statistics Norway" 
#>                                                                                                                                updated 
#>                                                                                                                 "2023-04-24T06:00:00Z" 
#>                                                                                                                                tableid 
#>                                                                                                                                "10172" 
#>                                                                                                                               contents 
#>                                                                              "10172: Use of biological control agents in greenhouses," 
#>                                                                                                                                  note1 
#> ". = Category not applicable. Figures do not exist at this time, because the category was not in use when the figures were collected." 
#>                                                                                                                                  note2 
#>                                         ": = Confidential. Figures are not published so as to avoid identifying persons or companies." 
#>                                                                                                                                  note3 
#>                     ".. = Data not available. Figures have not been entered into our databases or are too unreliable to be published." 
```
