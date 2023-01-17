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

  x <- read.table(
    text = gsub(x = readLines(data, warn = FALSE),
                pattern = parse_separator(metadata, regex = TRUE),
                replacement = " ",
                perl = TRUE)
  )

  chunked <-
    withCallingHandlers(
      expr = split(x, f = parse_frame(metadata)),
      warning = function(w) {
        if (startsWith(conditionMessage(w), "data length")) {
          warning(call. = FALSE,
                  "Frames in `data` are undefined in `metadata`.")
          invokeRestart("muffleWarning")
        }
      }
    )

  channel <- parse_channel(metadata)

  setDF(
    x = setcolorder(
      neworder = unlist(
        sapply(X   = c('name','playerChannelId', 'channelId'),
               FUN = function(x) unique(unlist(lapply(channel, `[[`, x))))
      ),
      x = rbindlist(
        l = mapply(
          FUN  = function(data, cols) setNames(object = data, nm = cols),
          data = chunked,
          cols = lapply(X = channel, FUN = rapply, f = c),
          SIMPLIFY = FALSE
        ),
        use.names = TRUE,
        fill = TRUE
      )
    )
  )[]

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


read_line <- function(data, metadata, n = 1) {
  read.table(
    text = gsub(
      x           = c(fpeek::peek_head(data, n = n, intern = TRUE),
                      fpeek::peek_tail(data, n = n, intern = TRUE)),
      pattern     = parse_separator(metadata),
      replacement = " "
    )
  )
}


read_data <- function(data, metadata) {
  read.table(
    text = gsub(
      x = readLines(data, warn = FALSE),
      pattern = parse_separator(metadata),
      replacement = " "
    )
  )
}
