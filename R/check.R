check_input <- function(data, metadata) {
  check_data_cols(data, metadata)
  check_data_rows(data, metadata)
  check_frame_order(data, metadata)
}

check_data_cols <- function(data, metadata) {
  if (
    !all(
      sapply(
        X = sapply(
          X = parse_channel(metadata), \(x) sum(lengths(x))
        ),
        FUN = identical,
        ncol(read_line(data, metadata))
      )
    )
  )
    warn_data_cols()
}

check_data_rows <- function(data, metadata) {
  if (countLines(data) != length(parse_frame(metadata)))
    warn_data_rows()
}

check_frame_order <- function(data, metadata) {
  x <- parse_frame(metadata)

  if (is.unsorted(attr(x, "start_frame")) || is.unsorted(attr(x, "end_frame")))
    warn_frame_order()

  if (any(attr(x, "end_frame") < attr(x, "start_frame")))
    warn_frame_order()
}

warn_data_cols <- function() {
  warn(
    paste("The number of columns in `data` is not equal to",
          "the number of channels in each DataFormatSpecification.")
  )
}

warn_data_rows <- function() {
  warn(
    paste("The number of rows in `data` does not equal",
          "the frame count range in `metadata`.")
  )
}

warn_frame_order <- function() {
  warn(
    "Problem with frame order. Check startFrame and endFrame in `metadata`."
  )
}
