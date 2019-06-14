#' Write a minimal Dockerfile for a binder
#'
#' @param base Rocker base
#' @param maintainer Maintainer of the Dockerfile
#' @param r_date  The date for which you'd like to lock down this project.
#'   Projects that match current release date go to "latest"
#' @param path path to binder repo
#'
#' @importFrom glue glue
#' @export
#' 
write_dockerfile <-
  function(base = NULL,
           path = ".",
           maintainer = "karthik",
           r_date = NULL)
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
    
    if(is.null(r_date)) {
      r_date = "latest"
    } else {
      r_date = r_version_lookup(r_date)
    }
    
    cliapp::cli_alert("Setting R version to {r_date}")
    R_VERSION = r_date 
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
    cliapp::cli_alert_success("Dockerfile written to .binder/Dockerfile")
  }
