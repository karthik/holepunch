test_that("Badge works", {
  # Start of the block that needs to be a helper function
  test_path <- paste0(tempdir(), "/testcompendium")
  dir.create(test_path, showWarnings = FALSE)
  old_path = getwd()
  # Note: suppressing warnings here because if I don't I see this:
  # warning: `recursive` is deprecated, please use `recurse` instead
  suppressWarnings(usethis::create_project(path = test_path, open = FALSE))
  setwd(test_path)
  git2r::init(test_path)
  
  # This is a horrifying way to write a config manually, but
  # . ¯\_(ツ)_/¯
  # I don't know a better way for now.
  config <- glue::glue(
    "
[core]
	bare = false
	repositoryformatversion = 0
	filemode = true
	ignorecase = true
	precomposeunicode = true
	logallrefupdates = true
[remote \"origin\"]
	url = git@github.com:user/repo.git
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch \"master\"]
	remote = origin
	merge = refs/heads/master
"
  )
  fileConn <- file(glue::glue("{test_path}/.git/config"))
  writeLines(config, fileConn)
  
  cat(
    "```{r}\nlibrary(dplyr)\nrequire(ggplot2)\nglue::glue_collapse(glue::glue('{1:10}'))\n```\n",
    file = paste0(test_path, "/test.Rmd")
  )
  # End of the block that needs to be a helper function
  expect_true(generate_badge())
  fs::dir_delete(test_path)
})
