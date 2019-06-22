#' Write runtime.txt
#'
#' @param path Path to project
#' @template r_date
#' @importFrom lubridate ymd today
#'
#' @export
#'
write_runtime <-
  function(path = ".",
             r_date = lubridate::ymd(lubridate::today())) {
    path <- sanitize_path(path) # To kill trailing slashes
    if (fs::file_exists(glue("{path}/.binder/Dockerfile"))) {
      warning(
        glue(
          "A Dockerfile exists in {path}/.binder/. This means that all other 
          settings (runtime.txt and install.R) will be ignored. Consider 
          deleting the Dockerfile if you wish to take the runtime approach"
        )
      )
    }

    txt <- paste0("r-", r_date)
    fs::dir_create(glue("{path}/.binder"))
    fileConn <- file(glue("{path}/.binder/runtime.txt"))
    writeLines(txt, fileConn)
    close(fileConn)
  }
