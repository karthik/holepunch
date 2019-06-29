test_that("Write install writes dependencies correctly", {
  tpath <- test_path("dir_code")
  unlink(test_path("dir_code/install.R"))
  unlink(test_path("dir_code/DESCRIPTION"))
  message("tpath is ", tpath)
  library(holepunch)
  write_install(tpath)
  installer_file <- readLines(glue::glue("{tpath}/.binder/install.R"))
  
  packages_needed_here <- c("install.packages('purrr')", "install.packages('tidyr')", "install.packages('rmarkdown')", 
                            "install.packages('dplyr')", "install.packages('ggplot2')", "install.packages('glue')"
  )
  expect_equal(installer_file, packages_needed_here)
  unlink(test_path("dir_code/.binder"))
})

test_that("Write installer writes install.R to .binder", {
  temp_path <- tempdir(check = TRUE)
  fs::dir_create(glue::glue("{temp_path}/.binder"))
  z <- glue::glue("
            library(curl)
            library(fs)
            library(here)
            fs::dir_exists('.')
            ")
  fileConn <- file(glue::glue("{temp_path}/z.R"))
  writeLines(z, fileConn)
  close(fileConn)
  holepunch::write_install(path = temp_path)
  file_path <- glue::glue("{temp_path}/.binder/install.R")
  expect_true(fs::file_exists(file_path))
  unlink(test_path("dir_code/.binder"))
})

test_that("A warning is generated if Dockerfile exists", {
  temp_directory <- tempdir()
  docker_contents <- "yippkie kay yay"
  path <- holepunch:::sanitize_path(temp_directory) # To kill trailing slashes

  # First write a Dockerfile

  fs::dir_create(glue::glue("{path}/.binder"))
  fileConn <- file(glue::glue("{path}/.binder/Dockerfile"))
  writeLines(docker_contents, fileConn)
  close(fileConn)

  # Next write a R file
  z <- glue::glue("
            library(curl)
            library(fs)
            library(here)
            fs::dir_exists('.')
            ")
  fileConn <- file(glue::glue("{path}/z.R"))
  writeLines(z, fileConn)
  close(fileConn)

  # Now try to write a install.R
  expect_warning(write_runtime(path = temp_directory, r_date = "2019-03-02"))
  # Note: Should I use fs or just stick with unlink?
  unlink(test_path("dir_code/.binder"))
})


test_that("A .binder folder gets written", {
  tpath <- test_path("dir_code")
  write_install(path = tpath)
  expect_true(fs::dir_exists(glue::glue("{tpath}/.binder")))
  expect_true(fs::file_exists(glue::glue("{tpath}/.binder/install.R")))
  unlink(glue::glue("{tpath}/.binder"))
})

teardown(unlink("tests/testthat/dir_code/.binder"))
