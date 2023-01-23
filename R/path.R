path_DataFormatSpecification <- function() {
  "//DataFormatSpecification"
}

path_StringRegister <- function() {
  "StringRegister"
}

path_SplitRegister <- function(descendant) {
  if (missing(descendant)) {
    "SplitRegister"
  } else {
    glue::glue("SplitRegister[descendant::{descendant}]")
  }
}

path_SplitRegister_SplitRegister <- function(descendant) {
  if (missing(descendant)) {
    "SplitRegister/SplitRegister"
  } else {
    glue::glue("SplitRegister/SplitRegister[descendant::{descendant}]")
  }
}

path_PlayerChannelRef <- function() {
  "SplitRegister/SplitRegister/PlayerChannelRef"
}

path_BallChannelRef <- function() {
  "SplitRegister/BallChannelRef"
}

attr_name <- function(x) {
  "name"
}

attr_playerChannelId <- function(x) {
  "playerChannelId"
}

attr_channelId <- function(x) {
  "channelId"
}

attr_separator <- function(x) {
  "separator"
}
