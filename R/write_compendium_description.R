#' Creates a description file for a compendium
#'
#' @param Type Default here is compendium
#' @param Package  Name of your project
#' @param Version  Version of your compendium
#' @param path path to project (in case it is elsewhere)
#'
#' @export
write_compendium_description <-
  function(Type = "Compendium",
           Package = "Compendium title",
           Version = "0.0.1",
           path = "."
        ) {
    
    Depends = get_dependencies(path)
    fields <- list(Type = Type, Package = Package, Version = Version, Depends = Depends)
    # Using an internal function here
    desc <- usethis:::build_description(fields)
    desc <- desc::description$new(text = desc)
    # Another internal
    usethis:::tidy_desc(desc)
    lines <- desc$str(by_field = TRUE, normalize = FALSE, mode = "file")
    write_over(proj_path("DESCRIPTION"), lines)
  }