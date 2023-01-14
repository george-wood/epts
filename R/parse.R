read_xml_ <- function(...) {
  withCallingHandlers(
    expr = read_xml(...),
    warning = \(w) if (startsWith(conditionMessage(w),
                                  "Unsupported version")) {
      invokeRestart("muffleWarning")
    }
  )
}

find_dfs <- function(metadata) {
  xml_find_all(
    x = read_xml_(metadata, options = "NOWARNING"),
    xpath = path_DataFormatSpecification()
  )
}

parse_frame <- function(metadata) {

  framing <- Map(
    c("startFrame", "endFrame"),
    f = function(x) as.numeric(sapply(find_dfs(metadata), xml_attr, attr = x))
  )

  start_frame <- eval(sym("startFrame"), framing)
  end_frame   <- eval(sym("endFrame"),   framing)

  findInterval(
    x                = min(start_frame):max(end_frame),
    vec              = end_frame,
    rightmost.closed = FALSE,
    all.inside       = FALSE,
    left.open        = TRUE
  )

}

parse_channel <- function(metadata) {

  lapply(
    find_dfs(metadata),
    FUN = function(x) {
      mapply(
        FUN = function(attr, xpath) {
          xml_attr(attr = attr, x = xml_find_all(x, xpath))
        },
        attr  = c(attr_name(),
                  attr_playerChannelId(),
                  attr_channelId()),
        xpath = c(path_name(),
                  path_playerChannelId(),
                  path_channelId())
      )
    }
  )

}

parse_separator <- function(metadata, regex = TRUE) {

  separator <- xml_attr(
    attr = attr_separator(),
    x = xml_find_all(x = read_xml_(x = metadata, options = "NOWARNING"),
                     xpath = path_separator())
  )

  res <- paste0(unique(na.omit(separator)), collapse = "")

  if (regex) paste0("[", res, "]") else res

}






