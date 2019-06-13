

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
 