

#' Last Modified late
#'
#' Returns the latest date for when a file was touched in a project
#' @param path Path to project folder
#'
last_modification_date <- function(path = ".") {
  dir_list <- fs::dir_info(path)
  sorted_dir_list <- dir_list[order(dir_list$modification_time, decreasing  = TRUE), ]
  last_mod <- sorted_dir_list[1, ]$modification_time
  as.Date(last_mod)
}
 
#' @noRd
r_version_lookup <- function(date = NULL) {
  if(!is.null(date)) {
    
    date <- as.Date(date)
    df <- holepunch:::r_version_table
    
    if(date < df[1, 2]) {
        stop("Canot find R version for this date", call. = FALSE)
    }
   
    # browser()
    df$dt <- date
    df$status <- apply(df, 1, function(x) { (x[["dt"]] > x[["start"]] & x[["dt"]] < x[["end"]]) })
    ver <- df[which(df$status == TRUE), ]$version
    ver
  } else {
    "latest"
  }
}

