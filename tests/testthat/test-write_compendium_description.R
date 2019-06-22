test_that("Write Compendium Description", {
  library(glue)
  test_path <- tempdir(check = TRUE)
  message(glue("Path for tempdir is {test_path}"))
  fs::dir_create(glue("{test_path}/.binder"))
  z <- glue::glue("
            library(curl)
            library(fs)
            library(here)
            fs::dir_exists('.')
            ")
  fileConn <- file(glue("{test_path}/z.R"))
  writeLines(z, fileConn)
  close(fileConn)
  write_compendium_description(path = test_path)
  expect_true(fs::file_exists(glue("{test_path}/DESCRIPTION")))
  fs::dir_delete(test_path)
})


test_that("A Description is written correctly", {

source("common.R")
write_compendium_description(package = "FOOBAR", description = "BARFOO")

rendered_file <- readLines(glue::glue("{test_path}/DESCRIPTION"))
expect_identical(rendered_file[1], "Type: Compendium")
expect_identical(rendered_file[2], "Package: FOOBAR")
expect_identical(rendered_file[3], "Title: What the Package Does (One Line, Title Case)")
expect_identical(rendered_file[4], "Version: 0.0.1")

unlink(test_path)
  })