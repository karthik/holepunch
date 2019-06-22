test_that("Last Modification Date Works", {
  expect_error(holepunch:::last_modification_date(1))
})

test_that("Path sanitization works", {
  path <- "foo/bar/"
  expect_equal(sanitize_path(path), "foo/bar")
})
