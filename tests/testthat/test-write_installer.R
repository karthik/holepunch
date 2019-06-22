test_that("Write installer works", {

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
  fs::dir_delete(temp_path)
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
  fs::dir_delete(temp_directory)
})