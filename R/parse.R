parse_frame <- function(metadata) {
  framing <- sapply(
    X = c("startFrame", "endFrame"),
    simplify = FALSE,
    FUN = function(x) {
      as.numeric(
        xml_attr(
          read_data_format_specification(metadata),
          attr = x
        )
      )
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
        xml_attr(
          xml_find_all(
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
    PlayerChannelRef =
      "SplitRegister[descendant::PlayerChannelRef]",
    BallChannelRef =
      "SplitRegister[descendant::BallChannelRef]",
    playerChannelId =
      "SplitRegister/SplitRegister[descendant::PlayerChannelRef]",
    channelId =
      "SplitRegister/SplitRegister[descendant::BallChannelRef]"
  )
}
