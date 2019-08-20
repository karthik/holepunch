rand_str_foo <- function() {
  paste(sample(c(0:9, letters, LETTERS), 12, replace = TRUE), collapse = "")
}