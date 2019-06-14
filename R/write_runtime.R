



#' Write runtime.txt
#'
#' @param dt Date you need R to lock down to
#' @importFrom lubridate ymd today
#'
#' @export
#'
write_runtime <- function(dt = lubridate::ymd(lubridate::today())) {
  
  if (fs::file_exists(".binder/Dockerfile")) {
    cliapp::cli_alert_warning(
      "A Dockerfile exists in .binder/. This means that all other settings (runtime.txt and install.R will be ignored. Consider deleting the Dockerfile if you wish to take the runtime approach"
    )
  }
  
  txt <- paste0("r-", dt)
  fs::dir_create(".binder")
  fileConn <- file(".binder/runtime.txt")
  writeLines(txt, fileConn)
  close(fileConn)
}



