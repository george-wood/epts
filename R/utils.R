simplify_separator <- function(x, sep) {
  gsub(
    x = gsub(
      x = x,
      pattern = glue::glue(
        "{sep$initial}(?=$|\n)|{sep$PlayerChannelRef}(?={sep$initial})"
      ),
      replacement = "",
      perl = TRUE
    ),
    pattern = paste0(sep[!is.na(sep)], collapse = "|"),
    replacement = "\t",
    perl = TRUE
  )
}
