test_that("Write runtime works", {
  
  temp_directory <- tempdir()
  write_runtime(path = temp_directory)
  expect_true(fs::file_exists(glue::glue("{temp_directory}/.binder/runtime.txt")))
  # Note: Should I use fs or just stick with unlink?
  fs::dir_delete(temp_directory)
})


test_that("Write runtime gets right date", {
  temp_directory <- tempdir()
  write_runtime(path = temp_directory, r_date = "2019-03-02")
  runtime_file <- readLines(glue::glue("{temp_directory}/.binder/runtime.txt"))
  expect_identical("r-2019-03-02", runtime_file)
  # Note: Should I use fs or just stick with unlink?
  fs::dir_delete(temp_directory)
})

test_that("A warning is generated if Dockerfile exists", {
  temp_directory <- tempdir()
  docker_contents <- "yippkie kay yay"
  path <- holepunch:::sanitize_path(temp_directory) # To kill trailing slashes
  fs::dir_create(glue::glue("{path}/.binder"))
  fileConn <- file(glue::glue("{path}/.binder/Dockerfile"))
  writeLines(docker_contents, fileConn)
  close(fileConn)
  expect_warning(write_runtime(path = temp_directory, r_date = "2019-03-02"))
  # Note: Should I use fs or just stick with unlink?
  fs::dir_delete(temp_directory)
})