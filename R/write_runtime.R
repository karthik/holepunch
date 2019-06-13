


#' Write runtime.txt
#'
#' @param dt Date you need R to lock down to
#' @importFrom lubridate ymd today
#'
#' @export
#'
write_runtime <- function(dt = lubridate::ymd(lubridate::today())) {
  txt <- paste0("r-", dt)
  fs::dir_create(".binder")
  fileConn <- file(".binder/runtime.txt")
  writeLines(txt, fileConn)
  close(fileConn)
}