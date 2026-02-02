# PX-Web Data by API

A function to read PX-Web data into R via API. The example code reads
data from the three national statistical institutes, Statistics Norway,
Statistics Sweden and Statistics Finland.

## Usage

``` r
ApiData(
  urlToData,
  ...,
  getDataByGET = FALSE,
  returnMetaData = FALSE,
  returnMetaValues = FALSE,
  returnMetaFrames = FALSE,
  returnApiQuery = FALSE,
  defaultJSONquery = c(1, -2, -1),
  verbosePrint = FALSE,
  use_factors = FALSE,
  urlType = "SSB",
  apiPackage = "httr",
  dataPackage = "rjstat",
  returnDataSet = NULL,
  makeNAstatus = TRUE,
  responseFormat = "json-stat2"
)

GetApiData(..., getDataByGET = TRUE)

pxwebData(..., apiPackage = "pxweb", dataPackage = "pxweb")

PxData(..., apiPackage = "pxweb", dataPackage = "rjstat")

ApiData1(..., returnDataSet = 1)

ApiData2(..., returnDataSet = 2)

ApiData12(..., returnDataSet = 12)

GetApiData1(..., returnDataSet = 1)

GetApiData2(..., returnDataSet = 2)

GetApiData12(..., returnDataSet = 12)

pxwebData1(..., returnDataSet = 1)

pxwebData2(..., returnDataSet = 2)

pxwebData12(..., returnDataSet = 12)

PxData1(..., returnDataSet = 1)

PxData2(..., returnDataSet = 2)

PxData12(..., returnDataSet = 12)
```

## Arguments

- urlToData:

  url to data or id of SSB data

- ...:

  specification of JSON query for each variable

- getDataByGET:

  When TRUE, readymade dataset by GET

- returnMetaData:

  When TRUE, metadata returned

- returnMetaValues:

  When TRUE, values from metadata returned

- returnMetaFrames:

  When TRUE, values and valueTexts from metadata returned as data frames

- returnApiQuery:

  When TRUE, JSON query returned

- defaultJSONquery:

  specification for variables not included in ...

- verbosePrint:

  When TRUE, printing to console

- use_factors:

  Parameter to
  [`fromJSONstat`](https://rdrr.io/pkg/rjstat/man/fromJSONstat.html)
  defining whether dimension categories should be factors or character
  objects.

- urlType:

  Parameter defining how url is constructed from id number. Currently
  two Statistics Norway possibilities: "SSB" (Norwegian) or "SSBen"
  (English)

- apiPackage:

  Package used to capture json(-stat) data from API: `"httr"` (default)
  or `"pxweb"`

- dataPackage:

  Package used to transform json(-stat) data to data frame: `"rjstat"`
  (default) or `"pxweb"`

- returnDataSet:

  Possible non-NULL values are `1`, `2` and `12`. Then a single data set
  is returned as a data frame.

  - **`1`:** The first data set

  - **`2`:** The second data set

  - **`12`:** Both data sets combined

- makeNAstatus:

  When TRUE and when dataPackage is `"rjstat"` and when missing entries
  in `value`, the function tries to add an additional variable, named
  `NAstatus`, with status codes. An explanation of these status codes is
  provided in the note part of the comment attribute, i.e. what you get
  with [`note()`](info.md). See the bottom example.

- responseFormat:

  Response format to be used when `apiPackage` and `dataPackage` are
  defaults (`"json-stat"` or `"json-stat2"`).

## Value

list of two data sets (label and id)

## Details

Each variable is specified by using the variable name as input
parameter. The value can be specified as: TRUE (all), FALSE
(eliminated), imaginary value (top), variable indices, original variable
id's (values) or variable labels (valueTexts). Reversed indices can be
specified as negative values. Indices outside the range are removed.
Variables not specified is set to the value of defaultJSONquery whose
default means the first and the two last elements.

The value can also be specified as a (unnamed) two-element list
corresponding to the two query elements, filter and values. In addition
it possible with a single-element list. Then filter is set to 'all'. See
examples.

A `comment` attribute with the elements `label`, `source`, and `updated`
is added to the output as a named character vector. When available,
elements originating from `tableid`, `contents`, and `note` are also
included, resulting in a vector with at least three elements. Use
[`comment()`](https://rdrr.io/r/base/comment.html) to view these
selected metadata elements. Alternatively, use [`info()`](info.md) or
[`note()`](info.md) to extract specific parts. The documentation for
these two functions provides further details.

Functionality in the package `pxweb` can be utilized by making use of
the parameters `apiPackage` and `dataPackage` as implemented as the
wrappers `PxData` and `pxwebData`. With data sets too large for ordinary
downloads, `PxData` can solve the problem (multiple downloads). When
using `pxwebData`, data will be downloaded in px-json format instead of
json-stat and the output data frame will be organized differently
(ContentsCode categories as separate variables).

## Note

See the package vignette for aggregations using filter `agg`.

## Examples

``` r
# \donttest{
# Note: Example with "readymade datasets" has been removed.
# SSB announced that this service will be discontinued in 2025.
# It is replaced here with an example using PxWebApi v2,
# which supports GET queries and richer options.

url <- "https://data.ssb.no/api/pxwebapi/v2/tables/05810/data?lang=en"
x <- ApiData(url, getDataByGET = TRUE)

x[[1]]    # The label version of the dataset
#>                  age contents year     gender   value
#> 1                All  Persons 2025 Both sexes 5594340
#> 2                All  Persons 2025    Females 2775143
#> 3                All  Persons 2025      Males 2819197
#> 4          0-6 years  Persons 2025 Both sexes  390630
#> 5          0-6 years  Persons 2025    Females  190150
#> 6          0-6 years  Persons 2025      Males  200480
#> 7         7-15 years  Persons 2025 Both sexes  581299
#> 8         7-15 years  Persons 2025    Females  282276
#> 9         7-15 years  Persons 2025      Males  299023
#> 10       16-44 years  Persons 2025 Both sexes 2130051
#> 11       16-44 years  Persons 2025    Females 1039077
#> 12       16-44 years  Persons 2025      Males 1090974
#> 13       45-66 years  Persons 2025 Both sexes 1554724
#> 14       45-66 years  Persons 2025    Females  764745
#> 15       45-66 years  Persons 2025      Males  789979
#> 16       67-79 years  Persons 2025 Both sexes  667099
#> 17       67-79 years  Persons 2025    Females  341694
#> 18       67-79 years  Persons 2025      Males  325405
#> 19 80 years or older  Persons 2025 Both sexes  270537
#> 20 80 years or older  Persons 2025    Females  157201
#> 21 80 years or older  Persons 2025      Males  113336
x[[2]]    # The id version of the dataset
#>    Alder ContentsCode  Tid Kjonn   value
#> 1   999B     Personer 2025     0 5594340
#> 2   999B     Personer 2025     2 2775143
#> 3   999B     Personer 2025     1 2819197
#> 4  00-06     Personer 2025     0  390630
#> 5  00-06     Personer 2025     2  190150
#> 6  00-06     Personer 2025     1  200480
#> 7  07-15     Personer 2025     0  581299
#> 8  07-15     Personer 2025     2  282276
#> 9  07-15     Personer 2025     1  299023
#> 10 16-44     Personer 2025     0 2130051
#> 11 16-44     Personer 2025     2 1039077
#> 12 16-44     Personer 2025     1 1090974
#> 13 45-66     Personer 2025     0 1554724
#> 14 45-66     Personer 2025     2  764745
#> 15 45-66     Personer 2025     1  789979
#> 16 67-79     Personer 2025     0  667099
#> 17 67-79     Personer 2025     2  341694
#> 18 67-79     Personer 2025     1  325405
#> 19   80+     Personer 2025     0  270537
#> 20   80+     Personer 2025     2  157201
#> 21   80+     Personer 2025     1  113336
names(x)
#> [1] "05810: Population, by age, contents, year and gender"
#> [2] "dataset"                                             
note(x)
#> [1] "Until 1990 the figures correspond per 31 Desember. As from 1995 the figures correspond per 1 January."
info(x)
#>                                                  label 
#> "05810: Population, by age, contents, year and gender" 
#>                                                 source 
#>                                    "Statistics Norway" 
#>                                                updated 
#>                                 "2025-02-25T07:00:00Z" 
#>                                                tableid 
#>                                                "05810" 
#>                                               contents 
#>                                   "05810: Population," 
comment(x)
#>                                                                                                   label 
#>                                                  "05810: Population, by age, contents, year and gender" 
#>                                                                                                  source 
#>                                                                                     "Statistics Norway" 
#>                                                                                                 updated 
#>                                                                                  "2025-02-25T07:00:00Z" 
#>                                                                                                 tableid 
#>                                                                                                 "05810" 
#>                                                                                                contents 
#>                                                                                    "05810: Population," 
#>                                                                                                    note 
#> "Until 1990 the figures correspond per 31 Desember. As from 1995 the figures correspond per 1 January." 

# As above, but with single dataset output
x1 <- ApiData1(url, getDataByGET = TRUE) # as x[[1]]
x2 <- ApiData2(url, getDataByGET = TRUE) # as x[[2]]
ApiData12(url, getDataByGET = TRUE)      # Combined
#>                  age contents year     gender Alder ContentsCode  Tid Kjonn
#> 1                All  Persons 2025 Both sexes  999B     Personer 2025     0
#> 2                All  Persons 2025    Females  999B     Personer 2025     2
#> 3                All  Persons 2025      Males  999B     Personer 2025     1
#> 4          0-6 years  Persons 2025 Both sexes 00-06     Personer 2025     0
#> 5          0-6 years  Persons 2025    Females 00-06     Personer 2025     2
#> 6          0-6 years  Persons 2025      Males 00-06     Personer 2025     1
#> 7         7-15 years  Persons 2025 Both sexes 07-15     Personer 2025     0
#> 8         7-15 years  Persons 2025    Females 07-15     Personer 2025     2
#> 9         7-15 years  Persons 2025      Males 07-15     Personer 2025     1
#> 10       16-44 years  Persons 2025 Both sexes 16-44     Personer 2025     0
#> 11       16-44 years  Persons 2025    Females 16-44     Personer 2025     2
#> 12       16-44 years  Persons 2025      Males 16-44     Personer 2025     1
#> 13       45-66 years  Persons 2025 Both sexes 45-66     Personer 2025     0
#> 14       45-66 years  Persons 2025    Females 45-66     Personer 2025     2
#> 15       45-66 years  Persons 2025      Males 45-66     Personer 2025     1
#> 16       67-79 years  Persons 2025 Both sexes 67-79     Personer 2025     0
#> 17       67-79 years  Persons 2025    Females 67-79     Personer 2025     2
#> 18       67-79 years  Persons 2025      Males 67-79     Personer 2025     1
#> 19 80 years or older  Persons 2025 Both sexes   80+     Personer 2025     0
#> 20 80 years or older  Persons 2025    Females   80+     Personer 2025     2
#> 21 80 years or older  Persons 2025      Males   80+     Personer 2025     1
#>      value
#> 1  5594340
#> 2  2775143
#> 3  2819197
#> 4   390630
#> 5   190150
#> 6   200480
#> 7   581299
#> 8   282276
#> 9   299023
#> 10 2130051
#> 11 1039077
#> 12 1090974
#> 13 1554724
#> 14  764745
#> 15  789979
#> 16  667099
#> 17  341694
#> 18  325405
#> 19  270537
#> 20  157201
#> 21  113336

# Note: Instead of setting getDataByGET = TRUE manually,
# you can use the wrapper functions GetApiData() or GetApiData12().
# In addition, there are wrapper functions GetApiData1() and GetApiData2(),
# which correspond to ApiData1() and ApiData2().


##### Special output
ApiData("https://data.ssb.no/api/v0/en/table/11419", returnMetaData = TRUE)   # meta data
#> [[1]]
#> [[1]]$code
#> [1] "MaaleMetode"
#> 
#> [[1]]$text
#> [1] "measuring method"
#> 
#> [[1]]$values
#> [1] "02"  "01"  "051" "061" "10"  "11" 
#> 
#> [[1]]$valueTexts
#> [1] "Average"                             "Median"                             
#> [3] "Lower quartile"                      "Upper quartile"                     
#> [5] "Number of employments with earnings" "Number of full-time equivalents"    
#> 
#> 
#> [[2]]
#> [[2]]$code
#> [1] "Yrke"
#> 
#> [[2]]$text
#> [1] "occupation"
#> 
#> [[2]]$values
#>  [1] "0-9"  "1"    "1120" "2"    "3"    "4"    "5"    "6"    "7"    "8"   
#> [11] "9"   
#> 
#> [[2]]$valueTexts
#>  [1] "All occupations"                                   
#>  [2] "Managers"                                          
#>  [3] "Managing directors and chief executives"           
#>  [4] "Professionals"                                     
#>  [5] "Technicians and associate professionals"           
#>  [6] "Clerical support workers"                          
#>  [7] "Service and sales workers"                         
#>  [8] "Skilled agricultural, forestry and fishery workers"
#>  [9] "Craft and related trades workers"                  
#> [10] "Plant and machine operators and assemblers"        
#> [11] "Elementary occupations"                            
#> 
#> [[2]]$elimination
#> [1] TRUE
#> 
#> 
#> [[3]]
#> [[3]]$code
#> [1] "Sektor"
#> 
#> [[3]]$text
#> [1] "sector"
#> 
#> [[3]]$values
#> [1] "ALLE"    "A+B+D+E" "6500"    "6100"   
#> 
#> [[3]]$valueTexts
#> [1] "Sum all sectors"                      
#> [2] "Private sector and public enterprises"
#> [3] "Local government"                     
#> [4] "Central government"                   
#> 
#> [[3]]$elimination
#> [1] TRUE
#> 
#> 
#> [[4]]
#> [[4]]$code
#> [1] "NACE2007"
#> 
#> [[4]]$text
#> [1] "industry (SIC2007)"
#> 
#> [[4]]$values
#>   [1] "01-03"               "03.2"                "05_07_08_09.9"      
#>   [4] "05-09"               "06+09.1"             "10-12"              
#>   [7] "10-33"               "13-15"               "16"                 
#>  [10] "17"                  "18"                  "19-21"              
#>  [13] "22-23"               "24"                  "25"                 
#>  [16] "26-27"               "28"                  "29-30"              
#>  [19] "31-32"               "33"                  "35-39"              
#>  [22] "41"                  "41-43"               "42"                 
#>  [25] "43"                  "45"                  "45-47"              
#>  [28] "46"                  "47"                  "49.1_49.3"          
#>  [31] "49.2_49.4"           "49-53"               "50.1"               
#>  [34] "50.2"                "51"                  "52"                 
#>  [37] "53"                  "55"                  "55-56"              
#>  [40] "56.1_56.3"           "56.2"                "58"                 
#>  [43] "58-63"               "59"                  "60"                 
#>  [46] "61"                  "62"                  "63"                 
#>  [49] "64.1_65.1-65.3"      "64.2-64.9_66.1-66.3" "64-66"              
#>  [52] "68-75"               "68.2"                "68.31"              
#>  [55] "69"                  "70"                  "71"                 
#>  [58] "72"                  "73"                  "77"                 
#>  [61] "77-82"               "78"                  "79"                 
#>  [64] "80"                  "81"                  "81.2"               
#>  [67] "82"                  "84"                  "84.11"              
#>  [70] "84.12"               "84.13"               "84.21"              
#>  [73] "84.22"               "84.23"               "84.24"              
#>  [76] "84.25"               "84.30"               "85"                 
#>  [79] "85.1-85.2"           "85.3"                "85.4"               
#>  [82] "85.5-85.6"           "86-88"               "86"                 
#>  [85] "86.1"                "87"                  "88.1"               
#>  [88] "88.911"              "88.99"               "88.993-88.994"      
#>  [91] "90"                  "90-99"               "91"                 
#>  [94] "93"                  "94.1"                "94.2"               
#>  [97] "94.9"                "95"                  "96"                 
#> [100] "97"                  "99"                  "00.0"               
#> [103] "00"                  "A"                   "A-S"                
#> [106] "B"                   "C"                   "D"                  
#> [109] "E"                   "F"                   "G"                  
#> [112] "H"                   "I"                   "J"                  
#> [115] "K"                   "L"                   "M"                  
#> [118] "N"                   "O"                   "P"                  
#> [121] "Q"                   "R"                   "S"                  
#> [124] "T"                   "U"                  
#> 
#> [[4]]$valueTexts
#>   [1] "Agriculture, forestry and fishing"                                          
#>   [2] "Aquaculture"                                                                
#>   [3] "Mining"                                                                     
#>   [4] "Mining and quarrying"                                                       
#>   [5] "Oil and gas extraction incl. support activities"                            
#>   [6] "Manufacture of food products, beverages and tobacco"                        
#>   [7] "Manufacture"                                                                
#>   [8] "Manufacture of textiles, wearing apparel and leather products"              
#>   [9] "Wood and wood products"                                                     
#>  [10] "Paper and paper products"                                                   
#>  [11] "Printing and reproduction"                                                  
#>  [12] "Refined petro., chemicals, pharmac."                                        
#>  [13] "Rubber, plastic and mineral prod."                                          
#>  [14] "Basic metals"                                                               
#>  [15] "Fabricated metal prod."                                                     
#>  [16] "Computer and electrical equipment"                                          
#>  [17] "Machinery and equipment"                                                    
#>  [18] "Other workshop industry"                                                    
#>  [19] "Furniture and manufacturing n.e.c."                                         
#>  [20] "Repair, installation of machinery"                                          
#>  [21] "Electricity, water supply, sewerage, waste management"                      
#>  [22] "Construction of buildings"                                                  
#>  [23] "Construction"                                                               
#>  [24] "Civil engineering"                                                          
#>  [25] "Specialised construction activities"                                        
#>  [26] "Wholesale and retail trade and repair of motor vehicles and motorcycles"    
#>  [27] "Wholesale and retail trade: repair of motor vehicles and motorcycles"       
#>  [28] "Wholesale trade, except of motor vehicles and motorcycles"                  
#>  [29] "Retail trade, except of motor vehicles and motorcycles"                     
#>  [30] "Passenger land transport"                                                   
#>  [31] "Freight land transport"                                                     
#>  [32] "Transportation and storage"                                                 
#>  [33] "Sea and coastal passenger water transport"                                  
#>  [34] "Sea and coastal freight water transport"                                    
#>  [35] "Air transport"                                                              
#>  [36] "Support activities for transportation"                                      
#>  [37] "Postal and courier activities"                                              
#>  [38] "Accommodation"                                                              
#>  [39] "Accommodation and food service activities"                                  
#>  [40] "Restaurants and beverage serving activities"                                
#>  [41] "Event catering and other food service activities"                           
#>  [42] "Publishing activities"                                                      
#>  [43] "Information and communication"                                              
#>  [44] "Motion picture, TV, music prod."                                            
#>  [45] "Programming, broadcasting activities"                                       
#>  [46] "Telecommunications"                                                         
#>  [47] "Computer programming, consultancy"                                          
#>  [48] "Information service activities"                                             
#>  [49] "Monetary and insurance intermediation"                                      
#>  [50] "Other financial intermediation"                                             
#>  [51] "Financial and insurance activities"                                         
#>  [52] "Real estate, professional, scientific and technical activities"             
#>  [53] "Renting and operating of own or leased real estate"                         
#>  [54] "Real estate agencies"                                                       
#>  [55] "Legal and accounting activities"                                            
#>  [56] "Head offices, management consult."                                          
#>  [57] "Architecture, engineering activities"                                       
#>  [58] "Scientific research and development"                                        
#>  [59] "Advertising and market research"                                            
#>  [60] "Rental and leasing activities"                                              
#>  [61] "Administrative and support service activities"                              
#>  [62] "Employment activities"                                                      
#>  [63] "Travel agency, tour operators"                                              
#>  [64] "Security, investigation activities"                                         
#>  [65] "Buildings, landscape service activities"                                    
#>  [66] "Cleaning activities"                                                        
#>  [67] "Business support activities"                                                
#>  [68] "Public adm., defence, soc. security"                                        
#>  [69] "General public administration activities"                                   
#>  [70] "Act. provid. health care, educ. etc."                                       
#>  [71] "Regulation of and contribution to more efficient operation of businesses"   
#>  [72] "Foreign affairs"                                                            
#>  [73] "Defence activities"                                                         
#>  [74] "Justice and judicial activities"                                            
#>  [75] "Public order and safety activities"                                         
#>  [76] "Fire service activities"                                                    
#>  [77] "Compulsory social security activities"                                      
#>  [78] "Education"                                                                  
#>  [79] "Primary education"                                                          
#>  [80] "Secondary education"                                                        
#>  [81] "Higher education"                                                           
#>  [82] "Other education and educational support activities"                         
#>  [83] "Human health and social work activities"                                    
#>  [84] "Human health activities"                                                    
#>  [85] "Hospital activities"                                                        
#>  [86] "Residential care activities"                                                
#>  [87] "Social work activities without accommodation for the elderly and disabled"  
#>  [88] "Nursery schools"                                                            
#>  [89] "Other social work activities without accommodation n.e.c."                  
#>  [90] "Vocational rehabilitation activities"                                       
#>  [91] "Arts and entertainment activities"                                          
#>  [92] "Other service activities"                                                   
#>  [93] "Libraries, museums, other culture"                                          
#>  [94] "Sports, amusement, recreation"                                              
#>  [95] "Activities of business, employers and professional membership organisations"
#>  [96] "Activities of trade unions"                                                 
#>  [97] "Activities of other membership organisations"                               
#>  [98] "Repair, personal, household goods"                                          
#>  [99] "Other personal service activities"                                          
#> [100] "Households as employers activities"                                         
#> [101] "Extraterritorial organisations and bodies"                                  
#> [102] "Unspecified"                                                                
#> [103] "Unspecified"                                                                
#> [104] "Agriculture, forestry and fishing"                                          
#> [105] "All industries"                                                             
#> [106] "Mining and quarrying"                                                       
#> [107] "Manufacturing"                                                              
#> [108] "Electricity, gas and steam"                                                 
#> [109] "Water supply, sewerage, waste"                                              
#> [110] "Construction"                                                               
#> [111] "Wholesale and retail trade: repair of motor vehicles and motorcycles"       
#> [112] "Transportation and storage"                                                 
#> [113] "Accommodation and food service activities"                                  
#> [114] "Information and communication"                                              
#> [115] "Financial and insurance activities"                                         
#> [116] "Real estate activities"                                                     
#> [117] "Professional, scientific and technical activities"                          
#> [118] "Administrative and support service activities"                              
#> [119] "Public administration and defence"                                          
#> [120] "Education"                                                                  
#> [121] "Human health and social work activities"                                    
#> [122] "Arts, entertainment and recreation"                                         
#> [123] "Other service activities"                                                   
#> [124] "Activities of household as employers"                                       
#> [125] "Activities of extraterritorial organisations and bodies"                    
#> 
#> [[4]]$elimination
#> [1] TRUE
#> 
#> 
#> [[5]]
#> [[5]]$code
#> [1] "Kjonn"
#> 
#> [[5]]$text
#> [1] "gender"
#> 
#> [[5]]$values
#> [1] "0" "2" "1"
#> 
#> [[5]]$valueTexts
#> [1] "Both sexes" "Females"    "Males"     
#> 
#> [[5]]$elimination
#> [1] TRUE
#> 
#> 
#> [[6]]
#> [[6]]$code
#> [1] "AvtaltVanlig"
#> 
#> [[6]]$text
#> [1] "contractual/usual working hours per week"
#> 
#> [[6]]$values
#> [1] "0" "5" "6"
#> 
#> [[6]]$valueTexts
#> [1] "All employees"       "Full-time employees" "Part-time employees"
#> 
#> [[6]]$elimination
#> [1] TRUE
#> 
#> 
#> [[7]]
#> [[7]]$code
#> [1] "ContentsCode"
#> 
#> [[7]]$text
#> [1] "contents"
#> 
#> [[7]]$values
#> [1] "Manedslonn"       "AvtaltManedslonn" "Uregtil"          "Bonus"           
#> [5] "Overtid"          "AlderLA"          "AvtArbTid"       
#> 
#> [[7]]$valueTexts
#> [1] "Monthly earnings (NOK)"                    
#> [2] "Basic monthly salary (NOK)"                
#> [3] "Variable additional allowances (NOK)"      
#> [4] "Bonus (NOK)"                               
#> [5] "Overtime pay (NOK)"                        
#> [6] "Age (years)"                               
#> [7] "Contractual working hours per week (hours)"
#> 
#> 
#> [[8]]
#> [[8]]$code
#> [1] "Tid"
#> 
#> [[8]]$text
#> [1] "year"
#> 
#> [[8]]$values
#>  [1] "2015" "2016" "2017" "2018" "2019" "2020" "2021" "2022" "2023" "2024"
#> 
#> [[8]]$valueTexts
#>  [1] "2015" "2016" "2017" "2018" "2019" "2020" "2021" "2022" "2023" "2024"
#> 
#> [[8]]$time
#> [1] TRUE
#> 
#> 
ApiData("https://data.ssb.no/api/v0/en/table/11419", returnMetaValues = TRUE) # meta data values
#> $MaaleMetode
#> [1] "02"  "01"  "051" "061" "10"  "11" 
#> 
#> $Yrke
#>  [1] "0-9"  "1"    "1120" "2"    "3"    "4"    "5"    "6"    "7"    "8"   
#> [11] "9"   
#> 
#> $Sektor
#> [1] "ALLE"    "A+B+D+E" "6500"    "6100"   
#> 
#> $NACE2007
#>   [1] "01-03"               "03.2"                "05_07_08_09.9"      
#>   [4] "05-09"               "06+09.1"             "10-12"              
#>   [7] "10-33"               "13-15"               "16"                 
#>  [10] "17"                  "18"                  "19-21"              
#>  [13] "22-23"               "24"                  "25"                 
#>  [16] "26-27"               "28"                  "29-30"              
#>  [19] "31-32"               "33"                  "35-39"              
#>  [22] "41"                  "41-43"               "42"                 
#>  [25] "43"                  "45"                  "45-47"              
#>  [28] "46"                  "47"                  "49.1_49.3"          
#>  [31] "49.2_49.4"           "49-53"               "50.1"               
#>  [34] "50.2"                "51"                  "52"                 
#>  [37] "53"                  "55"                  "55-56"              
#>  [40] "56.1_56.3"           "56.2"                "58"                 
#>  [43] "58-63"               "59"                  "60"                 
#>  [46] "61"                  "62"                  "63"                 
#>  [49] "64.1_65.1-65.3"      "64.2-64.9_66.1-66.3" "64-66"              
#>  [52] "68-75"               "68.2"                "68.31"              
#>  [55] "69"                  "70"                  "71"                 
#>  [58] "72"                  "73"                  "77"                 
#>  [61] "77-82"               "78"                  "79"                 
#>  [64] "80"                  "81"                  "81.2"               
#>  [67] "82"                  "84"                  "84.11"              
#>  [70] "84.12"               "84.13"               "84.21"              
#>  [73] "84.22"               "84.23"               "84.24"              
#>  [76] "84.25"               "84.30"               "85"                 
#>  [79] "85.1-85.2"           "85.3"                "85.4"               
#>  [82] "85.5-85.6"           "86-88"               "86"                 
#>  [85] "86.1"                "87"                  "88.1"               
#>  [88] "88.911"              "88.99"               "88.993-88.994"      
#>  [91] "90"                  "90-99"               "91"                 
#>  [94] "93"                  "94.1"                "94.2"               
#>  [97] "94.9"                "95"                  "96"                 
#> [100] "97"                  "99"                  "00.0"               
#> [103] "00"                  "A"                   "A-S"                
#> [106] "B"                   "C"                   "D"                  
#> [109] "E"                   "F"                   "G"                  
#> [112] "H"                   "I"                   "J"                  
#> [115] "K"                   "L"                   "M"                  
#> [118] "N"                   "O"                   "P"                  
#> [121] "Q"                   "R"                   "S"                  
#> [124] "T"                   "U"                  
#> 
#> $Kjonn
#> [1] "0" "2" "1"
#> 
#> $AvtaltVanlig
#> [1] "0" "5" "6"
#> 
#> $ContentsCode
#> [1] "Manedslonn"       "AvtaltManedslonn" "Uregtil"          "Bonus"           
#> [5] "Overtid"          "AlderLA"          "AvtArbTid"       
#> 
#> $Tid
#>  [1] "2015" "2016" "2017" "2018" "2019" "2020" "2021" "2022" "2023" "2024"
#> 
#> attr(,"elimination")
#> [1] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE
ApiData("https://data.ssb.no/api/v0/en/table/11419", returnMetaFrames = TRUE) # list of data frames
#> $MaaleMetode
#>   values                          valueTexts
#> 1     02                             Average
#> 2     01                              Median
#> 3    051                      Lower quartile
#> 4    061                      Upper quartile
#> 5     10 Number of employments with earnings
#> 6     11     Number of full-time equivalents
#> 
#> $Yrke
#>    values                                         valueTexts
#> 1     0-9                                    All occupations
#> 2       1                                           Managers
#> 3    1120            Managing directors and chief executives
#> 4       2                                      Professionals
#> 5       3            Technicians and associate professionals
#> 6       4                           Clerical support workers
#> 7       5                          Service and sales workers
#> 8       6 Skilled agricultural, forestry and fishery workers
#> 9       7                   Craft and related trades workers
#> 10      8         Plant and machine operators and assemblers
#> 11      9                             Elementary occupations
#> 
#> $Sektor
#>    values                            valueTexts
#> 1    ALLE                       Sum all sectors
#> 2 A+B+D+E Private sector and public enterprises
#> 3    6500                      Local government
#> 4    6100                    Central government
#> 
#> $NACE2007
#>                  values
#> 1                 01-03
#> 2                  03.2
#> 3         05_07_08_09.9
#> 4                 05-09
#> 5               06+09.1
#> 6                 10-12
#> 7                 10-33
#> 8                 13-15
#> 9                    16
#> 10                   17
#> 11                   18
#> 12                19-21
#> 13                22-23
#> 14                   24
#> 15                   25
#> 16                26-27
#> 17                   28
#> 18                29-30
#> 19                31-32
#> 20                   33
#> 21                35-39
#> 22                   41
#> 23                41-43
#> 24                   42
#> 25                   43
#> 26                   45
#> 27                45-47
#> 28                   46
#> 29                   47
#> 30            49.1_49.3
#> 31            49.2_49.4
#> 32                49-53
#> 33                 50.1
#> 34                 50.2
#> 35                   51
#> 36                   52
#> 37                   53
#> 38                   55
#> 39                55-56
#> 40            56.1_56.3
#> 41                 56.2
#> 42                   58
#> 43                58-63
#> 44                   59
#> 45                   60
#> 46                   61
#> 47                   62
#> 48                   63
#> 49       64.1_65.1-65.3
#> 50  64.2-64.9_66.1-66.3
#> 51                64-66
#> 52                68-75
#> 53                 68.2
#> 54                68.31
#> 55                   69
#> 56                   70
#> 57                   71
#> 58                   72
#> 59                   73
#> 60                   77
#> 61                77-82
#> 62                   78
#> 63                   79
#> 64                   80
#> 65                   81
#> 66                 81.2
#> 67                   82
#> 68                   84
#> 69                84.11
#> 70                84.12
#> 71                84.13
#> 72                84.21
#> 73                84.22
#> 74                84.23
#> 75                84.24
#> 76                84.25
#> 77                84.30
#> 78                   85
#> 79            85.1-85.2
#> 80                 85.3
#> 81                 85.4
#> 82            85.5-85.6
#> 83                86-88
#> 84                   86
#> 85                 86.1
#> 86                   87
#> 87                 88.1
#> 88               88.911
#> 89                88.99
#> 90        88.993-88.994
#> 91                   90
#> 92                90-99
#> 93                   91
#> 94                   93
#> 95                 94.1
#> 96                 94.2
#> 97                 94.9
#> 98                   95
#> 99                   96
#> 100                  97
#> 101                  99
#> 102                00.0
#> 103                  00
#> 104                   A
#> 105                 A-S
#> 106                   B
#> 107                   C
#> 108                   D
#> 109                   E
#> 110                   F
#> 111                   G
#> 112                   H
#> 113                   I
#> 114                   J
#> 115                   K
#> 116                   L
#> 117                   M
#> 118                   N
#> 119                   O
#> 120                   P
#> 121                   Q
#> 122                   R
#> 123                   S
#> 124                   T
#> 125                   U
#>                                                                      valueTexts
#> 1                                             Agriculture, forestry and fishing
#> 2                                                                   Aquaculture
#> 3                                                                        Mining
#> 4                                                          Mining and quarrying
#> 5                               Oil and gas extraction incl. support activities
#> 6                           Manufacture of food products, beverages and tobacco
#> 7                                                                   Manufacture
#> 8                 Manufacture of textiles, wearing apparel and leather products
#> 9                                                        Wood and wood products
#> 10                                                     Paper and paper products
#> 11                                                    Printing and reproduction
#> 12                                          Refined petro., chemicals, pharmac.
#> 13                                            Rubber, plastic and mineral prod.
#> 14                                                                 Basic metals
#> 15                                                       Fabricated metal prod.
#> 16                                            Computer and electrical equipment
#> 17                                                      Machinery and equipment
#> 18                                                      Other workshop industry
#> 19                                           Furniture and manufacturing n.e.c.
#> 20                                            Repair, installation of machinery
#> 21                        Electricity, water supply, sewerage, waste management
#> 22                                                    Construction of buildings
#> 23                                                                 Construction
#> 24                                                            Civil engineering
#> 25                                          Specialised construction activities
#> 26      Wholesale and retail trade and repair of motor vehicles and motorcycles
#> 27         Wholesale and retail trade: repair of motor vehicles and motorcycles
#> 28                    Wholesale trade, except of motor vehicles and motorcycles
#> 29                       Retail trade, except of motor vehicles and motorcycles
#> 30                                                     Passenger land transport
#> 31                                                       Freight land transport
#> 32                                                   Transportation and storage
#> 33                                    Sea and coastal passenger water transport
#> 34                                      Sea and coastal freight water transport
#> 35                                                                Air transport
#> 36                                        Support activities for transportation
#> 37                                                Postal and courier activities
#> 38                                                                Accommodation
#> 39                                    Accommodation and food service activities
#> 40                                  Restaurants and beverage serving activities
#> 41                             Event catering and other food service activities
#> 42                                                        Publishing activities
#> 43                                                Information and communication
#> 44                                              Motion picture, TV, music prod.
#> 45                                         Programming, broadcasting activities
#> 46                                                           Telecommunications
#> 47                                            Computer programming, consultancy
#> 48                                               Information service activities
#> 49                                        Monetary and insurance intermediation
#> 50                                               Other financial intermediation
#> 51                                           Financial and insurance activities
#> 52               Real estate, professional, scientific and technical activities
#> 53                           Renting and operating of own or leased real estate
#> 54                                                         Real estate agencies
#> 55                                              Legal and accounting activities
#> 56                                            Head offices, management consult.
#> 57                                         Architecture, engineering activities
#> 58                                          Scientific research and development
#> 59                                              Advertising and market research
#> 60                                                Rental and leasing activities
#> 61                                Administrative and support service activities
#> 62                                                        Employment activities
#> 63                                                Travel agency, tour operators
#> 64                                           Security, investigation activities
#> 65                                      Buildings, landscape service activities
#> 66                                                          Cleaning activities
#> 67                                                  Business support activities
#> 68                                          Public adm., defence, soc. security
#> 69                                     General public administration activities
#> 70                                         Act. provid. health care, educ. etc.
#> 71     Regulation of and contribution to more efficient operation of businesses
#> 72                                                              Foreign affairs
#> 73                                                           Defence activities
#> 74                                              Justice and judicial activities
#> 75                                           Public order and safety activities
#> 76                                                      Fire service activities
#> 77                                        Compulsory social security activities
#> 78                                                                    Education
#> 79                                                            Primary education
#> 80                                                          Secondary education
#> 81                                                             Higher education
#> 82                           Other education and educational support activities
#> 83                                      Human health and social work activities
#> 84                                                      Human health activities
#> 85                                                          Hospital activities
#> 86                                                  Residential care activities
#> 87    Social work activities without accommodation for the elderly and disabled
#> 88                                                              Nursery schools
#> 89                    Other social work activities without accommodation n.e.c.
#> 90                                         Vocational rehabilitation activities
#> 91                                            Arts and entertainment activities
#> 92                                                     Other service activities
#> 93                                            Libraries, museums, other culture
#> 94                                                Sports, amusement, recreation
#> 95  Activities of business, employers and professional membership organisations
#> 96                                                   Activities of trade unions
#> 97                                 Activities of other membership organisations
#> 98                                            Repair, personal, household goods
#> 99                                            Other personal service activities
#> 100                                          Households as employers activities
#> 101                                   Extraterritorial organisations and bodies
#> 102                                                                 Unspecified
#> 103                                                                 Unspecified
#> 104                                           Agriculture, forestry and fishing
#> 105                                                              All industries
#> 106                                                        Mining and quarrying
#> 107                                                               Manufacturing
#> 108                                                  Electricity, gas and steam
#> 109                                               Water supply, sewerage, waste
#> 110                                                                Construction
#> 111        Wholesale and retail trade: repair of motor vehicles and motorcycles
#> 112                                                  Transportation and storage
#> 113                                   Accommodation and food service activities
#> 114                                               Information and communication
#> 115                                          Financial and insurance activities
#> 116                                                      Real estate activities
#> 117                           Professional, scientific and technical activities
#> 118                               Administrative and support service activities
#> 119                                           Public administration and defence
#> 120                                                                   Education
#> 121                                     Human health and social work activities
#> 122                                          Arts, entertainment and recreation
#> 123                                                    Other service activities
#> 124                                        Activities of household as employers
#> 125                     Activities of extraterritorial organisations and bodies
#> 
#> $Kjonn
#>   values valueTexts
#> 1      0 Both sexes
#> 2      2    Females
#> 3      1      Males
#> 
#> $AvtaltVanlig
#>   values          valueTexts
#> 1      0       All employees
#> 2      5 Full-time employees
#> 3      6 Part-time employees
#> 
#> $ContentsCode
#>             values                                 valueTexts
#> 1       Manedslonn                     Monthly earnings (NOK)
#> 2 AvtaltManedslonn                 Basic monthly salary (NOK)
#> 3          Uregtil       Variable additional allowances (NOK)
#> 4            Bonus                                Bonus (NOK)
#> 5          Overtid                         Overtime pay (NOK)
#> 6          AlderLA                                Age (years)
#> 7        AvtArbTid Contractual working hours per week (hours)
#> 
#> $Tid
#>    values valueTexts
#> 1    2015       2015
#> 2    2016       2016
#> 3    2017       2017
#> 4    2018       2018
#> 5    2019       2019
#> 6    2020       2020
#> 7    2021       2021
#> 8    2022       2022
#> 9    2023       2023
#> 10   2024       2024
#> 
#> attr(,"text")
#>                                MaaleMetode 
#>                         "measuring method" 
#>                                       Yrke 
#>                               "occupation" 
#>                                     Sektor 
#>                                   "sector" 
#>                                   NACE2007 
#>                       "industry (SIC2007)" 
#>                                      Kjonn 
#>                                   "gender" 
#>                               AvtaltVanlig 
#> "contractual/usual working hours per week" 
#>                               ContentsCode 
#>                                 "contents" 
#>                                        Tid 
#>                                     "year" 
#> attr(,"elimination")
#>  MaaleMetode         Yrke       Sektor     NACE2007        Kjonn AvtaltVanlig 
#>        FALSE         TRUE         TRUE         TRUE         TRUE         TRUE 
#> ContentsCode          Tid 
#>        FALSE        FALSE 
#> attr(,"time")
#>  MaaleMetode         Yrke       Sektor     NACE2007        Kjonn AvtaltVanlig 
#>        FALSE        FALSE        FALSE        FALSE        FALSE        FALSE 
#> ContentsCode          Tid 
#>        FALSE         TRUE 
ApiData("https://data.ssb.no/api/v0/en/table/11419", returnApiQuery = TRUE)   # query using defaults
#> {
#>   "query": [
#>     {
#>       "code": "MaaleMetode",
#>       "selection": {
#>         "filter": "item",
#>         "values": ["02", "10", "11"]
#>       }
#>     },
#>     {
#>       "code": "Yrke",
#>       "selection": {
#>         "filter": "item",
#>         "values": ["0-9", "8", "9"]
#>       }
#>     },
#>     {
#>       "code": "Sektor",
#>       "selection": {
#>         "filter": "item",
#>         "values": ["ALLE", "6500", "6100"]
#>       }
#>     },
#>     {
#>       "code": "NACE2007",
#>       "selection": {
#>         "filter": "item",
#>         "values": ["01-03", "T", "U"]
#>       }
#>     },
#>     {
#>       "code": "Kjonn",
#>       "selection": {
#>         "filter": "item",
#>         "values": ["0", "2", "1"]
#>       }
#>     },
#>     {
#>       "code": "AvtaltVanlig",
#>       "selection": {
#>         "filter": "item",
#>         "values": ["0", "5", "6"]
#>       }
#>     },
#>     {
#>       "code": "ContentsCode",
#>       "selection": {
#>         "filter": "item",
#>         "values": ["Manedslonn", "AlderLA", "AvtArbTid"]
#>       }
#>     },
#>     {
#>       "code": "Tid",
#>       "selection": {
#>         "filter": "item",
#>         "values": ["2015", "2023", "2024"]
#>       }
#>     }
#>   ],
#>   "response": {
#>     "format": "json-stat2"
#>   }
#> } 


##### Ordinary use     (makeNAstatus is in use in first two examples)

# NACE2007 as imaginary value (top 10), ContentsCode as TRUE (all), Tid is default
x <- ApiData("https://data.ssb.no/api/v0/en/table/11419", NACE2007 = 10i, ContentsCode = TRUE)

# Two specified and the last is default (as above) - in Norwegian change en to no in url
x <- ApiData("https://data.ssb.no/api/v0/no/table/11419", NACE2007 = 10i, ContentsCode = TRUE)

# Number of residents (bosatte) last year, each region
x <- ApiData("https://data.ssb.no/api/v0/en/table/04861", Region = TRUE, 
        ContentsCode = "Bosatte", Tid = 1i)

# Number of residents (bosatte) each year, total
ApiData("https://data.ssb.no/api/v0/en/table/04861", Region = FALSE, 
        ContentsCode = "Bosatte", Tid = TRUE)
#> $`04861: Area and population of urban settlements, by contents and year`
#>               contents year   value
#> 1  Number of residents 2000 3396382
#> 2  Number of residents 2002 3474623
#> 3  Number of residents 2003 3514417
#> 4  Number of residents 2004 3536454
#> 5  Number of residents 2005 3560137
#> 6  Number of residents 2006 3607813
#> 7  Number of residents 2007 3655391
#> 8  Number of residents 2008 3722786
#> 9  Number of residents 2009 3780068
#> 10 Number of residents 2011 3899115
#> 11 Number of residents 2012 3958038
#> 12 Number of residents 2013 4050626
#> 13 Number of residents 2014 4114414
#> 14 Number of residents 2015 4172782
#> 15 Number of residents 2016 4229827
#> 16 Number of residents 2017 4283166
#> 17 Number of residents 2018 4327937
#> 18 Number of residents 2019 4368614
#> 19 Number of residents 2020 4416981
#> 20 Number of residents 2021 4443243
#> 21 Number of residents 2022 4485236
#> 22 Number of residents 2023 4554562
#> 23 Number of residents 2024 4619969
#> 24 Number of residents 2025 4662945
#> 
#> $dataset
#>    ContentsCode  Tid   value
#> 1       Bosatte 2000 3396382
#> 2       Bosatte 2002 3474623
#> 3       Bosatte 2003 3514417
#> 4       Bosatte 2004 3536454
#> 5       Bosatte 2005 3560137
#> 6       Bosatte 2006 3607813
#> 7       Bosatte 2007 3655391
#> 8       Bosatte 2008 3722786
#> 9       Bosatte 2009 3780068
#> 10      Bosatte 2011 3899115
#> 11      Bosatte 2012 3958038
#> 12      Bosatte 2013 4050626
#> 13      Bosatte 2014 4114414
#> 14      Bosatte 2015 4172782
#> 15      Bosatte 2016 4229827
#> 16      Bosatte 2017 4283166
#> 17      Bosatte 2018 4327937
#> 18      Bosatte 2019 4368614
#> 19      Bosatte 2020 4416981
#> 20      Bosatte 2021 4443243
#> 21      Bosatte 2022 4485236
#> 22      Bosatte 2023 4554562
#> 23      Bosatte 2024 4619969
#> 24      Bosatte 2025 4662945
#> 

# Some years
ApiData("https://data.ssb.no/api/v0/en/table/04861", Region = FALSE, 
        ContentsCode = "Bosatte", Tid = c(1, 5, -1))
#> $`04861: Area and population of urban settlements, by contents and year`
#>              contents year   value
#> 1 Number of residents 2000 3396382
#> 2 Number of residents 2005 3560137
#> 3 Number of residents 2025 4662945
#> 
#> $dataset
#>   ContentsCode  Tid   value
#> 1      Bosatte 2000 3396382
#> 2      Bosatte 2005 3560137
#> 3      Bosatte 2025 4662945
#> 

# Two selected regions
ApiData("https://data.ssb.no/api/v0/en/table/04861", Region = c("1103", "0301"), 
        ContentsCode = 2, Tid = c(1, -1))
#> $`04861: Area and population of urban settlements, by region, contents and year`
#>          region            contents year  value
#> 1 Oslo - Oslove Number of residents 2000 504348
#> 2 Oslo - Oslove Number of residents 2025 720631
#> 3     Stavanger Number of residents 2000 106804
#> 4     Stavanger Number of residents 2025 143972
#> 
#> $dataset
#>   Region ContentsCode  Tid  value
#> 1   0301      Bosatte 2000 504348
#> 2   0301      Bosatte 2025 720631
#> 3   1103      Bosatte 2000 106804
#> 4   1103      Bosatte 2025 143972
#> 


##### Using id instead of url, unnamed input and verbosePrint
ApiData(4861, c("1103", "0301"), 1, c(1, -1)) # same as below 
#> $`04861: Areal og befolkning i tettsteder, etter region, statistikkvariabel og år`
#>          region      statistikkvariabel   år  value
#> 1 Oslo - Oslove Areal av tettsted (km²) 2000 132.90
#> 2 Oslo - Oslove Areal av tettsted (km²) 2025 129.90
#> 3     Stavanger Areal av tettsted (km²) 2000  41.85
#> 4     Stavanger Areal av tettsted (km²) 2025  44.35
#> 
#> $dataset
#>   Region ContentsCode  Tid  value
#> 1   0301        Areal 2000 132.90
#> 2   0301        Areal 2025 129.90
#> 3   1103        Areal 2000  41.85
#> 4   1103        Areal 2025  44.35
#> 
ApiData(4861, Region = c("1103", "0301"), ContentsCode=2, Tid=c(1, -1)) 
#> $`04861: Areal og befolkning i tettsteder, etter region, statistikkvariabel og år`
#>          region statistikkvariabel   år  value
#> 1 Oslo - Oslove            Bosatte 2000 504348
#> 2 Oslo - Oslove            Bosatte 2025 720631
#> 3     Stavanger            Bosatte 2000 106804
#> 4     Stavanger            Bosatte 2025 143972
#> 
#> $dataset
#>   Region ContentsCode  Tid  value
#> 1   0301      Bosatte 2000 504348
#> 2   0301      Bosatte 2025 720631
#> 3   1103      Bosatte 2000 106804
#> 4   1103      Bosatte 2025 143972
#> 
names(ApiData(4861,returnMetaFrames = TRUE))  # these names from metadata assumed two lines above
#> [1] "Region"       "ContentsCode" "Tid"         
ApiData("4861", c("1103", "0301"), 1, c(1, -1),  urlType="SSBen")
#> $`04861: Area and population of urban settlements, by region, contents and year`
#>          region                        contents year  value
#> 1 Oslo - Oslove Area of urban settlements (km²) 2000 132.90
#> 2 Oslo - Oslove Area of urban settlements (km²) 2025 129.90
#> 3     Stavanger Area of urban settlements (km²) 2000  41.85
#> 4     Stavanger Area of urban settlements (km²) 2025  44.35
#> 
#> $dataset
#>   Region ContentsCode  Tid  value
#> 1   0301        Areal 2000 132.90
#> 2   0301        Areal 2025 129.90
#> 3   1103        Areal 2000  41.85
#> 4   1103        Areal 2025  44.35
#> 
ApiData("01222", c("1103", "0301"), c(4, 9:11), 2i, verbosePrint = TRUE)
#> $Region
#>   [1] "0"     "31"    "3101"  "3103"  "3105"  "3107"  "3110"  "3112"  "3114" 
#>  [10] "3116"  "3118"  "3120"  "3122"  "3124"  "32"    "3201"  "3203"  "3205" 
#>  [19] "3207"  "3209"  "3212"  "3214"  "3216"  "3218"  "3220"  "3222"  "3224" 
#>  [28] "3226"  "3228"  "3230"  "3232"  "3234"  "3236"  "3238"  "3240"  "3242" 
#>  [37] "30"    "01"    "3001"  "3002"  "3003"  "3004"  "3005"  "3006"  "3007" 
#>  [46] "3011"  "3012"  "3013"  "3014"  "3015"  "3016"  "3017"  "3018"  "3019" 
#>  [55] "3020"  "3021"  "3022"  "3023"  "3024"  "3025"  "3026"  "3027"  "3028" 
#>  [64] "3029"  "3030"  "3031"  "3032"  "3033"  "3034"  "3035"  "3036"  "3037" 
#>  [73] "3038"  "3039"  "3040"  "3041"  "3042"  "3043"  "3044"  "3045"  "3046" 
#>  [82] "3047"  "3048"  "3049"  "3050"  "3051"  "3052"  "3053"  "3054"  "0101" 
#>  [91] "0102"  "0103"  "0104"  "0105"  "0106"  "0111"  "0113"  "0114"  "0115" 
#> [100] "0116"  "0117"  "0118"  "0119"  "0121"  "0122"  "0123"  "0124"  "0125" 
#> [109] "0127"  "0128"  "0130"  "0131"  "0133"  "0134"  "0135"  "0136"  "0137" 
#> [118] "0138"  "0199"  "02"    "0211"  "0213"  "0214"  "0215"  "0216"  "0217" 
#> [127] "0219"  "0220"  "0221"  "0226"  "0227"  "0228"  "0229"  "0230"  "0231" 
#> [136] "0233"  "0234"  "0235"  "0236"  "0237"  "0238"  "0239"  "0299"  "03"   
#> [145] "0301"  "33"    "0399"  "3301"  "3303"  "3305"  "3310"  "3312"  "3314" 
#> [154] "3316"  "3318"  "3320"  "3322"  "3324"  "3326"  "3328"  "3330"  "3332" 
#> [163] "3334"  "3336"  "3338"  "34"    "04"    "3401"  "3403"  "3405"  "3407" 
#> [172] "3411"  "3412"  "3413"  "3414"  "3415"  "3416"  "3417"  "3418"  "3419" 
#> [181] "3420"  "3421"  "3422"  "3423"  "3424"  "3425"  "3426"  "3427"  "3428" 
#> [190] "3429"  "3430"  "3431"  "3432"  "3433"  "3434"  "3435"  "3436"  "3437" 
#> [199] "3438"  "3439"  "3440"  "3441"  "3442"  "3443"  "3446"  "3447"  "3448" 
#> [208] "3449"  "3450"  "3451"  "3452"  "3453"  "3454"  "0401"  "0402"  "0403" 
#> [217] "0412"  "0414"  "0415"  "0417"  "0418"  "0419"  "0420"  "0423"  "0425" 
#> [226] "0426"  "0427"  "0428"  "0429"  "0430"  "0432"  "0434"  "0435"  "0436" 
#> [235] "0437"  "0438"  "0439"  "0441"  "0499"  "05"    "0501"  "0502"  "0511" 
#> [244] "0512"  "0513"  "0514"  "0515"  "0516"  "0517"  "0518"  "0519"  "0520" 
#> [253] "0521"  "0522"  "0528"  "0529"  "0532"  "0533"  "0534"  "0536"  "0538" 
#> [262] "0540"  "0541"  "0542"  "0543"  "0544"  "0545"  "0599"  "06"    "38"   
#> [271] "3801"  "3802"  "3803"  "3804"  "3805"  "3806"  "3807"  "3808"  "3811" 
#> [280] "3812"  "3813"  "3814"  "3815"  "3816"  "3817"  "3818"  "3819"  "3820" 
#> [289] "3821"  "3822"  "3823"  "3824"  "3825"  "0601"  "0602"  "0604"  "0605" 
#> [298] "0612"  "0615"  "0616"  "0617"  "0618"  "0619"  "0620"  "0621"  "0622" 
#> [307] "0623"  "0624"  "0625"  "0626"  "0627"  "0628"  "0631"  "0632"  "0633" 
#> [316] "39"    "0699"  "3901"  "3903"  "3905"  "3907"  "3909"  "3911"  "40"   
#> [325] "4001"  "4003"  "4005"  "4010"  "4012"  "4014"  "4016"  "4018"  "4020" 
#> [334] "4022"  "4024"  "4026"  "4028"  "4030"  "4032"  "4034"  "4036"  "07"   
#> [343] "0701"  "0702"  "0703"  "0704"  "0705"  "0706"  "0707"  "0708"  "0709" 
#> [352] "0710"  "0711"  "0712"  "0713"  "0714"  "0715"  "0716"  "0716u" "0717" 
#> [361] "0718"  "0719"  "0720"  "0721"  "0722"  "0723"  "0724"  "0725"  "0726" 
#> [370] "0727"  "0728"  "0729"  "0799"  "08"    "0805"  "0806"  "0807"  "0811" 
#> [379] "0814"  "0815"  "0817"  "0819"  "0821"  "0822"  "0826"  "0827"  "0828" 
#> [388] "0829"  "0830"  "0831"  "0833"  "0834"  "0899"  "42"    "09"    "4201" 
#> [397] "4202"  "4203"  "4204"  "4205"  "4206"  "4207"  "4211"  "4212"  "4213" 
#> [406] "4214"  "4215"  "4216"  "4217"  "4218"  "4219"  "4220"  "4221"  "4222" 
#> [415] "4223"  "4224"  "4225"  "4226"  "4227"  "4228"  "0901"  "0903"  "0904" 
#> [424] "0906"  "0911"  "0912"  "0914"  "0918"  "0919"  "0920"  "0921"  "0922" 
#> [433] "0923"  "0924"  "0926"  "0928"  "0929"  "0932"  "0933"  "0935"  "0937" 
#> [442] "0938"  "0940"  "0941"  "0999"  "10"    "1001"  "1002"  "1003"  "1004" 
#> [451] "1014"  "1017"  "1018"  "1021"  "1026"  "1027"  "1029"  "1032"  "1034" 
#> [460] "1037"  "1046"  "1099"  "11"    "1101"  "1102"  "1103"  "1106"  "1108" 
#> [469] "1111"  "1112"  "1114"  "1119"  "1120"  "1121"  "1122"  "1124"  "1127" 
#> [478] "1129"  "1130"  "1133"  "1134"  "1135"  "1141"  "1142"  "1144"  "1145" 
#> [487] "1146"  "1149"  "1151"  "1154"  "1159"  "1160"  "1199"  "46"    "12"   
#> [496] "4601"  "4602"  "4611"  "4612"  "4613"  "4614"  "4615"  "4616"  "4617" 
#> [505] "4618"  "4619"  "4620"  "4621"  "4622"  "4623"  "4624"  "4625"  "4626" 
#> [514] "4627"  "4628"  "4629"  "4630"  "4631"  "4632"  "4633"  "4634"  "4635" 
#> [523] "4636"  "4637"  "4638"  "4639"  "4640"  "4641"  "4642"  "4643"  "4644" 
#> [532] "4645"  "4646"  "4647"  "4648"  "4649"  "4650"  "4651"  "1201"  "1211" 
#> [541] "1214"  "1216"  "1219"  "1221"  "1222"  "1223"  "1224"  "1227"  "1228" 
#> [550] "1230"  "1231"  "1232"  "1233"  "1234"  "1235"  "1238"  "1241"  "1242" 
#> [559] "1243"  "1244"  "1245"  "1246"  "1247"  "1248"  "1249"  "1250"  "1251" 
#> [568] "1252"  "1253"  "1255"  "1256"  "1259"  "1260"  "1263"  "1264"  "1265" 
#> [577] "1266"  "1299"  "13"    "1301"  "14"    "1401"  "1411"  "1412"  "1413" 
#> [586] "1416"  "1417"  "1418"  "1419"  "1420"  "1421"  "1422"  "1424"  "1426" 
#> [595] "1428"  "1429"  "1430"  "1431"  "1432"  "1433"  "1438"  "1439"  "1441" 
#> [604] "1443"  "1444"  "1445"  "1448"  "1449"  "1499"  "15"    "1501"  "1502" 
#> [613] "1503"  "1504"  "1505"  "1506"  "1507"  "1508"  "1511"  "1514"  "1515" 
#> [622] "1516"  "1517"  "1519"  "1520"  "1523"  "1524"  "1525"  "1526"  "1527" 
#> [631] "1528"  "1529"  "1531"  "1532"  "1534"  "1535"  "1539"  "1543"  "1545" 
#> [640] "1546"  "1547"  "1548"  "1551"  "1554"  "1556"  "1557"  "1560"  "1563" 
#> [649] "1566"  "1567"  "1569"  "1571"  "1572"  "1573"  "1576"  "1577"  "1578" 
#> [658] "1579"  "1580"  "1599"  "50"    "16"    "5001"  "5004"  "5005"  "5006" 
#> [667] "5007"  "5011"  "5012"  "5013"  "5014"  "5015"  "5016"  "5017"  "5018" 
#> [676] "5019"  "5020"  "5021"  "5022"  "5023"  "5024"  "5025"  "5026"  "5027" 
#> [685] "5028"  "5029"  "5030"  "5031"  "5032"  "5033"  "5034"  "5035"  "5036" 
#> [694] "5037"  "5038"  "5039"  "5040"  "5041"  "5042"  "5043"  "5044"  "5045" 
#> [703] "5046"  "5047"  "5048"  "5049"  "5050"  "5051"  "5052"  "5053"  "5054" 
#> [712] "5055"  "5056"  "5057"  "5058"  "5059"  "5060"  "5061"  "1601"  "1612" 
#> [721] "1613"  "1617"  "1620"  "1621"  "1622"  "1624"  "1627"  "1630"  "1632" 
#> [730] "1633"  "1634"  "1635"  "1636"  "1638"  "1640"  "1644"  "1645"  "1648" 
#> [739] "1653"  "1657"  "1662"  "1663"  "1664"  "1665"  "1699"  "17"    "1702" 
#> [748] "1703"  "1711"  "1714"  "1717"  "1718"  "1719"  "1721"  "1723"  "1724" 
#> [757] "1725"  "1729"  "1736"  "1738"  "1739"  "1740"  "1742"  "1743"  "1744" 
#> [766] "1748"  "1749"  "1750"  "1751"  "1755"  "1756"  "1799"  "18"    "1804" 
#> [775] "1805"  "1806"  "1811"  "1812"  "1813"  "1814"  "1815"  "1816"  "1818" 
#> [784] "1820"  "1822"  "1824"  "1825"  "1826"  "1827"  "1828"  "1832"  "1833" 
#> [793] "1834"  "1835"  "1836"  "1837"  "1838"  "1839"  "1840"  "1841"  "1842" 
#> [802] "1843"  "1845"  "1848"  "1849"  "1850"  "1851"  "1852"  "1853"  "1854" 
#> [811] "1855"  "1856"  "1857"  "1858"  "1859"  "1860"  "1865"  "1866"  "1867" 
#> [820] "1868"  "1870"  "1871"  "1874"  "1875"  "55"    "56"    "1899"  "5501" 
#> [829] "5503"  "5510"  "5512"  "5514"  "5516"  "5518"  "5520"  "5522"  "5524" 
#> [838] "5526"  "5528"  "5530"  "5532"  "5534"  "5536"  "5538"  "5540"  "5542" 
#> [847] "5544"  "5546"  "5601"  "5603"  "5605"  "5607"  "5610"  "5612"  "5614" 
#> [856] "5616"  "5618"  "5620"  "5622"  "5624"  "5626"  "5628"  "5630"  "5632" 
#> [865] "5634"  "5636"  "54"    "19"    "5401"  "5402"  "5403"  "5404"  "5405" 
#> [874] "5406"  "5411"  "5412"  "5413"  "5414"  "5415"  "5416"  "5417"  "5418" 
#> [883] "5419"  "5420"  "5421"  "5422"  "5423"  "5424"  "5425"  "5426"  "5427" 
#> [892] "5428"  "5429"  "5430"  "5432"  "5433"  "5434"  "5435"  "5436"  "5437" 
#> [901] "5438"  "5439"  "5440"  "5441"  "5442"  "5443"  "5444"  "1901"  "1902" 
#> [910] "1903"  "1911"  "1913"  "1915"  "1917"  "1919"  "1920"  "1921"  "1922" 
#> [919] "1923"  "1924"  "1925"  "1926"  "1927"  "1928"  "1929"  "1931"  "1933" 
#> [928] "1936"  "1938"  "1939"  "1940"  "1941"  "1942"  "1943"  "1999"  "20"   
#> [937] "2001"  "2002"  "2003"  "2004"  "2011"  "2012"  "2014"  "2015"  "2016" 
#> [946] "2017"  "2018"  "2019"  "2020"  "2021"  "2022"  "2023"  "2024"  "2025" 
#> [955] "2027"  "2028"  "2030"  "2099"  "21"    "2101"  "2102"  "2103"  "2104" 
#> [964] "2105"  "2106"  "2107"  "2108"  "2109"  "2110"  "2111"  "2112"  "2113" 
#> [973] "2114"  "2115"  "2116"  "2117"  "2118"  "2119"  "2121"  "2131"  "2199" 
#> [982] "22"    "2211"  "2299"  "23"    "2300"  "2311"  "2321"  "2399"  "25"   
#> [991] "26"    "88"    "99"    "9999" 
#> 
#> $ContentsCode
#>  [1] "Folketallet1"      "Folketallet11"     "Fodte2"           
#>  [4] "Dode3"             "Fodselsoverskudd4" "Innvandring5"     
#>  [7] "Utvandring6"       "Tilflytting7"      "Fraflytting8"     
#> [10] "Nettoinnflytting9" "Folketilvekst10"  
#> 
#> $Tid
#>   [1] "1997K4" "1998K1" "1998K2" "1998K3" "1998K4" "1999K1" "1999K2" "1999K3"
#>   [9] "1999K4" "2000K1" "2000K2" "2000K3" "2000K4" "2001K1" "2001K2" "2001K3"
#>  [17] "2001K4" "2002K1" "2002K2" "2002K3" "2002K4" "2003K1" "2003K2" "2003K3"
#>  [25] "2003K4" "2004K1" "2004K2" "2004K3" "2004K4" "2005K1" "2005K2" "2005K3"
#>  [33] "2005K4" "2006K1" "2006K2" "2006K3" "2006K4" "2007K1" "2007K2" "2007K3"
#>  [41] "2007K4" "2008K1" "2008K2" "2008K3" "2008K4" "2009K1" "2009K2" "2009K3"
#>  [49] "2009K4" "2010K1" "2010K2" "2010K3" "2010K4" "2011K1" "2011K2" "2011K3"
#>  [57] "2011K4" "2012K1" "2012K2" "2012K3" "2012K4" "2013K1" "2013K2" "2013K3"
#>  [65] "2013K4" "2014K1" "2014K2" "2014K3" "2014K4" "2015K1" "2015K2" "2015K3"
#>  [73] "2015K4" "2016K1" "2016K2" "2016K3" "2016K4" "2017K1" "2017K2" "2017K3"
#>  [81] "2017K4" "2018K1" "2018K2" "2018K3" "2018K4" "2019K1" "2019K2" "2019K3"
#>  [89] "2019K4" "2020K1" "2020K2" "2020K3" "2020K4" "2021K1" "2021K2" "2021K3"
#>  [97] "2021K4" "2022K1" "2022K2" "2022K3" "2022K4" "2023K1" "2023K2" "2023K3"
#> [105] "2023K4" "2024K1" "2024K2" "2024K3" "2024K4" "2025K1" "2025K2" "2025K3"
#> 
#> attr(,"elimination")
#> [1]  TRUE FALSE FALSE
#> 
#> 
#> 
#> $`01222: Befolkning og kvartalsvise endringar, etter region, statistikkvariabel og kvartal`
#>           region                         statistikkvariabel kvartal value
#> 1  Oslo - Oslove                                       Døde  2025K2   913
#> 2  Oslo - Oslove                                       Døde  2025K3   978
#> 3  Oslo - Oslove                     Utflytting, innalandsk  2025K2  8469
#> 4  Oslo - Oslove                     Utflytting, innalandsk  2025K3 12567
#> 5  Oslo - Oslove Nettoinnflytting, inkl. inn- og utvandring  2025K2 -1611
#> 6  Oslo - Oslove Nettoinnflytting, inkl. inn- og utvandring  2025K3   930
#> 7  Oslo - Oslove                                 Folkevekst  2025K2   -63
#> 8  Oslo - Oslove                                 Folkevekst  2025K3  2617
#> 9      Stavanger                                       Døde  2025K2   210
#> 10     Stavanger                                       Døde  2025K3   224
#> 11     Stavanger                     Utflytting, innalandsk  2025K2  1582
#> 12     Stavanger                     Utflytting, innalandsk  2025K3  2266
#> 13     Stavanger Nettoinnflytting, inkl. inn- og utvandring  2025K2   -45
#> 14     Stavanger Nettoinnflytting, inkl. inn- og utvandring  2025K3   413
#> 15     Stavanger                                 Folkevekst  2025K2   175
#> 16     Stavanger                                 Folkevekst  2025K3   611
#> 
#> $dataset
#>    Region      ContentsCode    Tid value
#> 1    0301             Dode3 2025K2   913
#> 2    0301             Dode3 2025K3   978
#> 3    0301      Fraflytting8 2025K2  8469
#> 4    0301      Fraflytting8 2025K3 12567
#> 5    0301 Nettoinnflytting9 2025K2 -1611
#> 6    0301 Nettoinnflytting9 2025K3   930
#> 7    0301   Folketilvekst10 2025K2   -63
#> 8    0301   Folketilvekst10 2025K3  2617
#> 9    1103             Dode3 2025K2   210
#> 10   1103             Dode3 2025K3   224
#> 11   1103      Fraflytting8 2025K2  1582
#> 12   1103      Fraflytting8 2025K3  2266
#> 13   1103 Nettoinnflytting9 2025K2   -45
#> 14   1103 Nettoinnflytting9 2025K3   413
#> 15   1103   Folketilvekst10 2025K2   175
#> 16   1103   Folketilvekst10 2025K3   611
#> 

# }
##### Advanced use using list. See details above. Try returnApiQuery=TRUE on the same examples. 
ApiData(4861, Region = list("03*"), ContentsCode = 1, Tid = 5i) # "all" can be dropped from the list
#> $`04861: Areal og befolkning i tettsteder, etter region, statistikkvariabel og år`
#>                 region      statistikkvariabel   år  value
#> 1        Oslo - Oslove Areal av tettsted (km²) 2021 130.47
#> 2        Oslo - Oslove Areal av tettsted (km²) 2022 130.57
#> 3        Oslo - Oslove Areal av tettsted (km²) 2023 130.46
#> 4        Oslo - Oslove Areal av tettsted (km²) 2024 130.31
#> 5        Oslo - Oslove Areal av tettsted (km²) 2025 129.90
#> 6  Uoppgitt komm. Oslo Areal av tettsted (km²) 2021   0.00
#> 7  Uoppgitt komm. Oslo Areal av tettsted (km²) 2022   0.00
#> 8  Uoppgitt komm. Oslo Areal av tettsted (km²) 2023   0.00
#> 9  Uoppgitt komm. Oslo Areal av tettsted (km²) 2024   0.00
#> 10 Uoppgitt komm. Oslo Areal av tettsted (km²) 2025   0.00
#> 
#> $dataset
#>    Region ContentsCode  Tid  value
#> 1    0301        Areal 2021 130.47
#> 2    0301        Areal 2022 130.57
#> 3    0301        Areal 2023 130.46
#> 4    0301        Areal 2024 130.31
#> 5    0301        Areal 2025 129.90
#> 6    0399        Areal 2021   0.00
#> 7    0399        Areal 2022   0.00
#> 8    0399        Areal 2023   0.00
#> 9    0399        Areal 2024   0.00
#> 10   0399        Areal 2025   0.00
#> 
ApiData(4861, Region = list("all", "03*"), ContentsCode = 1, Tid = 5i)  # same as above
#> $`04861: Areal og befolkning i tettsteder, etter region, statistikkvariabel og år`
#>                 region      statistikkvariabel   år  value
#> 1        Oslo - Oslove Areal av tettsted (km²) 2021 130.47
#> 2        Oslo - Oslove Areal av tettsted (km²) 2022 130.57
#> 3        Oslo - Oslove Areal av tettsted (km²) 2023 130.46
#> 4        Oslo - Oslove Areal av tettsted (km²) 2024 130.31
#> 5        Oslo - Oslove Areal av tettsted (km²) 2025 129.90
#> 6  Uoppgitt komm. Oslo Areal av tettsted (km²) 2021   0.00
#> 7  Uoppgitt komm. Oslo Areal av tettsted (km²) 2022   0.00
#> 8  Uoppgitt komm. Oslo Areal av tettsted (km²) 2023   0.00
#> 9  Uoppgitt komm. Oslo Areal av tettsted (km²) 2024   0.00
#> 10 Uoppgitt komm. Oslo Areal av tettsted (km²) 2025   0.00
#> 
#> $dataset
#>    Region ContentsCode  Tid  value
#> 1    0301        Areal 2021 130.47
#> 2    0301        Areal 2022 130.57
#> 3    0301        Areal 2023 130.46
#> 4    0301        Areal 2024 130.31
#> 5    0301        Areal 2025 129.90
#> 6    0399        Areal 2021   0.00
#> 7    0399        Areal 2022   0.00
#> 8    0399        Areal 2023   0.00
#> 9    0399        Areal 2024   0.00
#> 10   0399        Areal 2025   0.00
#> 
ApiData(04861, Region = list("item", c("1103", "0301")), ContentsCode = 1, Tid = 5i)
#> $`04861: Areal og befolkning i tettsteder, etter region, statistikkvariabel og år`
#>           region      statistikkvariabel   år  value
#> 1  Oslo - Oslove Areal av tettsted (km²) 2021 130.47
#> 2  Oslo - Oslove Areal av tettsted (km²) 2022 130.57
#> 3  Oslo - Oslove Areal av tettsted (km²) 2023 130.46
#> 4  Oslo - Oslove Areal av tettsted (km²) 2024 130.31
#> 5  Oslo - Oslove Areal av tettsted (km²) 2025 129.90
#> 6      Stavanger Areal av tettsted (km²) 2021  44.22
#> 7      Stavanger Areal av tettsted (km²) 2022  44.45
#> 8      Stavanger Areal av tettsted (km²) 2023  44.21
#> 9      Stavanger Areal av tettsted (km²) 2024  44.34
#> 10     Stavanger Areal av tettsted (km²) 2025  44.35
#> 
#> $dataset
#>    Region ContentsCode  Tid  value
#> 1    0301        Areal 2021 130.47
#> 2    0301        Areal 2022 130.57
#> 3    0301        Areal 2023 130.46
#> 4    0301        Areal 2024 130.31
#> 5    0301        Areal 2025 129.90
#> 6    1103        Areal 2021  44.22
#> 7    1103        Areal 2022  44.45
#> 8    1103        Areal 2023  44.21
#> 9    1103        Areal 2024  44.34
#> 10   1103        Areal 2025  44.35
#> 


##### Using data from SCB to illustrate returnMetaFrames
urlSCB <- "https://api.scb.se/OV0104/v1/doris/sv/ssd/BE/BE0101/BE0101A/BefolkningNy"
mf <- ApiData(urlSCB, returnMetaFrames = TRUE)
names(mf)              # All the variable names
#> [1] "Region"       "Civilstand"   "Alder"        "Kon"          "ContentsCode"
#> [6] "Tid"         
attr(mf, "text")       # Corresponding text information as attribute
#>           Region       Civilstand            Alder              Kon 
#>         "region"     "civilstånd"          "ålder"            "kön" 
#>     ContentsCode              Tid 
#> "tabellinnehåll"             "år" 
mf$ContentsCode        # Data frame for the fifth variable (alternatively  mf[[5]])
#>     values valueTexts
#> 1 BE0101N1  Folkmängd
#> 2 BE0101N2 Folkökning
attr(mf,"elimination") # Finding variables that can be eliminated
#>       Region   Civilstand        Alder          Kon ContentsCode          Tid 
#>         TRUE         TRUE         TRUE         TRUE        FALSE        FALSE 
ApiData(urlSCB,        # Eliminating all variables that can be eliminated (line below)
        Region = FALSE, Civilstand = FALSE, Alder = FALSE,  Kon = FALSE,
        ContentsCode  = "BE0101N1", # Selecting a single ContentsCode by text input
        Tid = TRUE)                 # Choosing all possible values of Tid.
#> $`Folkmängd efter tabellinnehåll och år`
#>    tabellinnehåll   år    value
#> 1       Folkmängd 1968  7931193
#> 2       Folkmängd 1969  8004270
#> 3       Folkmängd 1970  8081142
#> 4       Folkmängd 1971  8115165
#> 5       Folkmängd 1972  8129129
#> 6       Folkmängd 1973  8144428
#> 7       Folkmängd 1974  8176691
#> 8       Folkmängd 1975  8208442
#> 9       Folkmängd 1976  8236179
#> 10      Folkmängd 1977  8267116
#> 11      Folkmängd 1978  8284437
#> 12      Folkmängd 1979  8303010
#> 13      Folkmängd 1980  8317937
#> 14      Folkmängd 1981  8323033
#> 15      Folkmängd 1982  8327484
#> 16      Folkmängd 1983  8330573
#> 17      Folkmängd 1984  8342621
#> 18      Folkmängd 1985  8358139
#> 19      Folkmängd 1986  8381515
#> 20      Folkmängd 1987  8414083
#> 21      Folkmängd 1988  8458888
#> 22      Folkmängd 1989  8527036
#> 23      Folkmängd 1990  8590630
#> 24      Folkmängd 1991  8644119
#> 25      Folkmängd 1992  8692013
#> 26      Folkmängd 1993  8745109
#> 27      Folkmängd 1994  8816381
#> 28      Folkmängd 1995  8837496
#> 29      Folkmängd 1996  8844499
#> 30      Folkmängd 1997  8847625
#> 31      Folkmängd 1998  8854322
#> 32      Folkmängd 1999  8861426
#> 33      Folkmängd 2000  8882792
#> 34      Folkmängd 2001  8909128
#> 35      Folkmängd 2002  8940788
#> 36      Folkmängd 2003  8975670
#> 37      Folkmängd 2004  9011392
#> 38      Folkmängd 2005  9047752
#> 39      Folkmängd 2006  9113257
#> 40      Folkmängd 2007  9182927
#> 41      Folkmängd 2008  9256347
#> 42      Folkmängd 2009  9340682
#> 43      Folkmängd 2010  9415570
#> 44      Folkmängd 2011  9482855
#> 45      Folkmängd 2012  9555893
#> 46      Folkmängd 2013  9644864
#> 47      Folkmängd 2014  9747355
#> 48      Folkmängd 2015  9851017
#> 49      Folkmängd 2016  9995153
#> 50      Folkmängd 2017 10120242
#> 51      Folkmängd 2018 10230185
#> 52      Folkmängd 2019 10327589
#> 53      Folkmängd 2020 10379295
#> 54      Folkmängd 2021 10452326
#> 55      Folkmängd 2022 10521556
#> 56      Folkmängd 2023 10551707
#> 57      Folkmängd 2024 10587710
#> 
#> $dataset
#>    ContentsCode  Tid    value
#> 1      BE0101N1 1968  7931193
#> 2      BE0101N1 1969  8004270
#> 3      BE0101N1 1970  8081142
#> 4      BE0101N1 1971  8115165
#> 5      BE0101N1 1972  8129129
#> 6      BE0101N1 1973  8144428
#> 7      BE0101N1 1974  8176691
#> 8      BE0101N1 1975  8208442
#> 9      BE0101N1 1976  8236179
#> 10     BE0101N1 1977  8267116
#> 11     BE0101N1 1978  8284437
#> 12     BE0101N1 1979  8303010
#> 13     BE0101N1 1980  8317937
#> 14     BE0101N1 1981  8323033
#> 15     BE0101N1 1982  8327484
#> 16     BE0101N1 1983  8330573
#> 17     BE0101N1 1984  8342621
#> 18     BE0101N1 1985  8358139
#> 19     BE0101N1 1986  8381515
#> 20     BE0101N1 1987  8414083
#> 21     BE0101N1 1988  8458888
#> 22     BE0101N1 1989  8527036
#> 23     BE0101N1 1990  8590630
#> 24     BE0101N1 1991  8644119
#> 25     BE0101N1 1992  8692013
#> 26     BE0101N1 1993  8745109
#> 27     BE0101N1 1994  8816381
#> 28     BE0101N1 1995  8837496
#> 29     BE0101N1 1996  8844499
#> 30     BE0101N1 1997  8847625
#> 31     BE0101N1 1998  8854322
#> 32     BE0101N1 1999  8861426
#> 33     BE0101N1 2000  8882792
#> 34     BE0101N1 2001  8909128
#> 35     BE0101N1 2002  8940788
#> 36     BE0101N1 2003  8975670
#> 37     BE0101N1 2004  9011392
#> 38     BE0101N1 2005  9047752
#> 39     BE0101N1 2006  9113257
#> 40     BE0101N1 2007  9182927
#> 41     BE0101N1 2008  9256347
#> 42     BE0101N1 2009  9340682
#> 43     BE0101N1 2010  9415570
#> 44     BE0101N1 2011  9482855
#> 45     BE0101N1 2012  9555893
#> 46     BE0101N1 2013  9644864
#> 47     BE0101N1 2014  9747355
#> 48     BE0101N1 2015  9851017
#> 49     BE0101N1 2016  9995153
#> 50     BE0101N1 2017 10120242
#> 51     BE0101N1 2018 10230185
#> 52     BE0101N1 2019 10327589
#> 53     BE0101N1 2020 10379295
#> 54     BE0101N1 2021 10452326
#> 55     BE0101N1 2022 10521556
#> 56     BE0101N1 2023 10551707
#> 57     BE0101N1 2024 10587710
#> 
 
               
##### Using data from Statfi to illustrate use of input by variable labels (valueTexts)
urlStatfi <- "https://pxdata.stat.fi/PXWeb/api/v1/en/StatFin/kuol/statfin_kuol_pxt_12au.px"
ApiData(urlStatfi, returnMetaFrames = TRUE)$Tiedot
#>          values                                   valueTexts
#> 1          vm01                                  Live births
#> 2          vm11                                       Deaths
#> 3  luonvalisays                             Natural increase
#> 4     vm43_tulo                  Intermunicipal in-migration
#> 5    vm43_lahto                 Intermunicipal out-migration
#> 6    vm43_netto                 Intermunicipal net migration
#> 7          vm44                     Intramunicipal migration
#> 8          vm41                       Immigration to Finland
#> 9   vm41_nordic Immigration to Finland from Nordic countries
#> 10      vm41_eu     Immigration to Finland from EU countries
#> 11         vm42                      Emigration from Finland
#> 12  vm42_nordic  Emigration from Finland to Nordic countries
#> 13      vm42_eu      Emigration from Finland to EU countries
#> 14       vm4142                                Net migration
#> 15 koknetmuutto                          Total net migration
#> 16       vm2126                                    Marriages
#> 17       vm3136                                     Divorces
#> 18     valisays                          Population increase
#> 19    vakorjaus                        Population correction
#> 20    kokmuutos                                 Total change
#> 21       vaesto                                   Population
ApiData(urlStatfi, Alue = FALSE, Vuosi = TRUE, Tiedot = "Population")  # same as Tiedot = 21
#> $`Vital statistics by Year and Information`
#>    Year Information   value
#> 1  1990  Population 4998478
#> 2  1991  Population 5029002
#> 3  1992  Population 5054982
#> 4  1993  Population 5077912
#> 5  1994  Population 5098754
#> 6  1995  Population 5116826
#> 7  1996  Population 5132320
#> 8  1997  Population 5147349
#> 9  1998  Population 5159646
#> 10 1999  Population 5171302
#> 11 2000  Population 5181115
#> 12 2001  Population 5194901
#> 13 2002  Population 5206295
#> 14 2003  Population 5219732
#> 15 2004  Population 5236611
#> 16 2005  Population 5255580
#> 17 2006  Population 5276955
#> 18 2007  Population 5300484
#> 19 2008  Population 5326314
#> 20 2009  Population 5351427
#> 21 2010  Population 5375276
#> 22 2011  Population 5401267
#> 23 2012  Population 5426674
#> 24 2013  Population 5451270
#> 25 2014  Population 5471753
#> 26 2015  Population 5487308
#> 27 2016  Population 5503297
#> 28 2017  Population 5513130
#> 29 2018  Population 5517919
#> 30 2019  Population 5525292
#> 31 2020  Population 5533793
#> 32 2021  Population 5548241
#> 33 2022  Population 5563970
#> 34 2023  Population 5603851
#> 35 2024  Population 5635971
#> 
#> $dataset
#>    Vuosi Tiedot   value
#> 1   1990 vaesto 4998478
#> 2   1991 vaesto 5029002
#> 3   1992 vaesto 5054982
#> 4   1993 vaesto 5077912
#> 5   1994 vaesto 5098754
#> 6   1995 vaesto 5116826
#> 7   1996 vaesto 5132320
#> 8   1997 vaesto 5147349
#> 9   1998 vaesto 5159646
#> 10  1999 vaesto 5171302
#> 11  2000 vaesto 5181115
#> 12  2001 vaesto 5194901
#> 13  2002 vaesto 5206295
#> 14  2003 vaesto 5219732
#> 15  2004 vaesto 5236611
#> 16  2005 vaesto 5255580
#> 17  2006 vaesto 5276955
#> 18  2007 vaesto 5300484
#> 19  2008 vaesto 5326314
#> 20  2009 vaesto 5351427
#> 21  2010 vaesto 5375276
#> 22  2011 vaesto 5401267
#> 23  2012 vaesto 5426674
#> 24  2013 vaesto 5451270
#> 25  2014 vaesto 5471753
#> 26  2015 vaesto 5487308
#> 27  2016 vaesto 5503297
#> 28  2017 vaesto 5513130
#> 29  2018 vaesto 5517919
#> 30  2019 vaesto 5525292
#> 31  2020 vaesto 5533793
#> 32  2021 vaesto 5548241
#> 33  2022 vaesto 5563970
#> 34  2023 vaesto 5603851
#> 35  2024 vaesto 5635971
#> 


##### Wrappers PxData and pxwebData

# Exact same output as ApiData
PxData(4861, Region = "0301", ContentsCode = TRUE, Tid = c(1, -1))
#> $`04861: Areal og befolkning i tettsteder, etter region, statistikkvariabel og år`
#>          region      statistikkvariabel   år    value
#> 1 Oslo - Oslove Areal av tettsted (km²) 2000    132.9
#> 2 Oslo - Oslove Areal av tettsted (km²) 2025    129.9
#> 3 Oslo - Oslove                 Bosatte 2000 504348.0
#> 4 Oslo - Oslove                 Bosatte 2025 720631.0
#> 
#> $dataset
#>   Region ContentsCode  Tid    value
#> 1   0301        Areal 2000    132.9
#> 2   0301        Areal 2025    129.9
#> 3   0301      Bosatte 2000 504348.0
#> 4   0301      Bosatte 2025 720631.0
#> 

# Data organized differently
pxwebData(4861, Region = "0301", ContentsCode = TRUE, Tid = c(1, -1))
#> [[1]]
#>          region   år Areal av tettsted (km²) Bosatte
#> 1 Oslo - Oslove 2000                   132.9  504348
#> 2 Oslo - Oslove 2025                   129.9  720631
#> 
#> [[2]]
#>   Region  Tid Areal Bosatte
#> 1   0301 2000 132.9  504348
#> 2   0301 2025 129.9  720631
#> 


# Large query. ApiData will not work.
if(FALSE){ # This query is "commented out" 
  z <- PxData("https://api.scb.se/OV0104/v1/doris/sv/ssd/BE/BE0101/BE0101A/BefolkningNy", 
              Region = TRUE, Civilstand = TRUE, Alder = 1:10, Kon = FALSE, 
              ContentsCode = "BE0101N1", Tid = 1:10, verbosePrint = TRUE)
}


##### Small example where makeNAstatus is in use
output <- ApiData("04469", urlType = "SSBen",
                  Tid = "2020", ContentsCode = 1, Alder = TRUE, Region = "3011")
note(output)                   
#> [1] "Figures from 2018 to 2019 may be affected both by the municipal reform and introduction of new IPLOS specifications."                                                                  
#> [2] "A decrease in number of dwellings from 2018 to 2019 may be caused by the introduction of new IPLOS specifications. 61 municipalities with dwellings in 2018 have no dwellings in 2019."
#> [3] ": = Confidential. Figures are not published so as to avoid identifying persons or companies."                                                                                          
#> [4] ".. = Data not available. Figures have not been entered into our databases or are too unreliable to be published."                                                                      


```
