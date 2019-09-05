#' Write a minimal Dockerfile for a Binder
#'
#' The file is written to a hidden folder called `.binder/`. This will not
#' interfere with other Dockerfiles that you may have in your root to help with
#' other services like CI.
#'
#' @param base Your Docker base. I recommend that you use a binder base from the
#'  \href{https://www.rocker-project.org/images/}{Rocker project}. This daily
#'  image will contain all the Jupyter hub elements + Rstudio Server + the
#'  Tidyverse (which cuts down on installation time). The only thing then left
#'  to do is to install any additional packages listed in your DESCRIPTION file,
#'  which will be done during the build_binder step.
#' @param maintainer Maintainer of the Dockerfile. By default the function reads
#'  `usethis.full_name` set in Options. The same information is used to set the
#'  author on your DESCRIPTION file.  For more information on setting up default
#'  values for Description files, read the
#'  \href{https://usethis.r-lib.org/articles/articles/usethis-setup.html#store-default-values-for-description-fields-and-other-preferences}{Rstudio
#'  usethis documentation}.
#' @template r_date
#' @param branch Default is master but you can pass other branches
#' @param path path to binder repo. Defaults to current location.
#' @param install_github If `TRUE`, it will install all packages listed in Remotes
#'
#' @importFrom glue glue
#' @importFrom desc desc_get_remotes
#' @export
#'
write_dockerfile <-
  function(base = NULL,
             path = ".",
             maintainer = getOption("usethis.full_name"),
             r_date = NULL,
             branch = "master",
             install_github = FALSE) {
    if (!fs::file_exists("DESCRIPTION")) {
      stop(
        "Your compendium does not have a DESCRIPTION file.  Without one, this Dockerfile approach will not be able to install dependencies. Run write_compendium_description() before running this function",
        call. = FALSE
      )
    }

    if (!has_a_git_remote()) {
      stop(
        "Cannot write a Dockerfile without a Git remote. Connect this to a git remote before generating a Dockerfile",
        call. = FALSE
      )
    }

    # Grab GitHub username and repo name to populate the path to the DESCRIPTION file in the Dockerfile
    user <- gh::gh_tree_remote(path)$username
    repo <- gh::gh_tree_remote(path)$repo

    # If the user does not specify a date, use the date of the last touched file on the project
    if (is.null(r_date)) {
      version <- r_version_lookup(last_modification_date())
    } else {
      version <- r_version_lookup(r_date)
    }

    cliapp::cli_alert("Setting R version to {version}")
  
    R_VERSION <- version
    # Set the date for R packages I have a TODO here: If the user is not on R
    # latest, but has edited code today, then R_VERSION will be >
    # users_R_version In this case the user might want to manually override to
    # the older R version they are using and it might be worth generating a
    # warning here. I came across this when chatting with Nick Tierney recently.
    # Implemented below:

    version.string <- R.Version()$version.string
    users_R_version <- base::strsplit(version.string, " ")[[1]][3]
    remote_cmd <- "" # Blank by default
    
    
    if(install_github) {
      remotes <- desc::desc_get_remotes("DESCRIPTION")
      remote_list <- paste0(remotes, collapse = " ")
      remote_cmd <- glue("RUN installGithub.r {remote_list}")
    }
    
    # TODO: implement something similar for bioc packages here.
    
    if (!identical(R_VERSION, users_R_version)) {
      warning(
        glue(
          "
     The version of R matching the last modified file in this project is {R_VERSION} and is 
     the one being used in your Dockerfile. However, you are running {users_R_version} locally.
     Assuming your code runs without errors, it might be ok to leave the Dockerfile at 
     {R_VERSION}. But if you wish to stick to your local version, you can re-run this 
     function with a fixed date using r_date.
          "
        )
      )
    }

    DATE <- ifelse(is.null(r_date), last_modification_date("."), r_date)
    # TODO: Not sure why I need to do this because otherwise I get a numeric
    DATE <- as.Date(DATE, origin = "1970-01-01")
    if (is.null(maintainer)) {
      maintainer <- "Unknown"
    }
    MAINTAINER <- maintainer
    cliapp::cli_alert("Locking packages down at {DATE}")
    
    # Set the binder base here. Users can override this by passing a base argument
    if (is.null(base)) {
      base <- glue("rocker/binder:{R_VERSION}")
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

[remote_cmd]

RUN wget https://github.com/[user]/[repo]/raw/[branch]/DESCRIPTION && R -e \"options(repos = list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/[DATE]/')); devtools::install_deps()\"

RUN rm DESCRIPTION.1; exit 0
",
      .open = "[",
      .close = "]"
    ) -> docker_contents
    path <- sanitize_path(path) # To kill trailing slashes
    fs::dir_create(glue("{path}/.binder"))
    fileConn <- file(glue("{path}/.binder/Dockerfile"))
    writeLines(docker_contents, fileConn)
    close(fileConn)

    cliapp::cli_alert_success(glue("Dockerfile generated at {path}/.binder/Dockerfile"))
  }
