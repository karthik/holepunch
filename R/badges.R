
#' Title
#'
#' @return
#' @export
#' @importFrom usethis uses_github
#'
#' @examples
generate_badge <-  function() {
  
  if (uses_github()) {
    url <- glue("https://mybinder.org/v2/gh/{github_repo_spec()}/master?urlpath=rstudio")
    img <- "http://mybinder.org/badge.svg"
    use_badge("Launch Rstudio binder", url, img)
  }
  
  invisible(TRUE)
}