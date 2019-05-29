


#' Write a minimal Dockerfile for a binder
#'
#' @param base Rocker base
#' @param path path to binder repo
#' @param method Not sure [TODO]
#' @importFrom glue glue
#' @export
#'
write_dockerfile <-
  function(base = "rocker/binder:latest", path = ".", method = "desc")
  {
    user <- gh::gh_tree_remote(path)$username
    repo <- gh::gh_tree_remote(path)$repo
    z <- suppressWarnings(containerit::dockerfile(
      from = NULL,
      image = base,
      add_self = FALSE,
      container_workdir = NULL,
      silent = TRUE,
      cmd = containerit::Cmd("R"))
    )
   
    suppressWarnings(containerit::write(z, file = "Dockerfile"))
    line1 = "USER root"
    line2 = "COPY . ${HOME}"
    line3 = "RUN chown -R ${NB_USER} ${HOME}"
    line4 = "## Become normal user again"
    line5 = "USER ${NB_USER}"
    if(method == "desc") {
    line6 = glue(
      "RUN wget https://github.com/{user}/{repo}/raw/master/DESCRIPTION && R -e \"devtools::install_deps()\""
    )
  }
  if(method == "install") {
    line6 <- "R -e \"source('install.R')\""
    write_install(path)
  }
    df <- readLines("Dockerfile")
    df <- df[1:2]
    writeLines(df, con = "Dockerfile")
    write(line1, file = "Dockerfile", append = TRUE)
    write(line2, file = "Dockerfile", append = TRUE)
    write(line3, file = "Dockerfile", append = TRUE)
    write(line4, file = "Dockerfile", append = TRUE)
    write(line5, file = "Dockerfile", append = TRUE)
    write(line6, file = "Dockerfile", append = TRUE)
    
  }
