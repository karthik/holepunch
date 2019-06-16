test_that("Write runtime works", {
  library(fs)
  write_runtime()
  expect_true(fs::file_exists(".binder/runtime.txt"))
  fs::dir_delete(".binder")
})
