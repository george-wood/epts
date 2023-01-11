find_dfs <- function(metadata) {
  xml_find_all(read_xml(metadata), "//DataFormatSpecification")
}

parse_framing <- function(metadata) {

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

parse_channels <- function(metadata) {

  data_format_specification <- find_dfs(metadata)

  var_channel <- lapply(
    data_format_specification,
    FUN = function(x) {
      xml_attr(attr = "name",
               xml_find_all(x, "StringRegister"))
    }
  )

  player_channel <- lapply(
    data_format_specification,
    FUN = function(x) {
      xml_attr(attr = "playerChannelId",
               xml_find_all(x, "SplitRegister/SplitRegister/PlayerChannelRef"))
    }
  )

  ball_channel <- lapply(
    data_format_specification,
    FUN = function(x) {
      xml_attr(attr = "channelId",
               x = xml_find_all(x, "SplitRegister/BallChannelRef"))
    }
  )

  Map(c,
      var_channel,
      player_channel,
      ball_channel)

}

parse_separators <- function(metadata, regex = TRUE) {

  separators <- xml_attr(
    attr = "separator",
    xml_find_all(x = read_xml(x = metadata),
                 xpath = "DataFormatSpecifications//*")
  )

  res <- paste0(unique(na.omit(separators)), collapse = "")

  if (regex) paste0("[", res, "]") else res

}






