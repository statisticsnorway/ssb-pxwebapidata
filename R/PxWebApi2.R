

#' Structured PxWebApi 2 metadata
#'
#' Structures selected parts of table metadata into data frames.
#'
#' Metadata related to the categories of dimensional variables are returned
#' as data frames, with additional information stored as attributes.
#'
#' @param url_or_tableid A table id, a PxWebApi 2 URL to data or metadata,
#'   or previously retrieved metadata.
#' @inheritParams make_url
#'
#' @returns
#' A named list of data frames. Additional metadata is stored as attributes
#' on the data frames and on the returned list.
#'
#' @export
#'
#' @examples
#' metaframes <- meta_frames(7459, url_type = "ssb_en")
#'
#' names(metaframes)
#'
#' metaframes[["ContentsCode"]]
#' metaframes[["Kjonn"]]
#'
#' # Extra information stored as an attribute on a data frame
#' attr(metaframes[["Region"]], "extra")[[1]][[1]]
#' 
#' # Code list information as a data frame stored as another attribute
#' attr(metaframes[[1]], "code_lists")
#'
#' # Information about elimination possibilities
#' attr(metaframes, "elimination")
#' 
meta_frames <- function(url_or_tableid, url_type = "ssb") {
  if (is.list(url_or_tableid)) {
    metadata <- url_or_tableid
  } else {
    metadata <- meta_data(url_or_tableid, url_type)
  }
  if (is.null(metadata)) {
    return(NULL)
  }
  
  n <- length(metadata$dimension)
  nam <- names(metadata$dimension)
  
  mf <- vector("list", n)
  names(mf) <- nam
  
  elimination <- rep(FALSE, n)
  names(elimination) <- nam
  
  
  for (i in seq_along(mf)) {
    mf[[i]] <- list_to_df_expand(metadata$dimension[[i]][["category"]],
                                 dropped_attr = "extra")
    
    elim <- metadata$dimension[[i]]$extension$elimination
    
    if (!is.null(elim)) {
      elimination[i] <- elim
    }
    
  }
  
  clf <- code_list_frames(metadata)
  for (i in seq_along(mf)) {
    attr(mf[[i]], "code_lists") <- clf[[i]]
  }
  
  attr(mf, "elimination") <- elimination
  
  mf
}



code_list_frames <- function(meta_data) {
  n <- length(meta_data$dimension)
  nam <- names(meta_data$dimension)
  
  a <- vector("list", n)
  names(a) <- nam
  
  for (i in seq_len(n)) {
    code_lists <- meta_data$dimension[[i]]$extension$codeLists
    m <- length(code_lists)
    for (j in seq_len(m)) {
      href <- unlist(code_lists[[j]]$links)["href"]
      if (length(href) != 1) {
        href <- NA_character_
        warning(paste("Unique href not found:", paste(unlist(code_lists[[j]])[1:2], collapse = ", ")))
      }
      code_lists[[j]]$links <- href
    }
    lrtd <- list_records_to_df(code_lists)
    if (!is.null(lrtd)) {
      a[[i]] <- lrtd
    }
  }
  a
}





#' PxWebApi 2 metadata for a table
#'
#' Retrieves metadata for a table using the PxWebApi 2 endpoint and returns it
#' as an R object via [jsonlite::read_json()].
#'
#' @inheritParams make_url
#' @param url_or_tableid Either a numeric table id or a PxWebApi 2 URL to data.
#'   When a data URL is supplied, it is internally converted to a metadata URL.
#'
#' @returns
#' A list containing table metadata as returned by [jsonlite::read_json()].
#'
#' @export
#'
#' @examples
#' metadata1 <- meta_data(8991, url_type = "ssb_en")
#' metadata2 <- meta_data(
#'   "https://statistikdatabasen.scb.se/api/v2/tables/TAB1525/data?lang=en"
#' )
#'
#' print(metadata1[1:4])
#' print(metadata2[1:4])
meta_data <- function(url_or_tableid,  url_type = "ssb") {
  Graceful(meta_data_, url_or_tableid, url_type)
}

meta_data_ <- function(url_or_tableid,  url_type) {
  url <- ensure_url(url_or_tableid, url_type)
  url <- metadata_url(url)  
  jsonlite::read_json(url)
}


ensure_url <- function(url_or_tableid,  url_type) {
  integer_url <- suppressWarnings(as.integer(url_or_tableid))  
  if (!is.na(integer_url)) {
    url_or_tableid <- make_url(integer_url, url_type = url_type) 
  } 
  url_or_tableid
}


#' Make data url from table id
#'
#' @param id Table id (integer).
#' @param url_type Currently two possibilities: "ssb" (Norwegian) or "ssb_en" (English).
#'
#' @return A character string (URL).
#' @export
#' @keywords internal
#'
#' @examples
#' make_url(4861)
#' make_url(4861, "ssb_en")
make_url <- function(id, url_type = "ssb") {
  if (url_type == "ssb")
    return(ssb_url(id))
  if (url_type == "ssb_en")
    return(ssb_url_en(id))
  stop('url_type must be "ssb" or "ssb_en"')
}

ssb_url <- function(id, lang = "no") {
  paste0("https://data.ssb.no/api/pxwebapi/v2/tables/", Number(id, 5), "/data?lang=", lang)
}

ssb_url_en <- function(id) {
  ssb_url(id, lang = "en")
}

#' Make metadata url from data url
#'
#' @param url URL to data.
#' @return A character string (URL).
#' @export
#' @keywords internal
#'
#' @examples
#' metadata_url(make_url(4861))
#' metadata_url(make_url(4861, "ssb_en"))
metadata_url <- function(url) {
  if (!grepl("/metadata", url)) {
    url <- replace_last_rev(url, "/data", "/metadata")
  }
  url
}


# Written with help from ChatGPT
replace_last_rev <- function(x, pattern, replacement) {
  rev1 <- function(s) paste(rev(strsplit(s, "", fixed = TRUE)[[1]]), collapse = "")
  rev1(sub(rev1(pattern), rev1(replacement), rev1(x), fixed = TRUE))
}