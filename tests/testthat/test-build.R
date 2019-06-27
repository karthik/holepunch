test_that("Test that build fails on a repo without a git remote", {
  temp_path <- paste0(tempdir(), "/testcompendium")
  dir.create(temp_path, showWarnings = FALSE)
  # Note: suppressing warnings here because if I don't I see this:
  # warning: `recursive` is deprecated, please use `recurse` instead
  suppressWarnings(usethis::create_project(path = temp_path, open = FALSE))
  setwd(temp_path)
  git2r::init(temp_path)
  expect_warning(build_binder(temp_path))
})

# TODO: Test futures and promises but I have no idea how.