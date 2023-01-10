read_epts <- function(data, metadata) {

  x <-
    read.table(
      text = gsub(x = readLines(data),
                  pattern = seps(metadata, regex = TRUE),
                  replacement = " ",
                  perl = TRUE)
    )

  res <- split(x = x, f = framing(metadata))

  mapply(
    FUN = function(x, y) setNames(object = x, nm = y),
    x = res, y = cols(metadata),
    SIMPLIFY = FALSE
  )

}



