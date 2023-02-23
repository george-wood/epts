parse_frame <- function(metadata) {
  framing <- sapply(
    X = c("startFrame", "endFrame"),
    simplify = FALSE,
    FUN = function(x) {
      as.numeric(
        xml2::xml_attr(
          read_data_format_specification(metadata),
          attr = x
        )
      )
    }
  )

  ivs::iv(start = framing$startFrame, end = framing$endFrame + 1)
}

parse_channel <- function(metadata) {
  lapply(
    X = read_data_format_specification(metadata),
    FUN = function(x) {
      mapply(
        FUN = function(attr, xpath) {
          xml2::xml_attr(attr = attr, x = xml2::xml_find_all(x, xpath))
        },
        attr = c(
          "name",
          "playerChannelId",
          "channelId"
        ),
        xpath = c(
          "StringRegister",
          "SplitRegister/SplitRegister/PlayerChannelRef",
          "SplitRegister/BallChannelRef"
        )
      )
    }
  )
}

parse_separator <- function(metadata) {
  sapply(
    X = xpath_separator(),
    simplify = FALSE,
    FUN = function(xpath) {
      unique(
        xml2::xml_attr(
          xml2::xml_find_all(
            x = read_data_format_specification(metadata),
            xpath = xpath
          ),
          attr = "separator"
        )
      )
    }
  )
}

xpath_separator <- function() {
  c(
    initial =
      ".",
    playerChannelRef =
      "SplitRegister[descendant::PlayerChannelRef]",
    ballChannelRef =
      "SplitRegister[descendant::BallChannelRef]",
    playerChannelId =
      "SplitRegister/SplitRegister[descendant::PlayerChannelRef]",
    channelId =
      "SplitRegister/SplitRegister[descendant::BallChannelRef]"
  )
}
