test_that("Just some helper functions", {
  # -------------------------------------------------------------
  # This function set up a new folder that:
  # is a R project
  # Contains at least one R file with some package names
  # Is Git initialized
  # Has a github remote (so a Dockerfile can pull our user/repo)
  # -------------------------------------------------------------
  set_up_test_repo <- function() {
    test_path <- paste0(tempdir(), "/testcompendium")
    dir.create(test_path, showWarnings = FALSE)
    git2r::init(test_path)
    # This is a horrifying way to write a config manually, but
    # . ¯\_(ツ)_/¯
    # I don't know a better way for now.
    config <- glue::glue(
      "
[core]
	bare = false
	repositoryformatversion = 0
	filemode = true
	ignorecase = true
	precomposeunicode = true
	logallrefupdates = true
[remote \"origin\"]
	url = git@github.com:user/repo.git
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch \"master\"]
	remote = origin
	merge = refs/heads/master
"
    )
    fileConn <- file(glue::glue("{test_path}/.git/config"))
    writeLines(config, fileConn)
    
    cat(
      "```{r}\nlibrary(dplyr)\nrequire(ggplot2)\nglue::glue_collapse(glue::glue('{1:10}'))\n```\n",
      file = paste0(test_path, "/test.Rmd")
    )
    return(test_path)
  }
  
})
