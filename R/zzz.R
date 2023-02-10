# TODO: I was only using a couple of functions from usethis to generate a
# DESCRIPTION FILE. However, after usethis 1.4 some big changes broke this. For
# now I've ported all the functions from 1.4 to here temporarily as I resolve
# this problem. My intention is not to have old usethis functions here.


#' @noRd
#' @keywords internal
`%||%` <- rlang::`%||%`

#' @noRd
#' @keywords internal
holepunch_compact <- function(x) {
  is_empty <- vapply(x, function(x)
    length(x) == 0, logical(1))
  x[!is_empty]
}

#' @noRd
#' @keywords internal
stop_glue <- function(...,
                      .sep = "",
                      .envir = parent.frame()) {
  stop(usethis_error(glue(
    ..., .sep = .sep, .envir = .envir
  )))
}

#' @noRd
#' @keywords internal
warning_glue <- function(...,
                         .sep = "",
                         .envir = parent.frame()) {
  warning(glue(..., .sep = .sep, .envir = .envir), call. = FALSE)
}

#'@noRd
#' @keywords internal
usethis_error <- function(msg) {
  structure(class = c("usethis_error", "error", "condition"),
            list(message = msg))
}

#' @noRd
#' @keywords internal
project_name <- function(base_path = usethis::proj_get()) {
  if (!possibly_in_proj(base_path)) {
    return(fs::path_file(base_path))
  }
  
  if (is_package(base_path)) {
    project_data(base_path)$Package
  } else {
    project_data(base_path)$Project
  }
}

#' @noRd
#' @keywords internal
proj_crit <- function() {
  rprojroot::has_file(".here") |
    rprojroot::is_rstudio_project |
    rprojroot::is_r_package |
    rprojroot::is_git_root |
    rprojroot::is_remake_project |
    rprojroot::is_projectile_project
}

#' @noRd
#' @keywords internal
proj_find <- function(path = ".") {
  tryCatch(
    rprojroot::find_root(proj_crit(), path = path),
    error = function(e)
      NULL
  )
}

collapse <- function(x,
                     sep = ", ",
                     width = Inf,
                     last = "") {
  if (utils::packageVersion("glue") > "1.2.0") {
    utils::getFromNamespace("glue_collapse", "glue")(x,
                                                     sep = sep,
                                                     width = Inf,
                                                     last = last)
  } else {
    utils::getFromNamespace("collapse", "glue")(
      x = x,
      sep = sep,
      width = width,
      last = last
    )
  }
}


#' @noRd
possibly_in_proj <- function(path = ".")
  ! is.null(proj_find(path))

is_package <- function(base_path = usethis::proj_get()) {
  res <- tryCatch(
    rprojroot::find_package_root_file(path = base_path),
    error = function(e)
      NULL
  )
  ! is.null(res)
}

github_repo_spec <- function(path = usethis::proj_get()) {
  collapse(gh_tree_remote(path), sep = "/")
}

#' @noRd
uses_github <- function(base_path = usethis::proj_get()) {
  tryCatch({
    gh_tree_remote(base_path)
    TRUE
  }, error = function(e)
    FALSE)
}

package_data <- function(base_path = usethis::proj_get()) {
  desc <- desc::description$new(base_path)
  as.list(desc$get(desc$fields()))
}

#' @noRd
project_data <- function(base_path = usethis::proj_get()) {
  if (!possibly_in_proj(base_path)) {
    stop_glue(
      "{value(base_path)} doesn't meet the usethis criteria for a project.\n",
      "Read more in the help for {code(\"proj_get()\")}."
    )
  }
  if (is_package(base_path)) {
    data <- package_data(base_path)
  } else {
    data <- list(Project = fs::path_file(base_path))
  }
  if (uses_github(base_path)) {
    data$github_owner <- github_owner()
    data$github_repo <- github_repo()
    data$github_spec <- github_repo_spec()
  }
  data
}


## Git remotes --> filter for GitHub --> owner, repo, repo_spec
github_owner <- function(path = usethis::proj_get()) {
  gh_tree_remote(path)[["username"]]
}

github_repo <- function(path = usethis::proj_get()) {
  gh_tree_remote(path)[["repo"]]
}

#' Last Modified late
#'
#' Returns the latest date for when a file was touched in a project
#' @param path Path to project folder
#'
last_modification_date <- function(path = ".") {
  dir_list <- fs::dir_info(path)
  # Remove Readme.md and readme.rmd from the search because my
  # rationale is that users will modify these files far more often
  # and more frequently than the code.
  pos <- grep("readme",
              dir_list$path,
              ignore.case = TRUE)
  if (length(pos) > 0) {
    dir_list <- dir_list[-pos,]
  }
  sorted_dir_list <-
    dir_list[order(dir_list$modification_time, decreasing = TRUE),]
  last_mod <- sorted_dir_list[1,]$modification_time
  as.Date(last_mod)
}

#' @noRd
r_version_lookup <- function(date = NULL) {
  if (!is.null(date)) {
    date <- as.character(date)
    
    df <- rversions::r_versions()
    
    if (date < df[1, 2]) {
      stop("Canot find R version for this date", call. = FALSE)
    }
    ver <- utils::tail(df$version[date > df$date], 1)
  } else {
    "latest"
  }
}

#' @noRd
# nocov start
`%:::%` <- function(pkg, fun)
  get(fun,
      envir = asNamespace(pkg),
      inherits = FALSE)
# nocov end

#' @noRd
sanitize_path <- function(path) {
  sub("/+$", "", path)
}

#' @noRd
has_a_git_remote <- function() {
  is_a_git_repo <- TRUE
  base::tryCatch({
    result <- usethis::git_remotes()
  },
  error = function(e) {
    is_a_git_repo <<- FALSE
  })
  print(is_a_git_repo)
}



#' @noRd
is_clean <- function(repo) {
  sum(vapply(git2r::status(repo), length, numeric(1))) == 0
}

#' @noRd
check_is_named_list <- function(x, nm = deparse(substitute(x))) {
  if (!rlang::is_list(x)) {
    bad_class <- paste(class(x), collapse = "/")
    usethis::ui_stop("{ui_code(nm)} must be a list, not {ui_value(bad_class)}.")
  }
  if (!rlang::is_dictionaryish(x)) {
    usethis::ui_stop("Names of {ui_code(nm)} must be non-missing, non-empty, and non-duplicated.")
  }
  x
}


## Functions temporarily copied from usethis 1.4 ##

#' @noRd
#' @keywords internal
use_description_internal <- function(fields = NULL) {
  name <- project_name()
  check_package_name_internal(name)
  fields <- fields %||% list()
  check_is_named_list(fields)
  fields[["Package"]] <- name
  
  desc <- build_description_internal(fields)
  desc <- desc::description$new(text = desc)
  tidy_desc_internal(desc)
  lines <-
    desc$str(by_field = TRUE,
             normalize = FALSE,
             mode = "file")
  
  write_over(usethis::proj_path("DESCRIPTION"), lines)
}

#' @noRd
#' @keywords internal
use_description_defaults_internal <- function() {
  list(
    usethis.description = getOption("usethis.description"),
    devtools.desc = getOption("devtools.desc"),
    usethis = list(
      Package = "valid.package.name.goes.here",
      Version = "0.0.0.9000",
      Title = "What the Package Does (One Line, Title Case)",
      Description = "What the package does (one paragraph).",
      "Authors@R" = 'person("First", "Last", , "first.last@example.com", c("aut", "cre"))',
      License = "What license it uses",
      Encoding = "UTF-8",
      LazyData = "true"
    )
  )
}

#' @noRd
#' @keywords internal
build_description_internal <-
  function(fields = list(),
           collapse = NULL) {
    desc_list <- build_description_list_internal(fields)
    
    # Collapse all vector arguments to single strings
    desc <- vapply(desc_list, collapse, character(1))
    
    glue("{names(desc)}: {desc}")
  }

#' @noRd
#' @keywords internal
build_description_list_internal <- function(fields = list()) {
  defaults <- use_description_defaults_internal()
  defaults <- utils::modifyList(
    defaults$usethis,
    defaults$usethis.description %||% defaults$devtools.desc %||% list()
  )
  holepunch_compact(utils::modifyList(defaults, fields))
}

#' @noRd
#' @keywords internal
check_package_name_internal <- function(name) {
  if (!valid_name_internal(name)) {
    stop_glue(
      "{value(name)} is not a valid package name. It should:\n",
      "* Contain only ASCII letters, numbers, and '.'\n",
      "* Have at least two characters\n",
      "* Start with a letter\n",
      "* Not end with '.'\n"
    )
  }
  
}

#' @noRd
#' @keywords internal
valid_name_internal <- function(x) {
  grepl("^[[:alpha:]][[:alnum:].]+$", x) && !grepl("\\.$", x)
}

#' @noRd
tidy_desc_internal <- function(desc) {
  # Alphabetise dependencies
  deps <- desc$get_deps()
  deps <- deps[order(deps$type, deps$package), , drop = FALSE]
  desc$del_deps()
  desc$set_deps(deps)
  
  # Alphabetise remotes
  remotes <- desc$get_remotes()
  if (length(remotes) > 0) {
    desc$set_remotes(sort(remotes))
  }
  
  # Normalize all fields (includes reordering)
  desc$normalize()
}

## ------------------------------------------------##
