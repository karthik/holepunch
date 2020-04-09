rand_str_foo <- function() {
  paste(sample(c(0:9, letters, LETTERS), 4, replace = TRUE), collapse = "")
}


dir_empty <- function(x) {
  unlink(x, recursive = TRUE, force = TRUE)
  dir.create(x)
}



