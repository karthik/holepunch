
#' Write a install.R
#'
#' @param path Path to project
#'
#' @export
#'
write_install <- function(path = ".") {
  packages <- get_dependencies(path)
  res <- lapply(packages, function(x) glue::glue("install.packages('", x, "')"))
  usethis::write_over(usethis::proj_path("install.R"), unlist(res))
}