

#' Generates a Binder badge to add to your README
#'
#' @param hub The binder hub you wish to use. The default is mybinder but you can also try Pangeo
#' @param urlpath For R users we recommend the default Rstudio. If you wish to use vanilla Jupyter, leave this blank.
#' @param path Assumes local folder unless you say otherwise
#'
#' @export
#' @importFrom gh gh_tree_remote
#' @importFrom usethis use_badge
#'
#' @examples 
#' # generate_badge("/path/to/repo")
generate_badge <-  function(path  = ".", hub = "mybinder.org", urlpath = "rstudio") {
  if (is.list(gh::gh_tree_remote(path))) {
    user <- gh_tree_remote(path)$username
    repo <- gh_tree_remote(path)$repo
    url <-
      glue("https://{hub}/v2/gh/",
           user,
           "/",
           repo,
           "/master?urlpath={urlpath}")
      # TODO: mybinder is hard coded. Must fix.
    img <- glue("http://{hub}/badge.svg")
    use_badge("Launch Rstudio binder", url, img)
  }
  
  invisible(TRUE)
}

# TODO
# Give users the option to choose either a Rstudio server or a vanilla Jupyter