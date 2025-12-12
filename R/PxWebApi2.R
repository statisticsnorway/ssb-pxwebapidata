
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