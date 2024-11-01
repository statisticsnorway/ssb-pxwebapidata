
fromJSONstatExtra <- function(x, naming, ..., makeNAstatus = TRUE) {
  
  z <- rjstat::fromJSONstat(x = x, naming = naming, ...)
  
  
  in_dataset <- !inherits(z, "data.frame")  # both 'json-stat' and 'json-stat2' will work 
  
  special <- SpecialFromJSON(x, in_dataset)
  
  if (!in_dataset) {      # Recreate json-stat output from json-stat2
    z <- list(dataset = z)
    if (naming == "label") {
      names(z) <- special[["label"]]
    }
  }
  
  # new comment attribute
  comment(z[[1]]) <- c(unlist(special[c("label", "source", "updated")]), 
                       unlist(special$extension$px[c("tableid", "contents")]))
  
  
  if (!makeNAstatus) {
    return(z)
  }
  
  status <- MakeNAstatus(special, as.vector(z[[1]]$value))
  if (!is.null(status)) {
    z[[1]]$NAstatus <- status
  }
  
  z
}


SpecialFromJSON <- function(post, in_dataset = TRUE) {
  k <- jsonlite::fromJSON(post)
  if (in_dataset) {
    return(k$dataset)
  }
  k
}


MakeNAstatus <- function(special, values) {
  
  is_na_values <- is.na(values)
  
  if (!any(is_na_values)) {
    return(NULL)
  }
  
  #k <- jsonlite::fromJSON(post)
  
  status <- unlist(special$status)
  
  # No warning when NULL 
  if(is.null(status)){
    return(NULL)
  }
  
  # Message instead of warning since inside Graceful 
  warningHere <- message
  
  wtxt <- "Could not capture status"
  
  x <- unlist(special$value)
  
  if(!is.null(names(x))){               # Eurostat data is like this
    x <- FullLength(x, length(values))
  } else {
    x <- as.vector(x)
  }
  
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


FullLength <- function(x, length_x) {
  x_NA <- as.vector(x[1])
  x_NA[] <- NA
  x_NA  # single NA with same class as x and no name
  a <- rep(x_NA, length_x)
  a[1L + as.integer(names(x))] <- x
  a
}



