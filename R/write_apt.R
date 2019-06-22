



#' Write a lsit of apt packages
#'
#' Writes a list of Debian packages that should be installed.  Caution: If you have a Dockerfile,
#' this file will be ignored.
#'
#'@param path Path to project
#'@param apt_input A list of Debian packages that should be installed. The base
#'  image used is usually the latest released version of Ubuntu.
#'
#'@export
#' @examples
#' write_apt(path = ".",
#' apt_input = "
#' texlive-latex-base
#' texlive-latex-recommended
#' texlive-science
#' texlive-latex-extra
#' texlive-fonts-recommended
#' dvipng
#' ghostscript")
write_apt <- function(path = ".", apt_input = NULL) {
  if (!is.null(apt_input)) {
    fs::dir_create(glue::glue("{path}/.binder"))
    fileConn <- file(glue::glue("{path}/.binder/apt.txt"))
    writeLines(apt_input, fileConn)
    close(fileConn)
  }
}
