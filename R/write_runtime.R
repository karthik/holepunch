


#' Write runtime.txt
#'
#' @param dt Date you need R to lock down to
#' @importFrom lubridate ymd today
#'
#' @export
#'
#' @examples
write_runtime <- function(dt = ymd(today())) {
  txt <- paste0("r-", dt)
  fileConn <- file("runtime.txt")
  writeLines(txt, fileConn)
  close(fileConn)
}