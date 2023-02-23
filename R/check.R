check_input <- function(dt, metadata) {
  check_name(metadata)
  check_dim(dt, metadata)
}

check_name <- function(metadata) {
  if (!rlang::has_name(x = unlist(parse_channel(metadata)), name = "name")) {
    abort_name()
  }
}

check_dim <- function(dt, metadata) {
  if (
    !all(
      sapply(
        X = sapply(
          X = parse_channel(metadata), function(x) sum(lengths(x))
        ),
        FUN = identical,
        ncol(dt)
      )
    )
  ) {
    warn_data_cols()
  }

  frame <- parse_frame(metadata)

  if (nrow(dt) != max(ivs::iv_end(frame) - 1)) {
    warn_data_rows(n = nrow(dt), frame = frame)
  }
}

check_frame_range <- function(data, metadata) {
  frame <- parse_frame(metadata)

  if (is.unsorted(attr(frame, "start_frame")) ||
    is.unsorted(attr(frame, "end_frame"))) {
    warn_frame_range()
  }

  if (any(attr(frame, "end_frame") < attr(frame, "start_frame"))) {
    warn_frame_range()
  }
}

check_output <- function(data, metadata) {
  frame <- ivs::iv(
    start = attr(parse_frame(metadata), "startFrame"),
    end   = attr(parse_frame(metadata), "endFrame")
  )
  frame
  # iv_between()
}

warn_data_cols <- function() {
  cli::cli_warn(c(
    "!" = "The number of columns in data is not equal to
    the number of channels in each DataFormatSpecification."
  ))
}

warn_data_rows <- function(n, frame) {
  cli::cli_warn(c(
    "!" = "The number of rows in {.var data} does not equal
      the frame count range in {.var metadata}:",
    "i" = "{.var data} has {n} rows",
    "i" = "{.var metadata} has frame count range:
      [{iv_start(frame)}, {iv_end(frame) - 1}]"
  ))
}

warn_frame_range <- function() {
  cli::cli_warn(c(
    "!" = "Problem with frame count range.
    Check startFrame and endFrame in `metadata`."
  ))
}

abort_name <- function() {
  cli::cli_abort(c(
    "!" = "`data` does not have a frame parameter."
  ))
}
