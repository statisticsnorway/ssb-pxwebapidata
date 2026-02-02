
#' PX-Web Data by API
#' 
#' This function constructs a PxWebApi v2 data URL using [query_url()]
#' and retrieves the data using [get_api_data()].
#' 
#' @details
#' Each variable is specified by using the variable name as an input parameter.
#'
#' The value can be specified either as a vector or as a list.
#'
#' **Vector input**
#'
#' When specified as a vector, this results in a `valueCodes` specification.
#' The vector can be specified in the same way as in a PxWebApi URL.
#' In addition, the specification method inherited from the legacy
#' [ApiData()] function for PxWebApi v1 can be used:
#'
#' - `TRUE` means all values and is equivalent to `"*"`.
#' - `FALSE` means eliminated, which is equivalent to removing the variable
#'   from the URL. This is meaningful for variables that can be eliminated;
#'   see the lower examples in [meta_frames()].
#' - Imaginary values represent `top`, e.g. `3i` is equivalent to `"top(3)"`.
#' - Numeric values are interpreted as row numbers (negative values allowed)
#'   or as indices; see the parameter description of `use_index`.
#' - Codes can be specified directly, including the use of wildcards such as
#'   `"*"` and `"??"`. Labels may also be used as an alternative to codes.
#'
#' **List input**
#'
#' When the input is a named list, the URL is constructed directly from the
#' names and elements of the list (see examples).
#' It is also possible to omit the name of a list element. In this case, the
#' element results in a `valueCodes` specification and is processed in the same
#' way as vector input.
#' 
#' @param ... Specification of query for each variable. See ‘Details’.
#' @inheritParams query_url
#' @inheritParams get_api_data
#'
#' @return
#' A data frame, or a list of data frames, depending on the input and
#' parameters.
#' @export
#'
#' @examples
#' 
#' obj <- api_data(14162, Region = FALSE, InnKvartering1 = FALSE, Landkoder2 = FALSE, 
#'                 ContentsCode = TRUE, Tid = 3i, url_type = "ssb_en")
#'           
#' obj[[1]]    # The label version of the dataset, as returned by api_data_1()
#' obj[[2]]    # The code version of the dataset, as returned by api_data_2()
#' names(obj)
#' info(obj)   # Similar to comment(); see also note() below
#' 
#'  # same as above 
#'  # api_data("https://data.ssb.no/api/pxwebapi/v2/tables/14162/data?lang=en", 
#'  #           default_query = FALSE, ContentsCode = "*", Tid = "top(3)")
#'  
#'  # also same as above 
#'  # api_data(14162, url_type = "ssb_en", default_query = FALSE,
#'  #          ContentsCode = list(valueCodes = "*"), 
#'  #          Tid = list(valueCodes = "top(3)"))
#' 
#'  api_data_1("https://data.ssb.no/api/pxwebapi/v2/tables/09546/data?lang=en",
#'             Region = FALSE, SkoleSTR = "07", GrSkolOrgForm = "4", 
#'             EierforhSkole = 1:2, ContentsCode = TRUE, Tid = "202?") 
#'             
#'  api_data_2("https://data.ssb.no/api/pxwebapi/v2/tables/07459/data?lang=en",
#'             Region = list(codelist = "agg_KommSummer", 
#'                           valueCodes = c("K-3101", "K-3103"), 
#'                           outputValues = "aggregated"),
#'             Kjonn = TRUE,
#'             Alder = list(codelist = "agg_TodeltGrupperingB", 
#'                          valueCodes = c("H17", "H18"),
#'                          outputValues = "aggregated"),
#'             ContentsCode = 1,
#'             Tid = 2i)           
#'             
#'  # codes and labels can be mixed            
#'  api_data_12(4861, 
#'              Region = c("Sarpsborg", "3103", "402?"), 
#'              ContentsCode = "Bosatte", 
#'              Tid = c(1, -1), 
#'              url_type = "ssb_en") 
#'              
#'  
#'  # A Statistics Sweden example             
#'  api_data_12("https://statistikdatabasen.scb.se/api/v2/tables/TAB4537/data?lang=en", 
#'              Region = "??", 
#'              Kon = FALSE)                      
#' 
#'  
#'  # Use default_query = TRUE to retrieve entire tables
#'  out <- api_data_2("https://data.ssb.no/api/pxwebapi/v2/tables/10172/data?lang=en", 
#'                             default_query = TRUE)
#'  out[14:22, ]  # 9 rows printed      
#' 
#'  
#'  # Use note() for explanation of status codes (see api_data() parameter makeNAstatus)                       
#'  note(out)
#'  
#'  # info() and note() return parts of the comment attribute
#'  info(out)
#'  comment(out)
#' 
api_data <- function(url_or_tableid,
                     ..., 
                     url_type = "ssb", 
                     use_index = FALSE,  
                     default_query = c(1, -2, -1),
                     return_dataset = NULL, 
                     make_na_status = TRUE, 
                     verbose_print = FALSE) {
  
  
  url <- query_url(url_or_tableid = url_or_tableid, 
                  ..., 
                  url_type = url_type, 
                  use_index = use_index,  
                  default_query = default_query) 
  
  if (!length(url)) {
    return(NULL)
  }
  
  get_api_data(url = url,
               return_dataset = return_dataset, 
               make_na_status = make_na_status, 
               verbose_print = verbose_print,
               use_ensure_json_stat2 = TRUE)
}



#' @rdname api_data
#' @export
api_data_1  <- function(..., return_dataset = 1) {
  api_data(..., return_dataset = return_dataset)
}

#' @rdname api_data
#' @export
api_data_2  <- function(..., return_dataset = 2) {
  api_data(..., return_dataset = return_dataset)
}


#' @rdname api_data
#' @export
#' 
api_data_12  <- function(..., return_dataset = 12) {
  api_data(..., return_dataset = return_dataset)
}




#' PX-Web Data by API (GET)
#' 
#' A function to read PX-Web data into R via API using GET.
#'
#' @param url  A PxWeb API URL to data.
#' @param return_dataset Possible non-NULL values are `1`, `2` and `12`. Then a single data set is returned as a data frame.
#' @param make_na_status When TRUE and when dataPackage is \code{"rjstat"} and when missing entries in `value`, 
#'                     the function tries to add an additional variable, named `NAstatus`, with status codes.
#'                     An explanation of these status codes is provided in the note part of the comment attribute, 
#'                     i.e. what you get with [note()]. See the bottom example.
#' @param verbose_print When TRUE, printing to console
#' @param use_ensure_json_stat2 `TRUE`, `FALSE`, or `"auto"` (default).
#'   If `"auto"`, the URL is modified by
#'   \code{ensure_json_stat2()} only when `"/v2/"` is detected in the URL.
#' @param ... Additional arguments passed to [get_api_data()].
#'
#' @return
#' A data frame, or a list of data frames, depending on the input and
#' parameters.
#' @export
#'
#' @examples
#' url <- paste0(
#'   "https://data.ssb.no/api/pxwebapi/v2/tables/03013/data?lang=en",
#'   "&valueCodes[Konsumgrp]=??",
#'   "&valueCodes[ContentsCode]=KpiIndMnd",
#'   "&valueCodes[Tid]=top(2)"
#' )
#'   
#' get_api_data_2(url)    
#'   
get_api_data <- function(url,
                         return_dataset = NULL,
                         make_na_status = TRUE,
                         verbose_print = FALSE,
                         use_ensure_json_stat2 = "auto") {
  
  if (isTRUE(use_ensure_json_stat2)) {
    url <- ensure_json_stat2(url)
    
  } else if (identical(use_ensure_json_stat2, "auto")) {
    if (grepl("/v2/", url, fixed = TRUE)) {
      url <- ensure_json_stat2(url)
    }
    
  } else if (!isFALSE(use_ensure_json_stat2)) {
    stop("use_ensure_json_stat2 must be TRUE, FALSE, or \"auto\"")
  }
  
  GetApiData(
    urlToData = url,
    returnDataSet = return_dataset,
    verbosePrint = verbose_print
  )
}




#' @rdname get_api_data
#' @export
get_api_data_1  <- function(..., return_dataset = 1) {
  get_api_data(..., return_dataset = return_dataset)
}

#' @rdname get_api_data
#' @export
get_api_data_2  <- function(..., return_dataset = 2) {
  get_api_data(..., return_dataset = return_dataset)
}


#' @rdname get_api_data
#' @export
#' 
get_api_data_12  <- function(..., return_dataset = 12) {
  get_api_data(..., return_dataset = return_dataset)
}
