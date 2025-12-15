#' Create a data.frame from a structured list
#'
#' Converts a structured, column-oriented list into a flat
#' \code{data.frame}, using the first element of the list to define the expected
#' structure (length and names).
#'
#' Only elements matching the structure of the first element are included in
#' the result. Other elements are excluded. Optionally, excluded elements can
#' be stored unchanged as an attribute.
#'
#' Nested lists or multi-element vectors are expanded into multiple columns so
#' that the returned data frame never contains list columns.
#'
#' @param x
#'   A named list. Each element is expected to have the same length and names
#'   as the first element.
#'
#' @param category_col
#'   Name of the column containing category labels.
#'   If \code{NULL}, no category column is added and category labels are used
#'   as row names instead.
#'
#' @param dropped_attr
#'   Name of the attribute used to store excluded elements (stored unchanged).
#'   If \code{NULL}, no such attribute is added.
#'
#' @return
#' A \code{data.frame} with one row per category and one or more columns per
#' retained list element.
#'
#' @details
#' This function is intended for column-oriented or table-like list structures,
#' such as those commonly found in JSON metadata or dimension specifications.
#'
#' @note
#' This function is written and documented with help from ChatGPT.
#' 
#' @importFrom stats setNames
#'
#' @examples
#' x <- list(
#'   A = c(a = 1, b = 2, c = 3),
#'   B = list(
#'     a = c(x = 10, y = 20),
#'     b = c(x = 11, y = 21),
#'     c = c(x = 12, y = 22)
#'   ),
#'   bad = c(a = 1, b = 2)  # wrong length -> excluded
#' )
#'
#' df <- list_to_df_expand(x)
#' df
#'
#' attr(df, "dropped")
#'
#' # Use row names instead of a category column:
#' df2 <- list_to_df_expand(x, category_col = NULL)
#' df2
#'
#' # Disable storing excluded elements:
#' df3 <- list_to_df_expand(x, dropped_attr = NULL)
#' df3
#'
#' @export
list_to_df_expand <- function(x, category_col = "category", dropped_attr = "dropped") {
  if (!is.list(x)) stop("Input must be a list.")
  if (length(x) == 0) return(data.frame())
  if (is.null(names(x))) stop("Top-level list must be named.")
  
  exp_len   <- length(x[[1]])
  exp_names <- names(x[[1]])
  
  sig_of <- function(nm) if (is.null(nm)) "" else paste(nm, collapse = "\r")
  
  lens <- vapply(x, length, integer(1))
  sigs <- vapply(lapply(x, names), sig_of, character(1))
  exp_sig <- sig_of(exp_names)
  
  idx_len_ok <- which(lens == exp_len)
  keep <- idx_len_ok[sigs[idx_len_ok] == exp_sig]
  
  dropped_idx <- setdiff(seq_along(x), keep)
  dropped <- if (length(dropped_idx)) x[dropped_idx] else list()
  
  cats <- if (!is.null(exp_names)) exp_names else as.character(seq_len(exp_len))
  
  # Initialize output (FIXED for category_col = NULL)
  if (!is.null(category_col)) {
    out <- data.frame(setNames(list(cats), category_col))
  } else {
    out <- data.frame(row.names = cats)  # <-- this creates n rows, 0 columns
  }
  
  if (length(keep) == 0) {
    if (!is.null(dropped_attr)) attr(out, dropped_attr) <- dropped
    return(out)
  }
  
  reorder_by_cats <- function(vec_like) {
    nm <- names(vec_like)
    if (is.null(exp_names) && is.null(nm)) vec_like else vec_like[cats]
  }
  
  for (col_name in names(x[keep])) {
    col <- reorder_by_cats(x[[col_name]])
    
    row_vals <- lapply(col, function(v) {
      if (is.null(v)) return(NA)
      if (is.list(v)) {
        v2 <- unlist(v, recursive = TRUE, use.names = TRUE)
        if (length(v2) == 0) return(NA)
        return(v2)
      }
      if (is.atomic(v)) {
        if (length(v) == 0) return(NA)
        return(v)
      }
      as.character(v)
    })
    
    max_len <- max(vapply(row_vals, length, integer(1)), na.rm = TRUE)
    
    subnames_list <- lapply(row_vals, names)
    all_named <- all(vapply(subnames_list, function(sn) !is.null(sn), logical(1)))
    chosen_subnames <- NULL
    if (all_named) {
      subsig <- vapply(subnames_list, function(sn) paste(sn, collapse = "\r"), character(1))
      cand <- names(sort(table(subsig), decreasing = TRUE))[1]
      cand_names <- if (nzchar(cand)) strsplit(cand, "\r", fixed = TRUE)[[1]] else NULL
      if (!is.null(cand_names) && length(unique(cand_names)) == length(cand_names)) {
        chosen_subnames <- cand_names
      }
    }
    
    if (max_len <= 1) {
      out[[col_name]] <- vapply(row_vals, function(v) {
        if (length(v) == 1) as.character(v)
        else if (length(v) == 0) NA_character_
        else as.character(v[1])
      }, character(1))
    } else {
      new_names <- if (!is.null(chosen_subnames) && length(chosen_subnames) == max_len) {
        paste0(col_name, ".", chosen_subnames)
      } else {
        paste0(col_name, "_", seq_len(max_len))
      }
      for (j in seq_len(max_len)) {
        out[[new_names[j]]] <- vapply(row_vals, function(v) {
          if (length(v) >= j) as.character(v[j]) else NA_character_
        }, character(1))
      }
    }
  }
  
  if (any(vapply(out, is.list, logical(1))))
    stop("Internal error: a list column survived.")
  
  if (!is.null(dropped_attr)) attr(out, dropped_attr) <- dropped
  out
}
