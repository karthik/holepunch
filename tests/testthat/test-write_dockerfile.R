test_that("Writing Dockerfile works", {
  source(test_path("common.R"))

  write_compendium_description(path = temp_path)
  write_dockerfile(path = temp_path, maintainer = "Wes Anderson")

  reading_back_dockerfile <-
    readLines(glue::glue("{temp_path}/.binder/Dockerfile"))

  expect_identical(reading_back_dockerfile[2], "LABEL maintainer='Wes Anderson'")
  expect_identical(reading_back_dockerfile[3], "USER root")
  expect_identical(reading_back_dockerfile[4], "COPY . ${HOME}")
  expect_identical(reading_back_dockerfile[5], "RUN chown -R ${NB_USER} ${HOME}")

  unlink(temp_path)
  setwd(old_path)
})


# test_that("Writing Dockerfile generates a error when there is no DESCRIPTION file", {
#   
#   source("common.R")
#   expect_error(write_dockerfile(path = temp_path))
#   unlink(temp_path)
#   setwd(old_path)
# })


# test_that("Writing Dockerfile generates a error when git remote is missing", {
#   source("common.R")
#   print(glue::glue("Current working directory is {getwd()}"))
#    unlink(glue::glue("{getwd()}/.git"))
#    # Cannot find a Git remote
#   expect_error(write_dockerfile(path = temp_path, maintainer = "Wes Anderson"))
# 
#   unlink(temp_path)
#   setwd(old_path)
# })


