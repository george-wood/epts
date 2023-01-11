#' Get path to epts example
#'
#' epts comes bundled with example files in its `inst/extdata`
#' directory. This function make them easy to access.
#'
#' @param path Name of file. If `NULL`, the example files will be listed.
#' @export
#' @examples
#' epts_example()
#' epts_example("fifa_example.txt")
epts_example <- function(path = NULL) {
  if (is.null(path)) {
    dir(system.file("extdata", package = "epts"))
  } else {
    system.file("extdata", path, package = "epts", mustWork = TRUE)
  }
}
