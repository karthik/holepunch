#' Write runtime.txt
#'
#' @param path Path to project
#' @param r_date Date you need R to lock down to. By default it picks the most
#'   recent date a file was touched in this project but you can override this by
#'   specifying this explicitly. Date must be in ISO 8601 format.
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
          "A Dockerfile exists in {path}/.binder/. This means that all other settings (runtime.txt and install.R will be ignored. Consider deleting the Dockerfile if you wish to take the runtime approach"
        )
      )
    }
    
    txt <- paste0("r-", r_date)
    fs::dir_create(glue("{path}/.binder"))
    fileConn <- file(glue("{path}/.binder/runtime.txt"))
    writeLines(txt, fileConn)
    close(fileConn)
  }
