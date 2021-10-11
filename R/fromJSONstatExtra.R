
fromJSONstatExtra <- function(x, ..., makeNAstatus = TRUE) {
  z <- rjstat::fromJSONstat(x = x, ...)
  if (!makeNAstatus) {
    return(z)
  }
  status <- MakeNAstatus(x, as.vector(z[[1]]$value))
  if (!is.null(status)) {
    z[[1]]$NAstatus <- status
  }
  z
}


MakeNAstatus <- function(post, values) {
  
  is_na_values <- is.na(values)
  
  if (!any(is_na_values)) {
    return(NULL)
  }
  
  k <- jsonlite::fromJSON(post)
  
  status <- unlist(k$dataset$status)
  
  # No warning when NULL 
  if(is.null(status)){
    return(NULL)
  }
  
  # Message instead of warning since inside Graceful 
  warningHere <- message
  
  wtxt <- "Could not capture status"
  
  x <- as.vector(unlist(k$dataset$value))
  
  if (!identical(x, values)) {
    warningHere(wtxt)
    return(NULL)
  }
  
  if (is.null(names(status))) {
    if (length(status) == length(values)) {
      return(status)
    }
    warningHere(wtxt)
    return(NULL)
  }
  
  statusAll <- rep(NA_character_, length(values))
  
  statusAll[1L + as.integer(names(status))] <- status
  
  return(statusAll)
  
}