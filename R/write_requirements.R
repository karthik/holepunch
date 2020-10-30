




#' Write a list of Python requirements
#'
#' Writes a list of Python packages that should be installed. Caution: If you have a Dockerfile,
#' this file will be ignored.
#'
#' @param path Path to project
#' @param requirements A list of Python packages that should be installed in your environment.
#'
#' @export
#' @examples
#' write_requirements(
#'   path = ".",
#'   requirements = "
#' numpy==1.16.*
#' matplotlib==3.*
#' seaborn==0.8.1
#' "
#' )
write_requirements <- function(path = ".",
                               requirements = NULL) {
  if (!is.null(requirements)) {
    fs::dir_create(glue::glue("{path}/.binder"))
    fileConn <- file(glue::glue("{path}/.binder/requirements.txt"))
    writeLines(requirements, fileConn)
    close(fileConn)
  }
}
