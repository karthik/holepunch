# TODO, TOFIX
# THE PROBLEMATIC EXTRA .BINDER FILE GETS WRITTEN IN THIS TEST

test_that("Write install writes dependencies correctly", {
  source(test_path('test-fns.R'))
  library(glue)
  library(fs)
  
  randdd <- rand_str_foo()
  # Tempdir never goes away and I need to start clean each time
  # Hence the random dir
  temp_path <- glue::glue("{tempdir()}/{randdd}")
  dir.create(temp_path)
  old_path <- getwd()
  
  setwd(temp_path)
  unlink(glue::glue("{temp_path}/.binder"))
  file_1 <- glue::glue("
        library(tidyr)
        require(purrr)
                     ")
  
  writeLines(file_1, "test.R")
  
  
  
  file_2 <- glue::glue(
    "```{r}
library(dplyr)
require(ggplot2)
glue::glue_collapse(glue::glue('{1:10}'))
```",
    .open = "[",
    .close = "]"
  )
  
  writeLines(file_2, "test.Rmd")
  
  library(holepunch)
  write_install(temp_path)
  installer_file <-
    readLines(glue::glue("{temp_path}/.binder/install.R"))
  
  # Problem here. Write install is not finding all packages.
  packages_needed_here <- c(
    "install.packages(",
    " c( ",
    "  \"dplyr\",",
    "  \"ggplot2\",",
    "  \"glue\",",
    "  \"purrr\",",
    "  \"rmarkdown\",",
    "  \"tidyr\")", 
    ")"
  )
  
  expect_equal(installer_file, packages_needed_here)
  unlink(temp_path, recursive = TRUE, force = TRUE)
})


