test_that("Has a git remote", {
source("common.R")
expect_true(has_a_git_remote())  
unlink(test_path)
})
