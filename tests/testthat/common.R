source(test_path('test-fns.R'))


# randdd <- rand_str_foo()
# # Tempdir never goes away and I need to start clean each time
# # Hence the random dir
# temp_path <- glue::glue("{tempdir()}/{randdd}/testcompendium")
# dir.create(temp_path, showWarnings = FALSE)
old_path <- getwd()
temp_path <- tempfile()
dir_empty(temp_path)
# Note: suppressing warnings here because if I don't I see this:
# warning: `recursive` is deprecated, please use `recurse` instead
#usethis::create_project(path = temp_path, open = FALSE)
# TODO: Problem above:
# ----------------------------------------------------
setwd(temp_path)
git2r::init(temp_path)

# This is a horrifying way to write a config manually,
# BUT
# . ¯\_(ツ)_/¯
# I don't know a better way for now. :crying_blood:
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
on.exit(setwd(temp_path))
