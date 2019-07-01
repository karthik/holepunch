test_that("Writing an apt file works", {
  temp_path <- tempdir(check = TRUE)
  fs::dir_create(glue::glue("{temp_path}/.binder"))
  z <- glue::glue("
texlive-latex-base
texlive-latex-recommended
texlive-science
texlive-latex-extra
texlive-fonts-recommended
dvipng
ghostscript")
  holepunch::write_apt(path = temp_path, apt_input = z)
  file_path <- glue::glue("{temp_path}/.binder/apt.txt")
  # Check to see if the file is written
  expect_true(fs::file_exists(file_path))
  # Now check to see if the contents match
  apt_contents <- readLines(glue::glue("{temp_path}/.binder/apt.txt"))
  expect_identical(apt_contents[1], "texlive-latex-base")
  expect_identical(apt_contents[2], "texlive-latex-recommended")
  expect_identical(apt_contents[3], "texlive-science")
  expect_identical(apt_contents[4], "texlive-latex-extra")
  expect_identical(apt_contents[5], "texlive-fonts-recommended")
  expect_identical(apt_contents[6], "dvipng")
  expect_identical(apt_contents[7], "ghostscript")
  unlink(temp_path)
})
teardown(unlink("tests/testthat/dir_code/.binder"))
