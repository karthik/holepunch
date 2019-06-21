test_that("Write Compendium Description", {
  # This doesn't work even if I put the function in 
  # helper-write_compendium_description.R 
  # test_path <- set_up_test_repo()
  # WHY???
  # ----------------------------------------------
  
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
    close(fileConn)
    cat(
      "```{r}\nlibrary(dplyr)\nrequire(ggplot2)\nglue::glue_collapse(glue::glue('{1:10}'))\n```\n",
      file = paste0(test_path, "/test.Rmd")
    )
    return(test_path)
  }
  
  test_path <- set_up_test_repo()
  fs::dir_create(glue::glue("{test_path}/.binder"))
  z <- glue::glue("
            library(curl)
            library(fs)
            library(here)
            fs::dir_exists('.')
            ")
  fileConn <- file(glue::glue("{test_path}/z.R"))
  writeLines(z, fileConn)
  close(fileConn)
  write_compendium_description(path = test_path)
  expect_true(fs::file_exists(glue::glue("{test_path}/DESCRIPTION")))
  unlink(test_path)
})
