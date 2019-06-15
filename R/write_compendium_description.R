#' Creates a description file for a compendium
#'
#' The idea behind a compendium is to have a minimal description file that makes
#' it easy for anyone to 'install' your analysis dependencies. This makes it
#' possible for someone to run your code easily.
#' @param Type Default here is compendium
#' @param Package  Name of your compendium
#' @param Description  Description of your compendium
#' @param Version  Version of your compendium
#' @param path path to project (in case it is elsewhere)
#' @importFrom desc description
#'
#' @export
write_compendium_description <-
  function(Type = "Compendium",
           Package = "Compendium title",
           Description = "Compendium Description",
           Version = "0.0.1",
           path = ".") {
    Depends = get_dependencies(path)
    fields <-
      list(
        Type = Type,
        Package = Package,
        Version = Version,
        Description = Description,
        Depends = paste0(Depends, collapse = ", ")
      )
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