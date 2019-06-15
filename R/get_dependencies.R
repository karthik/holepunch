#' Pulls out R dependencies from a folder.
#'
#' @param path Path to search
#' @importFrom fs dir_ls
#' @importFrom requirements req_file
#'
#' @export
get_dependencies <- function(path = ".") {
  # Check to see path is valid
  files <- fs::dir_ls(path, recurse = TRUE)
  packages <- lapply(files, requirements::req_file)
  package_list <- unique(as.character(unname(unlist(packages))))
  package_list
}