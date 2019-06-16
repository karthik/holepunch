


#' Generates a Binder badge to add to your README
#'
#' @template hub
#' @param urlpath For R users we recommend the default Rstudio. If you wish to use vanilla Jupyter, leave this blank.
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
    
    # TODO: Not doing anything with the path var here. Do I still need it?
    
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
