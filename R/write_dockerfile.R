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
    if (!fs::file_exists("DESCRIPTION")) {
      stop(
        "Your compendium does not have a DESCRIPTION file.  Without one, this Dockerfile approach will not be able to install dependencies. Run write_compendium_description() before running this function",
        call. = FALSE
      )
    }
    
    # Grab GitHub username and repo name to populate the path to the DESCRIPTION file in the Dockerfile
    user <- gh::gh_tree_remote(path)$username
    repo <- gh::gh_tree_remote(path)$repo
    
    # If the user does not specify a date, use the date of the last touched file on the project
    if (is.null(r_date)) {
      version = r_version_lookup(last_modification_date())
    } else {
      version = r_version_lookup(r_date)
    }
    
    cliapp::cli_alert("Setting R version to {version}")
    R_VERSION = version
    # Set the date for R packages
    DATE = ifelse(is.null(r_date), last_modification_date("."), r_date)
    MAINTAINER = maintainer
    
    # Set the binder base here. Users can override this by passing a base argument
    if (is.null(base)) {
      base = glue("rocker/binder:{R_VERSION}")
    }
    
    # Now we glue the Dockerfile together
    
    glue::glue(
      "
FROM [base]
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
