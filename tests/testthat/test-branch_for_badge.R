test_that("Passing branch to the badge works", {
  rand_str_foo <- function() {
    paste(sample(c(0:9, letters, LETTERS), 12, replace = TRUE), collapse = "")
  }
  
  randdd <- rand_str_foo()
  temp_path <- glue::glue("{tempdir()}/{randdd}/testcompendium")
  dir.create(temp_path, showWarnings = FALSE)
  old_path <- getwd()
  # Note: suppressing warnings here because if I don't I see this:
  # warning: `recursive` is deprecated, please use `recurse` instead
  suppressWarnings(usethis::create_project(path = temp_path, open = FALSE))
  setwd(temp_path)
  git2r::init(temp_path)
  
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
  fileConn <- file(glue::glue("{temp_path}/.git/config"))
  writeLines(config, fileConn)
  close(fileConn)
  
  cat(
    "```{r}\nlibrary(dplyr)\nrequire(ggplot2)\nglue::glue_collapse(glue::glue('{1:10}'))\n```\n",
    file = paste0(temp_path, "/test.Rmd")
  )
  # End of the block that needs to be a helper function
  expect_output(generate_badge(branch = "master"), "master")
  expect_output(generate_badge(branch = "foobar"), "foobar")
  
  unlink(temp_path)
  setwd(old_path)
})
