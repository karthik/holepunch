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
  sort(unique(packages$Package))
}

# WIP
#' @noRd
get_remotes <- function(x) {
  
  
  # TO-FIX
  # Using an internal function here
  # A silly hack from Yihui to stop the internal function use warning.
  # Not sure this is a good thing to do, but for now YOLO.
  # %:::% is in zzz.R
  
  package2remote <- "remotes" %:::% "package2remote"
  res <- NULL
  rem <- lapply(x, package2remote)
  z <- lengths(rem)
  remote_packages <- rem[which(z > 4)]
  if (is.list(remote_packages) && length(remote_packages) > 0) {
    github_packages <-
      data.frame(matrix(unlist(remote_packages), nrow=length(remote_packages), byrow = T))
    names(github_packages) <- c("api", "repo", "user", "branch", "hash")
    
    res <- as.character(apply(github_packages, 1, function(x) {
      paste0(x[["user"]], "/", x[["repo"]])
    }))
  }
  res
}
