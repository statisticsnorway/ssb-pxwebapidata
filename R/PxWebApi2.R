

#' PxWebApi v2 metadata for a code list
#'
#' Retrieves metadata for a code list and returns it as an R object.
#'
#' @param url A PxWebApi v2 URL to metadata for a code list.
#' @param as_frame Logical. When TRUE, the metadata is structured as a
#'   data frame, with additional information stored in an attribute named
#'   `"extra"`.
#'
#' @returns
#' An R object containing metadata for the code list. When `as_frame = TRUE`,
#' the result is a data frame.
#'
#' @export
#'
#' @examples
#' metaframes <- meta_frames(7459, url_type = "ssb_en")
#' url <- attr(metaframes[["Region"]], "code_lists")[["links"]][3]
#' print(url)
#' 
#' df <- meta_code_list(url)
#'
#' print(df)
#' print(attr(df, "extra")[1:3])
#' 
meta_code_list <- function(url, as_frame = TRUE) {
  
  url <- ensure_json_stat2(url)
  
  a <- Graceful(jsonlite::read_json, url)
  
  if (is.null(a)) {
    return(NULL)
  }
  if (!as_frame) {
    return(a)
  }
  ma <- match("values", names(a))
  if (is.na(ma)) {
    message("Item with name 'value' not found")
    return(NULL)
  }
  df <- list_records_to_df(a[[ma]])
  
  attr(df, "extra") <- a[-ma]
  df
}



#' Structured PxWebApi v2 metadata
#'
#' Structures selected parts of table metadata into data frames.
#'
#' Metadata related to the categories of dimensional variables are returned
#' as data frames, with additional information stored as attributes.
#'
#' @param url_or_tableid A table id, a PxWebApi v2 URL to data or metadata,
#'   or previously retrieved metadata.
#' @inheritParams make_url
#'
#' @returns
#' A named list of data frames. Additional metadata is stored as attributes
#' on the data frames.
#' The data URL is stored in the comment attribute of the returned object.
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
#' attr(metaframes[["Region"]], "code_lists")
#'
#' # Information about elimination possibilities
#' attr(metaframes[["Region"]], "elimination")
#' attr(metaframes[["ContentsCode"]], "elimination")
#' sapply(metaframes, attr, "elimination") # elimination info for all variables
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
  
  url <- comment(metadata)
  
  n <- length(metadata$dimension)
  nam <- names(metadata$dimension)
  
  mf <- vector("list", n)
  names(mf) <- nam
  
  elimination <- rep(FALSE, n)
  names(elimination) <- nam
  
  
  for (i in seq_along(mf)) {
    mf[[i]] <- list_to_df_expand(metadata$dimension[[i]][["category"]],
                                 category_col = "code",
                                 dropped_attr = "extra")
    
    elim <- metadata$dimension[[i]]$extension$elimination
    
    if (!is.null(elim)) {
      elimination[i] <- elim
    }
    
  }
  
  clf <- code_list_frames(metadata)
  for (i in seq_along(mf)) {
    attr(mf[[i]], "code_lists") <- clf[[i]]
    attr(mf[[i]], "elimination") <- as.logical(elimination[i]) # as.logical remove the name
  }
  
  # attr(mf, "elimination") <- elimination
  comment(mf) <- url
  
  mf
}



code_list_frames <- function(metadata) {
  n <- length(metadata$dimension)
  nam <- names(metadata$dimension)
  
  a <- vector("list", n)
  names(a) <- nam
  
  for (i in seq_len(n)) {
    ext <- metadata$dimension[[i]]$extension
    code_lists <- code_lists <- get1(ext, c("codeLists", "codelists"))
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


get1 <- function(x, names) {
  for (nm in names) {
    val <- x[[nm]]
    if (!is.null(val)) {
      return(val)
    }
  }
  NULL
}


#' PxWebApi v2 metadata for a table
#'
#' Retrieves metadata for a table using the PxWebApi v2 endpoint and returns it
#' as an R object via [jsonlite::read_json()].
#'
#' @inheritParams make_url
#' @param url_or_tableid Either a numeric table id or a PxWebApi v2 URL to data.
#'   When a data URL is supplied, it is internally converted to a metadata URL.
#'
#' @returns
#' A list containing table metadata read by [jsonlite::read_json()] after internal URL adjustments via [ensure_json_stat2()].
#' The data URL is stored in the comment attribute of the returned object.
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
  metadata <- jsonlite::read_json(ensure_json_stat2(url))
  comment(metadata) <- metadata_url(url, data_url = TRUE)
  metadata
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




#' Convert between data and metadata URLs
#'
#' Converts a PxWebApi v2 data URL to a metadata URL, or vice versa.
#'
#' @param url A PxWebApi URL to data or metadata.
#' @param data_url Logical. When TRUE, return a data URL. When FALSE (default),
#'   return a metadata URL.
#'
#' @return A character string (URL).
#' @export
#' @keywords internal
#'
#' @examples
#' metadata_url(make_url(4861))
#' metadata_url(make_url(4861, "ssb_en"), data_url = TRUE)
metadata_url <- function(url, data_url = FALSE) {
  
  if (!data_url && !grepl("/metadata", url)) {
    url <- replace_last_rev(url, "/data", "/metadata")
  }
  
  if (data_url) {
    url <- replace_last_rev(url, "/metadata", "/data")
  }
  
  url
}


# Written with help from ChatGPT
replace_last_rev <- function(x, pattern, replacement) {
  rev1 <- function(s) paste(rev(strsplit(s, "", fixed = TRUE)[[1]]), collapse = "")
  rev1(sub(rev1(pattern), rev1(replacement), rev1(x), fixed = TRUE))
}
