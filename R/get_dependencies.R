#' Pulls out R dependencies from a folder.
#'
#' @param path Path to search
#' @importFrom fs dir_ls
#' @importFrom renv dependencies
#'
#' @export
get_dependencies <- function(path = ".") {
  # Check to see path is valid
  path <- sanitize_path(path)
  packages <- renv::dependencies(path)
  packages$Package
}