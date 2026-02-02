#' PX-Web API query URL
#'
#' @param url_or_tableid
#'        A table id, a PxWebApi v2 URL to data or metadata, or metadata returned by
#'        [meta_data()] or [meta_frames()].
#' @param ... Specification of query for each variable. See ‘Details’ in [api_data()].
#' @inheritParams make_url
#' @param use_index
#' Logical. If TRUE, numeric values are matched against the `index` variable in
#' the metadata, which usually starts at 0. If FALSE (default), numeric values
#' are interpreted as row numbers in the metadata, using standard R indexing.
#' Negative values can be used to specify reversed row numbers.
#' @param default_query Specification for variables not included in `...`.
#'   The default is `default_query = c(1, -2, -1)`,
#'   which selects the first and the two last codes listed in the metadata.
#'   Use `default_query = TRUE` 
#'   and omit specifying individual variables to retrieve entire tables.
#'
#' @returns
#' A PxWeb API URL to data, with query parameters added according to the input.
#' 
#' @export
#'
#' @examples
#' 
#' query_url(4861, 
#'           Region = FALSE, 
#'           ContentsCode = "Bosatte", 
#'           Tid = c(1, 5, -1), 
#'           url_type = "ssb_en")
#'           
#'           
#' query_url("https://data.ssb.no/api/pxwebapi/v2/tables/08991/data?lang=en",
#'           Fangst2 = FALSE,
#'           Elver = FALSE,
#'           ContentsCode = TRUE,  # same as "*"   
#'           Tid = "top(5)")       # same as 5i
#'           
#'           
#'           
#' query_url("https://data.ssb.no/api/pxwebapi/v2/tables/07459/data?lang=en",
#'           Region = FALSE,
#'           Kjonn = TRUE,
#'           Alder = list(codelist = "agg_TodeltGrupperingB", 
#'                        valueCodes = c("H17", "H18"),
#'                        outputValues = "aggregated"),
#'          ContentsCode = 1,
#'          Tid = 4i)
#' 
query_url <- function(url_or_tableid, ..., url_type = "ssb", use_index = FALSE,  default_query = c(1, -2, -1)) {
  
  if (all(sapply(url_or_tableid, is.data.frame))) {
    metaframes <- url_or_tableid
  } else {
    metaframes <- meta_frames(url_or_tableid, url_type)
  }
  
  if (!length(metaframes)) {
    return(NULL)
  }
  
  url <- comment(metaframes)
  
  if (!length(url)) {
    message("No url found")
    return(NULL)
  }
  
  dots <- list(...)
  
  vars <- names(dots)
  if (!all(vars %in% names(metaframes))) {
    stop(paste("Allowed variables:", paste(names(metaframes), collapse = ", ")))
  }
  
  vars_default <- setdiff(names(metaframes), vars)
  if (length(vars_default)) {
    dots_default <- setNames(rep(list(default_query), length(vars_default)), vars_default)
    dots <- c(dots, dots_default)
    vars <- names(dots)
  }
  
  for (i in seq_along(dots)) {
    if (is.list(dots[[i]])) {
      namesi <- names(dots[[i]])
      if (is.null(namesi)) {
        namesi <- rep(NA, length(dots[[i]]))
      }
      namesi[namesi == ""] <- NA
      s <- NULL
      for (j in seq_along(dots[[i]])) {
        if (is.na(namesi[j])) {
          b <- query_part(vars[i], selection = dots[[i]], metaframe = metaframes[[vars[i]]], use_index = use_index)
        } else {
          b <- q1(vars[i], paste(dots[[i]][[j]], collapse = ","), parameter = namesi[j])
        }
        if (length(s)) {
          s <- paste(s, b, sep = "&")
        } else {
          s <- b
        }
      }
    } else {
      s <- query_part(vars[i], selection = dots[[i]], metaframe = metaframes[[vars[i]]], use_index = use_index)
    }
    if (length(s)) {
      url <- paste(url, s, sep = "&")
    }
  }
  url
}



query_part <- function(variable_id, selection, metaframe, use_index = FALSE) {
  
  if (is.logical(selection)) {
    if (!selection) {
      return(NULL)
    } else {
      return(q1(variable_id, "*"))
    }
  }
  if (is.complex(selection)) {
    return(q1(variable_id, paste0("top(", Im(selection), ")")))
  }
  if (is.numeric(selection)) {
    encode <- TRUE
    values <- as.integer(selection)
    if (use_index) {
      ma <- match(values, as.integer(metaframe$index))
      if (anyNA(ma)) {
        warning(paste0(variable_id, ": Could not match all indexes"))
      }
      ma <- ma[!is.na(ma)]
      if (!length(ma)) {
        stop(paste0(variable_id, ": no indexes in valid range"))
      }
      codes <- metaframe$code[ma]
    } else {
      nx <- nrow(metaframe)  # Base on copy from code for ApiData()
      
      if(any(values == 0)){
        stop(paste0(variable_id, ": 0-index found. Use use_index = TRUE?"))
      }
      
      values <- values[abs(values) > 0 & abs(values) <= nx]  # Fix outside range
      values[values < 0] <- rev(seq_len(nx))[-values[values < 0]]  # Fix negative
      values <- unique(values)
      if (!length(values)) {
        stop(paste0(variable_id, ": no indices in valid range"))
      }
      codes <- metaframe$code[values]
    }
  } else {
    encode <- NA
    # Currently no error from checking against metadata due to special possibilities. 
    # E.g. "??"
    # Then one can also write "*" and "top(2)" directly
    no_match <- !(selection %in% metaframe$code)
    if (any(no_match)) {
      ma <- match(selection[no_match], metaframe$label)
      if(any(!is.na(ma))){
        labels_to_code <- metaframe$code[ma[!is.na(ma)]]
        no_match[no_match][is.na(ma)] <- FALSE
        selection <- unique(c(selection[!no_match],  labels_to_code))
      }
    } 
    codes <- selection
  }
  return(q1(variable_id, paste(codes, collapse = ","), encode = encode))
}


# NOTE:
# Query values may be ordinary codes (e.g. "03+04") or API expressions
# (e.g. "03*", "??", "top(3)"). URL encoding is therefore optional and
# can be applied per element when encode = NA (auto).
# Written with help from ChatGPT.
q1 <- function(variable_id, s, parameter = "valueCodes", encode = FALSE) {
  s <- as.character(s)
  
  if (is.na(encode)) {
    # Auto per element: keep expressions, encode ordinary codes
    is_expr <- grepl("[*?]", s) | grepl("^top\\([0-9]+\\)$", s) | s == "*"
    s[!is_expr] <- utils::URLencode(s[!is_expr], reserved = TRUE)
  } else if (isTRUE(encode)) {
    # Encode all
    s <- utils::URLencode(s, reserved = TRUE)
  } else {
    # encode == FALSE: keep as-is
  }
  
  paste0(parameter, "[", variable_id, "]=", paste(s, collapse = ","))
}


