

#' Write a install.R
#'
#' This function writes a list of packages to install one per line in the form of `install.package('package_name')`
#' @param path Path to project
#' @importFrom usethis write_over
#' @export
#'
write_install <- function(path = ".") {
  if (fs::file_exists(".binder/Dockerfile")) {
    warning(
      "A Dockerfile exists in .binder/. This means that all other settings (runtime.txt and install.R will be ignored. Consider deleting the Dockerfile if you wish to take the runtime approach"
    )
  }
  path <- sanitize_path(path) # To kill trailing slashes
  packages <- get_dependencies(path)
  res <-
    lapply(packages, function(x)
      glue::glue("install.packages('", x, "')"))
  fs::dir_create(glue("{path}/.binder"))
  usethis::write_over(glue("{path}/.binder/install.R"), unlist(res))
}
