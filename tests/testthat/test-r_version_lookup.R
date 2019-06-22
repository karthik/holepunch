test_that("r_version_lookup", {
  z1 <- holepunch:::r_version_lookup("2019-06-20")
  expect_identical(z1, "3.6.0")

  z2 <- holepunch:::r_version_lookup("2018-06-20")
  expect_identical(z2, "3.5.0")

  z3 <- holepunch:::r_version_lookup("2017-06-20")
  expect_identical(z3, "3.4.0")
})
