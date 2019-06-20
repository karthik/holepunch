test_that("last modification date", {
  fs::file_create("foo")
  today = lubridate::ymd(lubridate::today())
  fs::file_touch("foo", today)
  touch_date <- holepunch:::last_modification_date(".")
  expect_identical(today, touch_date)
  unlink("foo")
})
