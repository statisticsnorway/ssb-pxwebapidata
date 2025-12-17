
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
#' @param response_format  Response format to be used when `apiPackage` and `dataPackage` are defaults  (`"json-stat"` or `"json-stat2"`).
#' @param verbose_print When TRUE, printing to console
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
                         response_format = "json-stat2", 
                         verbose_print = FALSE) {
  GetApiData(urlToData = url, 
             returnDataSet = return_dataset,
             responseFormat = response_format,
             verbosePrint = verbose_print)
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