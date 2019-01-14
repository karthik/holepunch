appDependencies <- getFromNamespace("appDependencies", "packrat")


#' Get project dependencies
#'
#' @param dir Root directory to search from
#'
#' @return vector
#' @importFrom  packrat status 
#' @importFrom glue glue
#' @importFrom utils getFromNamespace
#' @export
#'
get_dependencies <- function(dir = ".") {
  appDependencies <- packrat:::appDependencies
used_pkgs <- appDependencies(dir)
pkgs <- unlist(used_pkgs)
pkgs <- pkgs[order(pkgs)]
paste0(pkgs, collapse = ",")
}

# TODO: I am just importing something from packat for the sake of importing
# What I really need is the internal function called appDependencies