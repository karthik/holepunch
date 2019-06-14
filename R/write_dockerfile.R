



#' Write a minimal Dockerfile for a binder
#'
#' @param base Rocker base
#' @param maintainer Maintainer of the Dockerfile
#' @param r_version  Version of R you wish to use. Will default to latest for now.
#' @param path path to binder repo
#'
#' @importFrom glue glue
#' @export
#'
write_dockerfile <-
  function(base = NULL,
           path = ".",
           maintainer = "karthik",
           r_version = "latest")
  {
    user <- gh::gh_tree_remote(path)$username
    repo <- gh::gh_tree_remote(path)$repo
    
    # TODO
    # -------------
    # IF base is null and r_version = latest, then make FROM
    # rocker/binder:latest If base is set, use that base and latest date a file
    # was touched If base is NULL and r_version = a date, use R version for that
    # date (from look up table) and same date for packages
    
    # -------------
    
    R_VERSION = r_version # TODO: This needs to be a function that returns R-version for a given date
    DATE = last_modification_date(".")
    MAINTAINER = maintainer
    
    glue::glue(
      "
FROM rocker/binder:[R_VERSION]
LABEL maintainer='[MAINTAINER]'
USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}
USER ${NB_USER}
RUN wget https://github.com/[user]/[repo]/raw/master/DESCRIPTION && R -e \"options(repos = list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/[DATE]/')); devtools::install_deps()\"
",
      .open = "[",
      .close = "]"
    ) -> docker_contents
    
    
    fileConn <- file("Dockerfile")
    writeLines(docker_contents, fileConn)
    close(fileConn)
    
    fs::dir_create(".binder")
    fs::file_move("Dockerfile", ".binder/Dockerfile")
  }
