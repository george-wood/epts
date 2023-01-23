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
  check_input(data, metadata)

  channel <- parse_channel(metadata)

  name_channel <- unique(
    sapply(channel, function(x) eval(sym("name"), x))
  )

  dt <- read_raw_data(data, metadata)

  data.table::setnames(
    dt,
    old = names(dt)[seq_along(name_channel)],
    new = name_channel,
    skip_absent = TRUE
  )

  frame <- ivs::iv_locate_between(
    needles  = dt[[name_channel]],
    haystack = parse_frame(metadata),
    no_match = 0L,
    multiple = "warning"
  )

  chunked <- split(dt, f = eval(sym("haystack"), frame))

  res <- data.table::rbindlist(
    l = mapply(
      FUN = function(data, cols) setNames(object = data, nm = cols),
      data = chunked,
      cols = lapply(X = channel, FUN = rapply, f = c),
      SIMPLIFY = FALSE
    ),
    use.names = TRUE,
    fill = TRUE
  )

  data.table::setcolorder(
    x = res,
    neworder = unlist(lapply(do.call(what = Map, args = c(c, channel)), unique))
  )

  # check output
  if (any(eval(sym("haystack"), frame) == 0)) {
    warn_frame_range()
  }

  # return
  data.table::setDF(res)
  res
}


read_xml_ <- function(...) {
  withCallingHandlers(
    expr = read_xml(...),
    warning = function(w) {
      if (startsWith(conditionMessage(w), "Unsupported version")) {
        invokeRestart("muffleWarning")
      }
    }
  )
}

read_data_format_specification <- function(metadata) {
  xml_find_all(
    x = read_xml_(metadata),
    xpath = path_DataFormatSpecification()
  )
}


read_raw_data <- function(data, metadata, n = NULL) {
  if (missing(n)) {
    x <- readChar(
      con = data,
      nchars = file.info(data)$size,
      useBytes = TRUE
    )
  } else {
    x <- readLines(
      con = data,
      n = n,
      warn = FALSE
    )
  }

  data.table::fread(
    text = simplify_separator(x = x, sep = parse_separator(metadata)),
    data.table = TRUE,
    header = FALSE,
    sep = "\t"
  )
}
