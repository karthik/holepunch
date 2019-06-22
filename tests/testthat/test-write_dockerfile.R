test_that("Writing Dockerfile works", {
source("common.R")
  
  library(holepunch)
  write_compendium_description(path = test_path)
  write_dockerfile(path = test_path, maintainer = "Wes Anderson")
  
  reading_back_dockerfile <-
    readLines(glue::glue("{test_path}/.binder/Dockerfile"))
  
  expect_identical(reading_back_dockerfile[2], "LABEL maintainer='Wes Anderson'")
  expect_identical(reading_back_dockerfile[3], "USER root")
  expect_identical(reading_back_dockerfile[4], "COPY . ${HOME}")
  expect_identical(reading_back_dockerfile[5], "RUN chown -R ${NB_USER} ${HOME}")
  
  unlink(test_path)
  setwd(old_path)
})
