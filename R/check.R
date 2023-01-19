check_input <- function(data, metadata) {
  check_dim(data, metadata)
  check_name(metadata)
}

check_name <- function(metadata) {
  if (!has_name(x = unlist(parse_channel(metadata)), name = "name"))
    abort_name()
}

check_dim <- function(data, metadata) {

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

  n     <- countLines(data)
  frame <- parse_frame(metadata)

  if (n != max(iv_end(frame) - 1))
    warn_data_rows(n = n, frame = frame)

}

check_frame_range <- function(data, metadata) {
  x <- parse_frame(metadata)

  if (is.unsorted(attr(x, "start_frame")) || is.unsorted(attr(x, "end_frame")))
    warn_frame_range()

  if (any(attr(x, "end_frame") < attr(x, "start_frame")))
    warn_frame_range()
}

check_output <- function(data, metadata) {

  frameRange <- iv(
    start = attr(parse_frame(metadata), "startFrame"),
    end   = attr(parse_frame(metadata), "endFrame")
  )

  # iv_between()

}

warn_data_cols <- function() {
  cli_warn(c(
    "!" = "The number of columns in data is not equal to
    the number of channels in each DataFormatSpecification."
  ))
}

warn_data_rows <- function(n, frame) {
  cli_warn(c(
    "!" = "The number of rows in {.var data} does not equal
      the frame count range in {.var metadata}:",
    "i" = "{.var data} has {n} rows",
    "i" = "{.var metadata} has frame count range:
      [{iv_start(frame)}, {iv_end(frame) - 1}]"
  ))
}

warn_frame_range <- function() {
  cli_warn(c(
    "!" = "Problem with frame count range.
    Check startFrame and endFrame in `metadata`."
  ))
}

abort_name <- function() {
  cli_abort(c(
    "!" = "`data` does not have a frame parameter."
  ))
}
