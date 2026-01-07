#' Ensure JSON-stat2 output format in PxWebApi v2 URLs
#'
#' Ensures that a PxWebApi v2 URL requests data in JSON-stat2 format by enforcing
#' \code{outputFormat=json-stat2}.
#'
#' The function behaves as follows:
#' \itemize{
#'   \item If the URL already contains \code{outputFormat=json-stat2}, it is
#'         returned unchanged.
#'   \item If the URL contains an \code{outputFormat} parameter with another
#'         value (e.g. \code{csv}), only the value is replaced by
#'         \code{json-stat2}, leaving the rest of the URL unchanged.
#'   \item If the URL does not contain any \code{outputFormat} parameter,
#'         \code{outputFormat=json-stat2} is appended.
#' }
#'
#' Matching of parameter names and values is case-insensitive, but the resulting
#' URL always uses the canonical camelCase form
#' \code{outputFormat=json-stat2}.
#'
#' This function is intended for internal use to guarantee a consistent and
#' standardized output format across different PxWebApi v2 providers.
#'
#' @param url A character string of length one giving a PxWebApi v2 data URL.
#'
#' @return A character string with \code{outputFormat=json-stat2} enforced.
#'
#' @note
#' This function is written and documented with help from ChatGPT.
#'
#' @keywords internal
#'
#' @export
#'
#' @examples
#' url1 <- "https://api.no/data?lang=en"
#' url1
#' ensure_json_stat2(url1)
#'
#' url2 <- paste0(url1, "&valueCodes[Tid]=top(2)")
#' url2
#' ensure_json_stat2(url2)
#'
#' url3 <- paste0(url1, "&outputFormat=csv&valueCodes[Tid]=?")
#' url3
#' ensure_json_stat2(url3)
ensure_json_stat2 <- function(url) {
  
  if (!length(url)) {
    message("Empty URL")
    return(url)
  }
  
  stopifnot(is.character(url), length(url) == 1L)
  
  # Early return: already correct
  if (grepl("outputFormat\\s*=\\s*json-stat2", url, ignore.case = TRUE)) {
    return(url)
  }
  
  # outputFormat present -> replace value only
  if (grepl("outputformat\\s*=", url, ignore.case = TRUE)) {
    return(sub(
      "(?i)(outputformat\\s*=)\\s*[^&]*",
      "\\1json-stat2",
      url,
      perl = TRUE
    ))
  }
  
  # outputFormat not present -> append
  sep <- if (grepl("\\?", url)) "&" else "?"
  paste0(url, sep, "outputFormat=json-stat2")
}

