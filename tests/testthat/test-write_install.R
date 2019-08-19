# TODO, TOFIX
# THE PROBLEMATIC EXTRA .BINDER FILE GETS WRITTEN IN THIS TEST

test_that("Write install writes dependencies correctly", {
  
  tpath <- test_path("dir_code")
  unlink(test_path("code_dir/install.R"))
  unlink(test_path("code_dir/DESCRIPTION"))
  library(fs)
  message("tpath is ", tpath)
  library(holepunch)
  write_install(tpath)
  installer_file <-
    readLines(glue::glue("{tpath}/.binder/install.R"))

  packages_needed_here <- c(
    "install.packages('purrr')",
    "install.packages('tidyr')",
    "install.packages('rmarkdown')",
    "install.packages('dplyr')",
    "install.packages('ggplot2')",
    "install.packages('glue')"
  )
  expect_equal(installer_file, packages_needed_here)
  unlink("tests/testthat/dir_code/.binder", recursive = TRUE, force = TRUE)
})
