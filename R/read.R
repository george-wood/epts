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

  data    <- rectangular(x = read_raw_data(data), metadata = metadata)
  channel <- parse_channel(metadata)

  frame <- ivs::iv_locate_between(
    needles  = data[[1]],
    haystack = parse_frame(metadata),
    no_match = 0L,
    multiple = "warning"
  )

  data.table::setDF(
    data.table::setcolorder(
      data.table::rbindlist(
        l = mapply(
          FUN = function(data, cols) {
            data.table::setnames(x = data, new = cols)
          },
          data = split(data, f = frame$haystack),
          cols = lapply(X = channel, FUN = rapply, f = c),
          SIMPLIFY = FALSE
        ),
        use.names = TRUE,
        fill = TRUE
      ),
      neworder = unlist(
        lapply(do.call(what = Map, args = c(c, channel)), unique)
      )
    )
  )[]

}

read_xml_ <- function(...) {
  withCallingHandlers(
    expr = xml2::read_xml(...),
    warning = function(w) {
      if (startsWith(conditionMessage(w), "Unsupported version")) {
        invokeRestart("muffleWarning")
      }
    }
  )
}

read_data_format_specification <- function(metadata) {
  xml2::xml_find_all(
    x = read_xml_(metadata),
    xpath = "//DataFormatSpecification"
  )
}

read_raw_data <- function(data, n) {
  if (missing(n) && !is.na(file.info(data)$size)) {
    readChar(
      con = data,
      nchars = file.info(data)$size,
      useBytes = TRUE
    )
  } else {
    readLines(
      con = data,
      n = if (missing(n)) -1L else n,
      warn = FALSE
    )
  }
}

rectangular <- function(x, metadata) {

  sep <- parse_separator(metadata)

  data.table::fread(
    data.table = TRUE,
    header     = FALSE,
    sep        = "\t",
    text       = gsub(
      x = gsub(
        x = x,
        pattern = glue::glue(
          "{sep$initial}(?=$|\n)|{sep$playerChannelRef}(?={sep$initial})"
        ),
        replacement = "",
        perl = TRUE
      ),
      pattern = paste0(sep[lengths(sep) != 0], collapse = "|"),
      replacement = "\t",
      perl = TRUE
    )
  )
}
