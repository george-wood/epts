#' Read EPTS data
#'
#' @param data Path to a raw data txt file.
#' @param metadata Path to a format specification xml file.
#'
#' @return A data frame containing a representation of the EPTS data.
#' @export
#'
#' @examples
#' data <- epts_example("fifa_example.txt")
#' metadata <- epts_example("fifa_example.xml")
#' read_epts(data, metadata)
read_epts <- function(data, metadata) {

  data <- split(
    x = read.table(
      text = gsub(x = readLines(data, warn = FALSE),
                  pattern = parse_separators(metadata, regex = TRUE),
                  replacement = " ",
                  perl = TRUE)
    ),
    f = parse_framing(metadata)
  )

  data.table::setDF(
    data.table::rbindlist(
      mapply(
        FUN = function(data, cols) setNames(object = data, nm = cols),
        data = data,
        cols = parse_channels(metadata),
        SIMPLIFY = FALSE
      ),
      use.names = TRUE,
      fill = TRUE
    )
  )[]

}