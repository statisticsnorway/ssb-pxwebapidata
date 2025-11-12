
#' Extract info or note parts of the comment attribute
#'
#' The functions `info()` and `note()` provide access to
#' different parts of an object's comment attribute,
#' which is accessed by `comment()`.
#'
#' The `comment` attribute is assumed to be derived from JSON-stat2 metadata, 
#' where some elements originate from text in a *note* field.
#' 
#' The `comment` attribute of data downloaded by the package is
#' constructed by  
#'              `c(unlist(obj[c("label", "source", "updated")]),` 
#'                `unlist(obj$extension$px[c("tableid", "contents")]),`
#'                `unlist(obj["note"]))`
#'                
#' where `obj` is a list containing the JSON-stat2 metadata. 
#' Thus, possible none-existing elements are ignored.                  
#'
#' @param x Object with a `comment` attribute.
#'
#' @returns
#' - `note()` returns all elements in the `comment` attribute that originate from
#'   the *note* field. The `"note"` name is then removed.
#' - `info()` returns the remaining elements in the `comment` attribute.
#'
#' @export
info <- function(x) {
  cm <- comment(x)
  if (!length(cm)) {
    return(cm)
  }
  cm[!is_note(cm)]
}


#' @rdname info
#' @export
note <- function(x) {
  cm <- comment(x)
  if (!length(cm)) {
    return(cm)
  }
  change_note_name(cm[is_note(cm)])
}


is_note <- function(x) {
  grepl("^note($|[0-9._-])", names(x))
}

change_note_name <- function(x) {
  names(x)[grepl("^note($|[0-9])", names(x))] <- ""
  names(x) <- sub("^note($|[0-9._-])", "", names(x))
  if (identical(unique(names(x)), ""))
    names(x) <- NULL
  x
}
