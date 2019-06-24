test_that("Write runtime works", {
  tpath <- test_path("dir_code")
  unlink(test_path("dir_code/.binder"))
  unlink(test_path("dir_code/.binder/Dockerfile"))
  write_runtime(path = tpath)
  expect_true(fs::file_exists(glue::glue("{tpath}/.binder/runtime.txt")))
  # Note: Should I use fs or just stick with unlink?
  unlink(test_path("dir_code/.binder"))
})


test_that("Write runtime gets right date", {
  tpath <- test_path("dir_code")
  unlink(test_path("dir_code/.binder"))
  write_runtime(path = tpath, r_date = "2019-03-02")
  runtime_file <- readLines(glue::glue("{tpath}/.binder/runtime.txt"))
  expect_identical("r-2019-03-02", runtime_file)
  # Note: Should I use fs or just stick with unlink?
  unlink(test_path("dir_code/.binder"))
})

test_that("A warning is generated if Dockerfile exists", {
  tpath <- test_path("dir_code")
  unlink(test_path("dir_code/.binder"))
  docker_contents <- "yippkie kay yay"
  path <- holepunch:::sanitize_path(tpath) # To kill trailing slashes
  fs::dir_create(glue::glue("{path}/.binder"))
  fileConn <- file(glue::glue("{path}/.binder/Dockerfile"))
  writeLines(docker_contents, fileConn)
  close(fileConn)
  expect_warning(write_runtime(path = tpath, r_date = "2019-03-02"))
  # Note: Should I use fs or just stick with unlink?
  unlink(test_path("dir_code/.binder"))
})
