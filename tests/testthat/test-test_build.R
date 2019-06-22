test_that("Test that build fails on a repo without a git remote", {
  test_path <- paste0(tempdir(), "/testcompendium")
  dir.create(test_path, showWarnings = FALSE)
  # Note: suppressing warnings here because if I don't I see this:
  # warning: `recursive` is deprecated, please use `recurse` instead
  suppressWarnings(usethis::create_project(path = test_path, open = FALSE))
  setwd(test_path)
  git2r::init(test_path)
  expect_error(build_binder(test_path))
})

# TODO: Test futures and promises but I have no idea how.