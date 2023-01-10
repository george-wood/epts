seps <- function(metadata, regex = TRUE) {

  separators <-
    xml_attr(
      attr = "separator",
      x = xml_find_all(
        x = read_xml(x = metadata),
        xpath = "//*"
      )
    )

  res <- paste0(unique(na.omit(separators)), collapse = "")

  if (regex) paste0("[", res, "]") else res

}
