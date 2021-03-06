#' PX-Web Data by API
#' 
#' A function to read PX-Web data into R via API. The example code reads data from the three national statistical institutes, Statistics Norway, Statistics Sweden and Statistics Finland.
#' 
#' @encoding UTF8
#'
#' @param urlToData url to data or id of SSB data
#' @param ... specification of JSON query for each variable
#' @param getDataByGET When TRUE, readymade dataset by GET
#' @param returnMetaData When TRUE, metadata returned  
#' @param returnMetaValues When TRUE, values from metadata returned 
#' @param returnMetaFrames When TRUE, values and valueTexts from metadata returned as data frames 
#' @param returnApiQuery When TRUE, JSON query returned 
#' @param defaultJSONquery specification for variables not included in ...
#' @param verbosePrint When TRUE, printing to console
#' @param use_factors Parameter to \code{\link{fromJSONstat}} defining whether dimension categories should be factors or character objects.
#' @param urlType  Parameter defining how url is constructed from id number. Currently two Statistics Norway possibilities: "SSB" (Norwegian) or "SSBen" (English)
#' @param apiPackage Package used to capture json(-stat) data from API: \code{"httr"} (default) or \code{"pxweb"}
#' @param dataPackage Package used to transform json(-stat) data to data frame: \code{"rjstat"} (default) or \code{"pxweb"}
#' @param returnDataSet Possible non-NULL values are `1`, `2` and `12`. Then a single data set is returned as a data frame.
#' * **`1`:** The first data set
#' * **`2`:** The second data set 
#' * **`12`:** Both data sets combined 
#' 
#' The original list name is included as a comment attribute. In the case of `12` the name of the first data set is used.   
#' 
#' @details Each variable is specified by using the variable name as input parameter. The value can be specified as:  
#' TRUE (all), FALSE (eliminated), imaginary value (top), variable indices, 
#' original variable id's (values) or variable labels (valueTexts). 
#' Reversed indices can be specified as negative values. 
#' Indices outside the range are removed. Variables not specified is set to the value of defaultJSONquery 
#' whose default means the first and the two last elements. 
#' 
#' The value can also be specified as a (unnamed) two-element list corresponding to the two 
#' query elements, filter and values. In addition it possible with a single-element list.
#' Then filter is set to 'all'. See examples. 
#' 
#' Functionality in the package \code{pxweb} can be utilized by making use of the parameters 
#' \code{apiPackage} and \code{dataPackage} 
#' as implemented as the wrappers \code{PxData} and \code{pxwebData}.
#' With data sets too large for ordinary downloads, \code{PxData} can solve the problem (multiple downloads).
#' When using \code{pxwebData}, data will be downloaded in px-json format instead of json-stat and the output data frame 
#' will be organized differently (ContentsCode categories as separate variables).
#'
#' @return list of two data sets (label and id)
#' @note See the package vignette for aggregations using filter \code{agg}.
#' @export
#' 
#' @importFrom jsonlite unbox read_json toJSON
#' @importFrom rjstat fromJSONstat 
#' @importFrom httr GET POST verbose content
#' @importFrom utils head tail
#' @importFrom pxweb pxweb_get
#'
#' @examples
#' \donttest{
#' ##### Readymade dataset by GET.  Works for readymade datasets and "saved-JSON-stat-query-links".
#' x <- ApiData("https://data.ssb.no/api/v0/dataset/1066.json?lang=en", getDataByGET = TRUE)
#' x[[1]]  # The label version of the data set
#' x[[2]]  # The id version of the data set
#' names(x)
#' 
#' ##### As above with single data set output
#' url <- "https://data.ssb.no/api/v0/dataset/1066.json?lang=en"
#' x1 <- ApiData1(url, getDataByGET = TRUE) # as x[[1]]
#' x2 <- ApiData2(url, getDataByGET = TRUE) # as x[[2]]
#' comment(x1) # as names(x)[1]
#' comment(x2) # as names(x)[2]
#' ApiData12(url, getDataByGET = TRUE) # Combined
#' 
#' ##### Special output
#' ApiData("https://data.ssb.no/api/v0/en/table/11419", returnMetaData = TRUE)   # meta data
#' ApiData("https://data.ssb.no/api/v0/en/table/11419", returnMetaValues = TRUE) # meta data values
#' ApiData("https://data.ssb.no/api/v0/en/table/11419", returnMetaFrames = TRUE) # list of data frames
#' ApiData("https://data.ssb.no/api/v0/en/table/11419", returnApiQuery = TRUE)   # query using defaults
#' 
#' 
#' ##### Ordinary use
#' 
#' # NACE2007 as imaginary value (top 10), ContentsCode as TRUE (all), Tid is default
#' ApiData("https://data.ssb.no/api/v0/en/table/11419", NACE2007 = 10i, ContentsCode = TRUE)
#' 
#' # Two specified and the last is default (as above) - in Norwegian change en to no in url
#' ApiData("https://data.ssb.no/api/v0/no/table/11419", NACE2007 = 10i, ContentsCode = TRUE)
#' 
#' # Number of residents (bosatte) last year, each region
#' ApiData("https://data.ssb.no/api/v0/en/table/04861", Region = TRUE, 
#'         ContentsCode = "Bosatte", Tid = 1i)
#' 
#' # Number of residents (bosatte) each year, total
#' ApiData("https://data.ssb.no/api/v0/en/table/04861", Region = FALSE, 
#'         ContentsCode = "Bosatte", Tid = TRUE)
#' 
#' # Some years
#' ApiData("https://data.ssb.no/api/v0/en/table/04861", Region = FALSE, 
#'         ContentsCode = "Bosatte", Tid = c(1, 5, -1))
#' 
#' # Two selected regions
#' ApiData("https://data.ssb.no/api/v0/en/table/04861", Region = c("1103", "0301"), 
#'         ContentsCode = 2, Tid = c(1, -1))
#' 
#' 
#' ##### Using id instead of url, unnamed input and verbosePrint
#' ApiData(4861, c("1103", "0301"), 1, c(1, -1)) # same as below 
#' ApiData(4861, Region = c("1103", "0301"), ContentsCode=2, Tid=c(1, -1)) 
#' names(ApiData(4861,returnMetaFrames = TRUE))  # these names from metadata assumed two lines above
#' ApiData("4861", c("1103", "0301"), 1, c(1, -1),  urlType="SSBen")
#' ApiData("01222", c("1103", "0301"), c(4, 9:11), 2i, verbosePrint = TRUE)
#' ApiData(1066, getDataByGET = TRUE,  urlType="SSB")
#' ApiData(1066, getDataByGET = TRUE,  urlType="SSBen")
#' 
#' }
#' ##### Advanced use using list. See details above. Try returnApiQuery=TRUE on the same examples. 
#' ApiData(4861, Region = list("03*"), ContentsCode = 1, Tid = 5i) # "all" can be dropped from the list
#' \donttest{ApiData(4861, Region = list("all", "03*"), ContentsCode = 1, Tid = 5i)  # same as above
#' ApiData(04861, Region = list("item", c("1103", "0301")), ContentsCode = 1, Tid = 5i)
#' 
#' 
#' ##### Using data from SCB to illustrate returnMetaFrames
#' urlSCB <- "https://api.scb.se/OV0104/v1/doris/sv/ssd/BE/BE0101/BE0101A/BefolkningNy"
#' mf <- ApiData(urlSCB, returnMetaFrames = TRUE)
#' names(mf)              # All the variable names
#' attr(mf, "text")       # Corresponding text information as attribute
#' mf$ContentsCode        # Data frame for the fifth variable (alternatively  mf[[5]])
#' attr(mf,"elimination") # Finding variables that can be eliminated
#' ApiData(urlSCB,        # Eliminating all variables that can be eliminated (line below)
#'         Region = FALSE, Civilstand = FALSE, Alder = FALSE,  Kon = FALSE,
#'         ContentsCode  = "BE0101N1", # Selecting a single ContentsCode by text input
#'         Tid = TRUE)                 # Choosing all possible values of Tid.
#'  
#'                
#' ##### Using data from Statfi to illustrate use of input by variable labels (valueTexts)
#' urlStatfi <- "https://pxnet2.stat.fi/PXWeb/api/v1/en/StatFin/vrm/kuol/statfin_kuol_pxt_12au.px"
#' ApiData(urlStatfi, returnMetaFrames = TRUE)$Tiedot
#' ApiData(urlStatfi, Alue = FALSE, Vuosi = TRUE, Tiedot = "Population")  # same as Tiedot = 21
#' 
#' 
#' ##### Wrappers PxData and pxwebData
#' 
#' # Exact same output as ApiData
#' PxData(4861, Region = "0301", ContentsCode = TRUE, Tid = c(1, -1))
#' 
#' # Data organized differently
#' pxwebData(4861, Region = "0301", ContentsCode = TRUE, Tid = c(1, -1))
#' 
#' 
#' # Large query. ApiData will not work.
#' if(FALSE){ # This query is "commented out" 
#'   z <- PxData("https://api.scb.se/OV0104/v1/doris/sv/ssd/BE/BE0101/BE0101A/BefolkningNy", 
#'               Region = TRUE, Civilstand = TRUE, Alder = 1:10, Kon = FALSE, 
#'               ContentsCode = "BE0101N1", Tid = 1:10, verbosePrint = TRUE)
#' }
#' }
#'
ApiData <- function(urlToData, ..., getDataByGET = FALSE, returnMetaData = FALSE, returnMetaValues = FALSE, 
                    returnMetaFrames = FALSE, returnApiQuery = FALSE, 
                    defaultJSONquery = c(1,-2, -1), verbosePrint = FALSE,
                    use_factors=FALSE, urlType="SSB", 
                    apiPackage = "httr",
                    dataPackage = "rjstat",
                    returnDataSet = NULL) {
  
  # if(!getDataByGET)     ## With this test_that("ApiData - SSB-data advanced use", fail
  #   apiPackage = "pxweb"
  
  
  if(!is.null(returnDataSet)){
    if(!(returnDataSet %in% c(1, 2, 12)))
      stop("non-NULL returnDataSet must be in 1, 2, or 12.")
    
  } else {
    returnDataSet <- 0
  }
    
  
  integerUrl <- suppressWarnings(as.integer(urlToData))
  if (!is.na(integerUrl)) 
    urlToData <- MakeUrl(integerUrl, urlType = urlType, getDataByGET = getDataByGET) # SSBurl(integerUrl, getDataByGET)
  

  if(!(dataPackage %in% c("rjstat", "pxweb", "none"))){
    stop('dataPackage must be "rjstat" or "pxweb"')
  }
  
  if(apiPackage != "httr"){
    if(apiPackage != "pxweb"){
      stop('apiPackage must be "httr" or "pxweb"')
    }
  } else {
    if(dataPackage == "pxweb")
      stop('apiPackage  must be "pxweb" when dataPackage is pxweb')
  }
  
  if (getDataByGET){ 
    if((apiPackage != "httr" | dataPackage != "rjstat") & dataPackage != "none"){
      apiPackage = "httr"
      dataPackage = "rjstat"
      warning('Parameters "apiPackage" and "dataPackage" ignored when getDataByGET')
    }
      post <- content(GET(urlToData), "text")
    } else {
      metaData <- MetaData(urlToData)
      if (returnMetaData) 
        return(metaData)
      if (returnMetaValues) 
        return(VarMetaData(metaData))
      metaFrames <- MetaFrames(metaData)   
      if (returnMetaFrames) 
        return(metaFrames)
      if (verbosePrint){ 
        print(VarMetaData(metaData))
        cat("\n\n")
      }
 
      responseFormat = "json-stat"
      if(dataPackage == "pxweb")
        responseFormat = "json"
      sporr <- MakeApiQuery(metaFrames, ..., defaultJSONquery = defaultJSONquery, responseFormat = responseFormat)
      if (returnApiQuery) 
        return(sporr)
      if(apiPackage == "pxweb" ){
        post <-  pxweb_get(url = urlToData, query = sporr, verbose = verbosePrint)
      } else {
        if (verbosePrint) 
          post <-  content(POST(urlToData, body = sporr, encode = "json", verbose()), "text") 
        else 
          post <-  content(POST(urlToData, body = sporr, encode = "json"), "text")
      }
    }

  if(dataPackage == "none" )
    return("post")
    
  if(dataPackage == "pxweb" ){
    if(returnDataSet %in% c(1,2)){
      if(returnDataSet == 1){
        z <- list(as.data.frame(post, column.name.type = "text", variable.value.type = "text"))
      } else {
        z <- list(as.data.frame(post, column.name.type = "code", variable.value.type = "code"))
      }
    } else {
      z <- list(as.data.frame(post, column.name.type = "text", variable.value.type = "text"),
                as.data.frame(post, column.name.type = "code", variable.value.type = "code"))
    }
    if(returnDataSet %in% c(1,2)){
      return(DataSet(z, 1))
    }
    if(returnDataSet %in% 12){
      return(DataSet12(z))
    }
    return(z)
  }

  if (length(post) > 1) {
    n <- length(post)
    for (i in seq_len(n)) {
      if(returnDataSet %in% c(1,2)){
        if(returnDataSet == 1){
          post[[i]] <- fromJSONstat(post[[i]], naming = "label", use_factors = use_factors)
        } else {
          post[[i]] <- fromJSONstat(post[[i]], naming = "id", use_factors = use_factors)
        }
      } else {
        post[[i]] <- c(fromJSONstat(post[[i]], naming = "label", use_factors = use_factors), 
                       fromJSONstat(post[[i]], naming = "id", use_factors = use_factors))
      }
    }
    post[[1]][[1]] <- eval(parse(text = paste("rbind(", paste("post[[", seq_len(n), "]][[1]],", collapse = ""), "deparse.level = 0)")))
    
    if(length(post[[1]])>1)
      post[[1]][[2]] <- eval(parse(text = paste("rbind(", paste("post[[", seq_len(n), "]][[2]],", collapse = ""), "deparse.level = 0)")))
    
    if(returnDataSet %in% c(1,2)){
      return(DataSet(post[[1]], 1))
    }
    
    if(returnDataSet %in% 12){
      return(DataSet12(post[[1]]))
    }
    
    return(post[[1]])
  }
  
  
  if(returnDataSet %in% c(1,2)){
    if(returnDataSet == 1){
      z <- fromJSONstat(post, naming = "label",use_factors=use_factors)
    } else {
      z <- fromJSONstat(post, naming = "id",use_factors=use_factors)
    }
  } else {
    z <- c(fromJSONstat(post, naming = "label",use_factors=use_factors), 
           fromJSONstat(post, naming = "id",use_factors=use_factors))
  }
  
  if(returnDataSet %in% c(1,2)){
    return(DataSet(z, 1))
  }
  
  if(returnDataSet %in% 12){
    return(DataSet12(z))
  }
  
  z
}



#' @rdname ApiData
#' @export
GetApiData = function(..., getDataByGET = TRUE){
  ApiData(..., getDataByGET = getDataByGET)
}



#' @rdname ApiData
#' @export
pxwebData = function(..., apiPackage = "pxweb", dataPackage = "pxweb"){
  ApiData(..., apiPackage = apiPackage, dataPackage = dataPackage)
}

#' @rdname ApiData
#' @export
PxData = function(..., apiPackage = "pxweb", dataPackage = "rjstat"){
  ApiData(..., apiPackage = apiPackage, dataPackage = dataPackage)
}


#' @rdname ApiData
#' @export
ApiData1  <- function(..., returnDataSet = 1) {
  ApiData(..., returnDataSet = returnDataSet)
}

#' @rdname ApiData
#' @export
ApiData2  <- function(..., returnDataSet = 2) {
  ApiData(..., returnDataSet = returnDataSet)
}


#' @rdname ApiData
#' @export
#' 
ApiData12  <- function(..., returnDataSet = 12) {
  ApiData(..., returnDataSet = returnDataSet)
}

#' @rdname ApiData
#' @export
GetApiData1  <- function(..., returnDataSet = 1) {
  GetApiData(..., returnDataSet = returnDataSet)
}

#' @rdname ApiData
#' @export
GetApiData2  <- function(..., returnDataSet = 2) {
  GetApiData(..., returnDataSet = returnDataSet)
}


#' @rdname ApiData
#' @export
#' 
GetApiData12  <- function(..., returnDataSet = 12) {
  GetApiData(..., returnDataSet = returnDataSet)
}


#' @rdname ApiData
#' @export
pxwebData1  <- function(..., returnDataSet = 1) {
  pxwebData(..., returnDataSet = returnDataSet)
}

#' @rdname ApiData
#' @export
pxwebData2  <- function(..., returnDataSet = 2) {
  pxwebData(..., returnDataSet = returnDataSet)
}

#' @rdname ApiData
#' @export
pxwebData12  <- function(..., returnDataSet = 12) {
  pxwebData(..., returnDataSet = returnDataSet)
}


#' @rdname ApiData
#' @export
PxData1  <- function(..., returnDataSet = 1) {
  PxData(..., returnDataSet = returnDataSet)
}


#' @rdname ApiData
#' @export
PxData2  <- function(..., returnDataSet = 2) {
  PxData(..., returnDataSet = returnDataSet)
}

#' @rdname ApiData
#' @export
PxData12  <- function(..., returnDataSet = 12) {
  PxData(..., returnDataSet = returnDataSet)
}




#' Adding leading zeros
#'
#' @param n  numeric vector
#' @param width width
#'
#' @return Number as string
#' @keywords internal 
#'
Number = function(n,width=3){
  s = "s=sprintf('%0d',n)"
  s = gsub("0",as.character(width),s)
  eval(parse(text=s))
  s = gsub(" ","0",s)
  s
}


MetaData <- function(url) {
  z <- read_json(url)  # Same as fromJSON(content(GET(url),'text'),simplifyVector = FALSE)
  tit <- z[[1]]
  z <- z[[2]]
  for (i in seq_len(length(z))) {
    for (j in seq_len(length(z[[i]]))) z[[i]][[j]] <- unlist(z[[i]][[j]])
  }
  z
}

VarMetaData <- function(metaData) {
  n <- length(metaData)
  nam <- rep("", n)
  elimination <- rep(FALSE, n)
  for (i in 1:length(metaData)) {
    nam[i] <- metaData[[i]]$code
    if (!is.null(metaData[[i]]$elimination)) 
      elimination[i] <- metaData[[i]]$elimination
    metaData[[i]] <- metaData[[i]]$values
  }
  names(metaData) <- nam
  attr(metaData, "elimination") <- elimination
  metaData
}


MetaFrames <- function(metaData) {
  n <- length(metaData)
  nam <- rep("", n)
  text <- rep("", n)
  elimination <- rep(FALSE, n)
  time <- rep(FALSE, n)
  for (i in 1:length(metaData)) {
    nam[i] <- metaData[[i]]$code
    if (!is.null(metaData[[i]]$text)) 
      text[i] <- metaData[[i]]$text
    if (!is.null(metaData[[i]]$elimination)) 
      elimination[i] <- metaData[[i]]$elimination
    if (!is.null(metaData[[i]]$time)) 
      time[i] <- metaData[[i]]$time
    metaData[[i]] <- as.data.frame(metaData[[i]][c("values", "valueTexts")], stringsAsFactors = FALSE)
  }
  names(metaData) <- nam
  names(text) <- nam
  names(elimination) <- nam
  names(time) <- nam
  attr(metaData, "text") <- text
  attr(metaData, "elimination") <- elimination
  attr(metaData, "time") <- time
  metaData
}


# x is one element of metaFrames
MakeApiVar <- function(x, values = c(1, -2, -1)) {
  if (is.list(values)) {
    if (length(values) == 1) {
      filt <- "all"
      valu <- values[[1]]
    } else {
      filt <- values[[1]]
      valu <- values[[2]]
    }
  } else {
    if (is.logical(values)) {
      if (!values) 
        return(NULL) else {
          filt <- "all"
          valu <- "*"
        }
      
    } else if (is.complex(values)) {
      filt <- "top"
      valu <- as.character(Im(values))
    } else if (is.numeric(values)) {
      filt <- "item"
      nx <- length(x[[1]]$values)
      values <- values[abs(values) > 0 & abs(values) <= nx]  # Fix outside range
      values[values < 0] <- rev(seq_len(nx))[-values[values < 0]]  # Fix negative
      valu <- x[[1]]$values[unique(values)]
      if (!length(valu)) 
        stop(paste(names(x), "no indices in valid range"))
    } else {
      filt <- "item"
      noMatch <- !(values %in% x[[1]]$values)
      if (any(noMatch)) values[noMatch] <- x[[1]]$values[match(values[noMatch], x[[1]]$valueTexts)]
      if (any(!(values %in% x[[1]]$values)))
        stop(paste(names(x[1]), ": Text input must be in:", 
                   paste(c(HeadEnd(x[[1]]$values, 20), HeadEnd(x[[1]]$valueTexts, 8)), collapse = ", ")))
      valu <- values
    }
  }
  list(code = unbox(names(x)), selection = list(filter = unbox(filt), values = valu))
}


# Old version where x is one element of varMetaData 
MakeApiVarOld <- function(x, values = c(1, -2, -1)) {
  if (is.list(values)) {
    if (length(values) == 1) {
      filt <- "all"
      valu <- values[[1]]
    } else {
      filt <- values[[1]]
      valu <- values[[2]]
    }
  } else {
    if (is.logical(values)) {
      if (!values) 
        return(NULL) else {
          filt <- "all"
          valu <- "*"
        }
      
    } else if (is.complex(values)) {
      filt <- "top"
      valu <- as.character(Im(values))
    } else if (is.numeric(values)) {
      filt <- "item"
      nx <- length(x[[1]])
      values <- values[abs(values) > 0 & abs(values) <= nx]  # Fix outside range
      values[values < 0] <- rev(seq_len(nx))[-values[values < 0]]  # Fix negative
      valu <- x[[1]][unique(values)]
      if (!length(valu)) 
        stop(paste(names(x), "no indices in valid range"))
    } else {
      filt <- "item"
      if (any(!(values %in% x[[1]])))
        stop(paste(names(x[1]), ": Text input must be in:", paste(x[[1]], collapse = ", ")))
      valu <- values
    }
  }
  list(code = unbox(names(x)), selection = list(filter = unbox(filt), values = valu))
}



Pmatch <- function(x, y, CheckHandling = stop) {
  # as pmatch where NA set to remaing values in y
  a <- pmatch(x, y)
  naa <- is.na(a)
  if (any(naa)) {
    nax <- naa & !is.na(x)
    if (any(nax)) {
      CheckHandling(paste("Non-matching input:", paste(x[nax], collapse = ", "),
                          ",   Valid input parameters in addition to those in the function documentation are: ",
                          paste(y, collapse = ", ")))
    }
    if (!any(!naa)) 
      return(seq_len(length(y))[seq_len(length(x))])
    nna <- sum(naa)
    a[naa] <- seq_len(length(y))[-a[!naa]][seq_len(nna)]
  }
  a
}



SSBurl <- function(id, readyMade = FALSE) {
  if (readyMade) 
    url <- paste("https://data.ssb.no/api/v0/dataset/", Number(id, 1), ".json", sep = "") 
  else url <- paste("https://data.ssb.no/api/v0/no/table/", Number(id, 5), sep = "")
  url
}

SSBurlen <- function(id, readyMade = FALSE) {
  if (readyMade) 
    url <- paste("https://data.ssb.no/api/v0/dataset/", Number(id, 1), ".json?lang=en", sep = "") 
  else 
    url <- paste("https://data.ssb.no/api/v0/en/table/", Number(id, 5), sep = "")
  url
}


#' MakeUrl from id
#' 
#' @encoding UTF8
#'
#' @param id integer
#' @param urlType  Currently two possibilities: "SSB" (Norwegian) or "SSBen" (English)
#' @param getDataByGET As input to ApiData
#'
#' @return url as string
#' @export
#' @keywords internal
#'
#' @examples
#' MakeUrl(4861)
#' MakeUrl(4861, "SSBen")
#' MakeUrl(1066, getDataByGET = TRUE)
#' MakeUrl(1066, "SSBen", getDataByGET = TRUE)
MakeUrl <- function(id,urlType="SSB",getDataByGET = FALSE){
  if(urlType=="SSB")
    return(SSBurl(id,getDataByGET))
  if(urlType=="SSBen")
    return(SSBurlen(id,getDataByGET))
  stop('urlType must be "SSB" or "SSBen"')
}



MakeApiQuery <- function(metaFrames, ..., defaultJSONquery = c(1, -2, -1), returnThezList = FALSE, responseFormat = "json-stat") {
  x <- list(...)
  namesx <- names(x)
  if (is.null(namesx)) 
    namesx <- rep(NA, length(x)) else namesx[namesx == ""] <- NA
  z <- vector("list", length(metaFrames))
  a <- z
  names(z) <- names(metaFrames)
  pm <- Pmatch(namesx, names(metaFrames))
  for (i in seq_len(length(z))) z[[i]] <- defaultJSONquery
  z[pm] <- x
  elim <- attr(metaFrames, "elimination")
  emptya <- rep(FALSE, length(a))
  if (returnThezList) 
    return(z)
  for (i in seq_len(length(a))) {
    apiVar <- MakeApiVar(metaFrames[i], z[[i]])
    if (is.null(apiVar)) {
      if (!elim[i]){ 
        if(sum(elim) == 0) 
          ptext = "(no variables can in this table)"
        else
          ptext = paste("(these variables can:",paste(names(elim)[elim], collapse = ", "),")")
        stop(paste(names(z)[i], "cannot be eliminated", ptext))
      }
      emptya[i] <- TRUE
    } else a[[i]] <- apiVar
  }
  b <- list(query = a[!emptya], response = list(format = unbox(responseFormat)))
  toJSON(b, auto_unbox = FALSE, pretty = TRUE)
}


HeadEnd <- function(x, n = 8L) {
  x <- as.character(x)
  if (length(x) > (n + 2))
    x <- c(head(x, n = n), "...", tail(x, n = 1))
  x
}


DataSet12 <- function(x){
  z <- cbind(x[[1]][, !(names(x[[1]] ) %in% names(x[[2]])), drop=FALSE], x[[2]])
  comment(z) <- names(x)
  z
}

DataSet <- function(x, i){
  z <- x[[i]]
  comment(z) <- names(x)[i]
  z
}






















