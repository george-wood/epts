cols <- function(metadata) {

  dfs_ <-
    xml_find_all(
      read_xml(metadata),
      "//DataFormatSpecification"
    )

  vars <-
    lapply(
      dfs_,
      \(x)
      xml_attr(
        xml_find_all(
          x, "StringRegister"
        ),
        "name"
      )
    )

  players <-
    lapply(
      dfs_,
      \(x)
      xml_attr(
        xml_find_all(
          x, "SplitRegister/SplitRegister/PlayerChannelRef"
        ),
        "playerChannelId"
      )
    )

  ball <-
    lapply(
      data_format_specification,
      \(x)
      xml_attr(
        xml_find_all(
          x, "SplitRegister/BallChannelRef"
        ),
        "channelId"
      )
    )

  }
