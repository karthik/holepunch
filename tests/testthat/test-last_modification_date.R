test_that("last modification date", {
  fs::file_create("foo")
  # Notes: Had to set this to GMT otherwise I was getting a one off date error
  today <- lubridate::ymd(lubridate::today(tz = "GMT"))
  fs::file_touch("foo", today)
  touch_date <- holepunch:::last_modification_date(".")
  expect_identical(today, touch_date)
  unlink("foo")
})
