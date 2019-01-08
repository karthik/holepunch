appDependencies <- getFromNamespace("appDependencies", "packrat")


#' Get project dependencies
#'
#' @param dir Root directory to search from
#'
#' @return vector
#' @impor packrat 
#' @importFrom glue glue
#' @importFrom utils getFromNamespace
#' @export
#'
#' @examples
get_dependencies <- function(dir = ".") {
used_pkgs <- appDependencies(dir)
# install_p <- function(x) { glue::glue("install.packages('", x, "')")}
# z <- lapply(used_pkgs, install_p) %>% unlist
unlist(used_pkgs)
}
