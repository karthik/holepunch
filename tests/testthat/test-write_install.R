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
  packages_needed_here <- c("install.packages('tidyr')", "install.packages('purrr')", "install.packages('rmarkdown')", 
                            "install.packages('dplyr')", "install.packages('ggplot2')", "install.packages('glue')"
  )
  expect_identical(installer_file, packages_needed_here)
  fs::dir_delete(test_path)
})
