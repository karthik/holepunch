

#' Generates a Binder badge to add to your README
#'
#' @param path Assumes local folder unless you say otherwise
#' @export
#' @importFrom gh gh_tree_remote
#' @importFrom usethis use_badge
#'
#' @examples 
#' # generate_badge("/path/to/repo")
generate_badge <-  function(path  = ".") {
  if (is.list(gh::gh_tree_remote(path))) {
    user <- gh_tree_remote(path)$username
    repo <- gh_tree_remote(path)$repo
    url <-
      glue("https://mybinder.org/v2/gh/",
           user,
           "/",
           repo,
           "/master?urlpath=rstudio")
    img <- "http://mybinder.org/badge.svg"
    use_badge("Launch Rstudio binder", url, img)
  }
  
  invisible(TRUE)
}

# TODO
# Give users the option to choose either a Rstudio server or a vanilla Jupyter