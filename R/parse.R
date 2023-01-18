parse_frame <- function(metadata) {

  framing <- Map(
    c("startFrame", "endFrame"),
    f = function(x) as.numeric(sapply(find_dfs(metadata), xml_attr, attr = x))
  )

  iv(start = eval(sym("startFrame"), framing),
     end   = eval(sym("endFrame"), framing) + 1)

}


# parse_frame <- function(metadata) {
#
#   framing <- Map(
#     c("startFrame", "endFrame"),
#     f = function(x) as.numeric(sapply(find_dfs(metadata), xml_attr, attr = x))
#   )
#
#   startFrame <- eval(sym("startFrame"), framing)
#   endFrame   <- eval(sym("endFrame"),   framing)
#
#   x <- findInterval(
#     x                = min(startFrame):max(endFrame),
#     vec              = endFrame,
#     rightmost.closed = FALSE,
#     all.inside       = FALSE,
#     left.open        = TRUE
#   )
#
#   attr(x, "startFrame") <- startFrame
#   attr(x, "endFrame")   <- endFrame
#   x
#
# }


parse_channel <- function(metadata) {

  lapply(
    X   = find_dfs(metadata),
    FUN = function(x) {
      mapply(
        FUN = function(attr, xpath) {
          xml_attr(attr = attr, x = xml_find_all(x, xpath))
        },
        attr  = c(
          attr_name(),
          attr_playerChannelId(),
          attr_channelId()
        ),
        xpath = c(
          path_name(),
          path_playerChannelId(),
          path_channelId()
        )
      )
    }
  )

}


parse_separator <- function(metadata, regex = TRUE) {

  separator <-
    unique(
      xml_attr(
        attr    = attr_separator(),
        x       = find_separator(metadata),
        default = ""
      )
    )

  if (regex)
    paste0("[", paste0(separator, collapse = ""), "]")
  else
    separator

}


