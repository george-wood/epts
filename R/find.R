find_dfs <- function(metadata) {
  xml_find_all(
    x = read_xml_(metadata, options = "NOWARNING"),
    xpath = path_DataFormatSpecification()
  )
}

find_separator <- function(metadata) {
  xml_find_all(
    x = read_xml_(metadata, options = "NOWARNING"),
    xpath = path_separator()
  )
}
