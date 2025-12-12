#' Convert a list of records to a data.frame
#'
#' Converts a list where each element represents a record (row) into a
#' \code{data.frame}. Missing fields are filled with \code{NA}.
#'
#' List-valued fields are flattened by collapsing their contents into a single
#' character value. This guarantees that the returned data frame contains no
#' list columns, but nested structure is not preserved.
#'
#' @param x
#'   A list of records. Each record should be a named list or similar structure.
#'   Records may have different sets of fields.
#'
#' @return
#' A \code{data.frame} with one row per record and columns corresponding to the
#' union of all field names.
#'
#' @details
#' This function is intended for row-oriented data structures, such as JSON
#' arrays of objects.
#'
#' @note
#' This function is written and documented with help from ChatGPT.
#'
#' @examples
#' x <- list(
#'   list(id = 1, name = "Ada", tags = list("a", "b")),
#'   list(id = 2, name = "Bo"),
#'   list(id = 3, name = "Cy", tags = list("x"))
#' )
#'
#' list_records_to_df(x)
#'
#' @export
list_records_to_df <- function(x) {
  rows <- lapply(x, function(item) {
    flat <- lapply(item, function(v) {
      if (is.list(v)) paste(unlist(v), collapse = ", ") else v
    })
    as.data.frame(flat)
  })
  
  all_names <- unique(unlist(lapply(rows, names)))
  
  rows2 <- lapply(rows, function(d) {
    missing <- setdiff(all_names, names(d))
    for (m in missing) d[[m]] <- NA
    d[all_names]
  })
  
  df <- do.call(rbind, rows2)
  rownames(df) <- NULL
  df
}
