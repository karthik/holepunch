test_that("last modification date", {
  
  fs::file_create("foo")
  fs::file_touch("foo", "2018-01-01")
  touch_date <- holepunch:::last_modification_date("foo")
  expect_identical("2018-01-01", touch_date)
  
})
