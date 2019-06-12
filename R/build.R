
#' Builds binder
#'
#' @param path path to local git controlled folder
#'
#' @importFrom httr GET content
#' @export
#'
build_binder <- function(path = ".") {
  user <- gh_tree_remote(path)$username
  repo <- gh_tree_remote(path)$repo
  binder_runtime <- paste0("https://mybinder.org/build/gh/", user, "/", repo, "/master")
  binder_runtime
  res <- httr::GET(binder_runtime)
  parse_streamer(url = binder_runtime)
  message("This may take a while but you can kill this process and the build will still continue")
  return(binder_runtime)
}

#' @noRd
#' @importFrom jsonlite fromJSON
#' @importFrom curl curl
#' @keywords internal
parse_streamer <- function(url, cb = print){
  # Many thanks to Jeroem Ooms for this parser!
  con <- curl::curl(url = url)
  open(con)
  on.exit(close(con))
  repeat{
    txt <- readLines(con, 1)
    if(!length(txt)){
      print("All done!")
      cb(NULL)
      break;
    }
    if(grepl("^data:", txt)){
      json <- sub("^data:", "", txt)
      data <- jsonlite::fromJSON(json)
      cb(data)
    }
  }
}