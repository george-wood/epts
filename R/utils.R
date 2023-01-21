replace_sep <- function(x, tree) {

  gsub(
    x = gsub(
      x = x,
      pattern = glue(
        "{tree$initial}(?=$|\n)|{tree$PlayerChannelRef}(?={tree$initial})"
      ),
      replacement = "",
      perl = TRUE
    ),
    pattern = paste0(tree[!is.na(tree)], collapse = "|"),
    replacement = "@",
    perl = TRUE
  )

}
