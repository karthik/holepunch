test_that("Has a git remote", {
source("common.R")
expect_true(has_a_git_remote())  
fs::dir_delete(test_path)
})
