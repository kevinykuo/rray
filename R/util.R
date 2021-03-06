compact <- function (x) {
  is_null <- map_lgl(x, is.null)
  x[!is_null]
}

glubort <- function(..., .sep = "", .envir = parent.frame()) {
  abort(glue::glue(..., .sep = .sep, .envir = .envir))
}

# we need a helper to just set the dim because we
# override dim<- to broadcast. Otherwise without this
# we get an infinite loop because broadcast would call dim<-
set_dim <- function(x, dim) {

  if (is.null(x)) {
    return(NULL)
  }

  attr(x, "dim") <- dim

  x
}

as_cpp_idx <- function(x) {

  if (is.null(x)) {
    return(x)
  }

  x - 1L
}
