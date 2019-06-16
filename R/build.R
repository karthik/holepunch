#' Builds binder
#'
#' This function kicks off the image build on binder. Although it is not
#' entirely necessary to run this step, doing so will ensure that there is a
#' built image on binder ready to launch. Otherwise the first time (or if your
#' binder is infrequently used), the build can take a long time.
#' @param path path to local git controlled folder
#' @template hub
#'
#' @importFrom httr GET content
#' @importFrom cliapp cli_alert_warning
#' @export
build_binder <- function(path = ".", hub = "mybinder.org") {
  # TODO ------
  # I need to check if there are uncommitted files in the repo
  # and prompt the user to commit + push before launching the build.
  # What is an elegant way to do this without piling on more dependencies?
  # ----
  
  path <- sanitize_path(path)
  cliapp::cli_alert_warning("This may take a while but you can kill this process and the build will still continue")
  user <- gh_tree_remote(path)$username
  repo <- gh_tree_remote(path)$repo
  # binder_runtime <- paste0("https://mybinder.org/build/gh/", user, "/", repo, "/master")
  binder_runtime <-
    glue::glue("https://{hub}/build/gh/{user}/{repo}/master")
  cliapp::cli_alert_info(glue::glue("Building binder at {binder_runtime}"))
  res <- httr::GET(binder_runtime)
  parse_streamer(
    url = binder_runtime
  )
  return(binder_runtime)
}

#' @noRd
#' @importFrom jsonlite fromJSON
#' @importFrom curl curl
#' @keywords internal
parse_streamer <-
  function(url,
           cb = print,
           hub = "mybinder.org",
           urlpath = "rstudio") {
    # Many thanks to Jeroem Ooms for this parser!
    con <- curl::curl(url = url)
    open(con)
    on.exit(close(con))
    repeat {
      txt <- readLines(con, 1)
      if (!length(txt)) {
        print("All done!")
        cb(NULL)
        break
        
      }
      if (grepl("^data:", txt)) {
        json <- sub("^data:", "", txt)
        data <- jsonlite::fromJSON(json)
        cb(data)
      }
    }
    badge_url <- gsub("https://mybinder.org/build/gh/", "", url)
    full_badge_url <-
      glue::glue("https://{hub}/v2/gh/{badge_url}/?urlpath={urlpath}")
    utils::browseURL(full_badge_url)
  }