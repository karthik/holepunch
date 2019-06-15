#' Creates a description file for a compendium
#'
#' The idea behind a compendium is to have a minimal description file that makes
#' it easy for anyone to 'install' your analysis dependencies. This makes it
#' possible for someone to run your code easily.
#'
#' To automatically populate author information, you may set usethis options in your `.rprofile` like so.
#' \code{options(
#'   usethis.full_name = "Karthik Ram",
#'   usethis.description = list(
#'   `Authors@R` = 'person("Karthik", "Ram", email = "karthik.ram@gmail.com", role = c("aut", "cre"),
#'   comment = c(ORCID = "0000-0002-0233-1757"))',
#'   License = "MIT + file LICENSE",
#'   Version = "0.0.0.9000"
#'   )
#' )}
#'
#' @param type Default here is compendium
#' @param package  Name of your compendium
#' @param description  Description of your compendium
#' @param version  Version of your compendium
#' @param path path to project (in case it is not in the current working directory)
#' @importFrom desc description
#'
#' @export
write_compendium_description <-
  function(type = "Compendium",
           package = "Compendium title",
           description = "Compendium description",
           version = "0.0.1",
           path = ".") {
    Depends = get_dependencies(path)
    fields <-
      list(
        Type = type,
        Package = package,
        Version = version,
        Description = description,
        Depends = paste0(Depends, collapse = ", ")
      )
    # TO-FIX
    # Using an internal function here
    # A silly hack from Yihui to stop the internal function use warning.
    # Not sure this is a good thing to do, but for now YOLO.
    # %:::% is in zzz.R
    
    tidy_desc <- 'usethis' %:::% 'tidy_desc'
    build_desc <- 'usethis' %:::% 'build_description'
    
    
    desc <- build_desc(fields)
    desc <- desc::description$new(text = desc)
    
    tidy_desc(desc)
    lines <-
      desc$str(by_field = TRUE,
               normalize = FALSE,
               mode = "file")
    usethis::write_over(here::here("DESCRIPTION"), lines)
    cliapp::cli_alert_info("Please update the description fields, particularly the title, description and author")
  }