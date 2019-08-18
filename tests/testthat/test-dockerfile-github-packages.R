test_that("Test that GitHub packages are installed in Dockerfiles", {
  source(test_path("common.R"))
  new_r_file <- file("github_packages.R")
  writeLines(c("library('coyote')", "library('patchwork')"), new_r_file)
  close(new_r_file)
  
  
  write_compendium_description(path = temp_path)
  write_dockerfile(path = temp_path, maintainer = "Wes Anderson", install_github = TRUE)
  
  reading_back_dockerfile <-
    readLines(glue::glue("{temp_path}/.binder/Dockerfile"))
  
  expect_identical(reading_back_dockerfile[2], "LABEL maintainer='Wes Anderson'")
  expect_identical(reading_back_dockerfile[3], "USER root")
  expect_identical(reading_back_dockerfile[4], "COPY . ${HOME}")
  expect_identical(reading_back_dockerfile[5], "RUN chown -R ${NB_USER} ${HOME}")
  expect_identical(reading_back_dockerfile[8], "RUN installGithub.r karthik/coyote thomasp85/patchwork")
  
  unlink(temp_path)
  setwd(old_path)
})
