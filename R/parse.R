parse_frame <- function(metadata) {
  framing <- sapply(
    X = c("startFrame", "endFrame"),
    simplify = FALSE,
    FUN = function(x) {
      as.numeric(xml_attr(read_data_format_specification(metadata), attr = x))
    }
  )

  ivs::iv(
    start = eval(sym("startFrame"), framing),
    end = eval(sym("endFrame"), framing) + 1
  )
}


parse_channel <- function(metadata) {
  lapply(
    X = read_data_format_specification(metadata),
    FUN = function(x) {
      mapply(
        FUN = function(attr, xpath) {
          xml_attr(attr = attr, x = xml_find_all(x, xpath))
        },
        attr = c(
          attr_name(),
          attr_playerChannelId(),
          attr_channelId()
        ),
        xpath = c(
          path_StringRegister(),
          path_PlayerChannelRef(),
          path_BallChannelRef()
        )
      )
    }
  )
}


parse_separator <- function(metadata) {
  x <- read_data_format_specification(metadata)

  path <- c(
    initial          = ".",
    PlayerChannelRef = path_SplitRegister("PlayerChannelRef"),
    BallChannelRef   = path_SplitRegister("BallChannelRef"),
    playerChannelId  = path_SplitRegister_SplitRegister("PlayerChannelRef"),
    channelId        = path_SplitRegister_SplitRegister("BallChannelRef")
  )

  sapply(
    X = path,
    simplify = FALSE,
    FUN = function(p) {
      sep <- unique(xml_attr(xml_find_all(x, p), attr = attr_separator()))
      ifelse(length(sep) == 0, NA_character_, sep)
    }
  )
}
