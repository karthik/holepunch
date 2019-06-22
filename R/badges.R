


#' Generates a Binder badge to add to your README
#'
#' @template hub
#' @template urlpath
#' @param path Assumes local folder unless you say otherwise
#'
#' @export
#' @importFrom gh gh_tree_remote
#' @importFrom usethis use_badge
#'
#' @examples
#' # generate_badge("/path/to/repo")
generate_badge <-
  function(path  = ".",
           hub = "mybinder.org",
           urlpath = "rstudio") {
    
    if (is.list(gh::gh_tree_remote(path))) {
      user <- gh_tree_remote(path)$username
      repo <- gh_tree_remote(path)$repo
      url <-
        glue("https://{hub}/v2/gh/{user}/{repo}/master?urlpath={urlpath}")
      img <- glue("http://{hub}/badge.svg")
      use_badge("Launch Rstudio Binder", url, img)
    }
    
    invisible(TRUE)
  }
