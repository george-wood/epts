framing <- function(metadata) {

  dfs_ <-
    xml_find_all(
      read_xml(metadata),
      "//DataFormatSpecification"
    )

  startFrame <- as.numeric(sapply(dfs_, xml_attr, "startFrame"))
  endFrame   <- as.numeric(sapply(dfs_, xml_attr, "endFrame"))

  frameCountRange <-
    findInterval(
      x = min(startFrame):max(endFrame),
      vec = endFrame,
      rightmost.closed = FALSE,
      all.inside = FALSE,
      left.open = TRUE
    )

  return(frameCountRange)

}


