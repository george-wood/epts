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

  split_data <- withCallingHandlers(
    expr = split(
      x = read.table(
        text = gsub(x = readLines(data, warn = FALSE),
                    pattern = parse_separator(metadata, regex = TRUE),
                    replacement = " ",
                    perl = TRUE)
      ),
      f = parse_frame(metadata)
    ),
    warning = \(w) if (startsWith(conditionMessage(w), "data length")) {
      warning(
        call. = FALSE,
        "Frames in data are undefined in metadata."
      )
      invokeRestart("muffleWarning")
    }
  )

  channel       <- parse_channel(metadata)
  channel_order <- unlist(
    sapply(X   = c('name','playerChannelId', 'channelId'),
           FUN = function(x) unique(unlist(lapply(channel, `[[`, x))))
  )

  setDF(
    x = setcolorder(
      neworder = channel_order,
      x = rbindlist(
        l = mapply(
          FUN  = function(data, cols) setNames(object = data, nm = cols),
          data = split_data,
          cols = lapply(X = channel, FUN = rapply, f = c),
          SIMPLIFY = FALSE
        ),
        use.names = TRUE,
        fill = TRUE
      )
    )
  )[]

}

