test_that("Writing Python requirements works", {
  temp_path <- tempdir(check = TRUE)
  fs::dir_create(glue::glue("{temp_path}/.binder"))
  z <- glue::glue("
numpy==1.16.*
matplotlib==3.*
seaborn==0.8.1")


holepunch::write_requirements(path = temp_path, requirements = z)
file_path <- glue::glue("{temp_path}/.binder/requirements.txt")
# Check to see if the file is written
expect_true(fs::file_exists(file_path))
# Now check to see if the contents match
require_contents <- readLines(glue::glue("{temp_path}/.binder/requirements.txt"))
expect_identical(require_contents[1], "numpy==1.16.*")
expect_identical(require_contents[2], "matplotlib==3.*")
expect_identical(require_contents[3], "seaborn==0.8.1")

unlink(temp_path)

})
