test_that("Check if a Git repository is clean", {
  source(test_path("common.R"))
  expect_false(is_clean(test_path))
})
