test_that("Writing Dockerfile works", {
  temp <- tempdir()
  rand_string <-
    paste(sample(c(0:9, letters, LETTERS), 12, replace = TRUE), collapse = "")
  test_path <- glue::glue("{temp}/{rand_string}/testcompendium")
  print(glue::glue("test path is {test_path}"))
  fs::dir_create(test_path)
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
  
  print(test_path)
  library(holepunch)
  write_compendium_description(path = test_path)
  write_dockerfile(path = test_path, maintainer = "Wes Anderson")
  
  reading_back_dockerfile <-
    readLines(glue::glue("{test_path}/.binder/Dockerfile"))
  
  expect_identical(reading_back_dockerfile[2], "LABEL maintainer='Wes Anderson'")
  expect_identical(reading_back_dockerfile[3], "USER root")
  expect_identical(reading_back_dockerfile[4], "COPY . ${HOME}")
  expect_identical(reading_back_dockerfile[5], "RUN chown -R ${NB_USER} ${HOME}")
  
 #  unlink(test_path)
})
