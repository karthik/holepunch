test_that("Write Install works", {
  test_path <- paste0(tempdir(), "/testcompendium")
  dir.create(test_path, showWarnings = FALSE)

  # Note: suppressing warnings here because if I don't I see this:
  # warning: `recursive` is deprecated, please use `recurse` instead
  suppressWarnings(usethis::create_project(path = test_path, open = FALSE))
  # add an Rmd with some packages in use
  cat("```{r}\nlibrary(dplyr)\nrequire(ggplot2)\nglue::glue_collapse(glue::glue('{1:10}'))\n```\n", file = paste0(test_path, "/test.Rmd"))

  # add an R script file with some packages in use
  cat("library(tidyr)\nrequire(purrr)\n", file = paste0(test_path, "/test.R"))
  # Create a new compendium description with pkgs found in the .Rmd and .R
  library(holepunch)
  write_compendium_description(path = test_path)
  write_install(test_path)
  installer_file <- readLines(glue::glue("{test_path}/.binder/install.R"))
  packages_needed_here <- c(
    "install.packages('tidyr')", "install.packages('purrr')", "install.packages('rmarkdown')",
    "install.packages('dplyr')", "install.packages('ggplot2')", "install.packages('glue')"
  )
  expect_identical(installer_file, packages_needed_here)
  fs::dir_delete(test_path)
})

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
