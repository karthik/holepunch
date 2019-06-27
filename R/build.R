#' Builds binder
#'
#' This function kicks off the image build on Mybinder.org. Although it is not
#' entirely necessary to run this step, doing so will ensure that there is a
#' built image on binder ready to launch. Otherwise the first time (or if your
#' binder is infrequently used), the build can take a long time.
#' @param path path to local git controlled folder
#' @template hub
#' @template urlpath
#'
#' @importFrom httr GET content
#' @importFrom cliapp cli_alert_warning
binder_builder <-
  function(path = ".",
           hub = "mybinder.org",
           urlpath = "rstudio") {
    path <- sanitize_path(path)
    if (!has_a_git_remote()) {
      stop(
        "Cannot build without the project having a Git remote. Please connec this to a public repository on GitHub"
      )
    }
    user <- gh_tree_remote(path)$username
    repo <- gh_tree_remote(path)$repo
    # nocov start
    binder_runtime <-
      glue::glue("https://{hub}/build/gh/{user}/{repo}/master")
    res <- httr::GET(binder_runtime)
    url <-
      glue("https://{hub}/v2/gh/{user}/{repo}/master?urlpath={urlpath}")
    return(url)
    # nocov end
  }


#' Builds binder in the background (recommended over calling `binder_builder` directly)
#'
#' This function builds binder in the background and once an image is ready,
#' will open the Binder URL. You are feel to kill this process anytime and the build
#' still continue on the server.
#' @param path path to local Git controlled folder
#' @template hub
#' @template urlpath
#' @export
build_binder <-
  function(path = ".",
           hub = "mybinder.org",
           urlpath = "rstudio") {
    if (!is_clean(path)) {
      stop(
        "Please commmit and push files to GitHub before building binder. Otherwise Binder cannot see these new files/changes",
        call. = FALSE
      )
    }
    
    
    cliapp::cli_alert_info(
      glue::glue(
        "Your Binder is being built in the background. Once built, your browser will automatically launch. You can also click the binder badge on your README at any time."
      )
    )
    # nocov start
    `%...>%` <- promises::`%...>%` 
    binder_plan <- plan("list")
    on.exit(plan(binder_plan))
    multisession <- "future" %:::% "multisession"
    future::plan(multisession, workers = 2)
    
    future::future({
      binder_builder(path, hub, urlpath)
    }) %...>% utils::browseURL
    # nocov end
  }
