# arithmetic ----------------------------------------------------------------------

rray_arith_base <- function(op, x, y) {

  # precompute dimensionality and extend existing dims
  # xtensor-r issue #57 until we have a fix (if ever)
  dims <- rray_dims2(vec_dims(x), vec_dims(y))
  x <- rray_dims_match(x, dims)
  y <- rray_dims_match(y, dims)

  # Get common dim_names and type
  dim_nms <- rray_dim_names2(x, y)
  restore_type <- vec_type2(x, y)

  # Apply function
  res <- rray_op_binary_cpp(op, x, y)

  # Add dim names
  dim_names(res) <- dim_nms

  # Restore type
  vec_restore(res, restore_type)
}

#' @export
#' @rdname vctrs-compat
#' @method vec_arith vctrs_rray
#' @export vec_arith.vctrs_rray
vec_arith.vctrs_rray <- function(op, x, y) {
  UseMethod("vec_arith.vctrs_rray", y)
}

#' @method vec_arith.vctrs_rray default
#' @export
vec_arith.vctrs_rray.default <- function(op, x, y) {
  stop_incompatible_op(op, x, y)
}

#' @method vec_arith.vctrs_rray vctrs_rray
#' @export
vec_arith.vctrs_rray.vctrs_rray <- function(op, x, y) {
  rray_arith_base(op, x, y)
}

#' @method vec_arith.vctrs_rray MISSING
#' @export
vec_arith.vctrs_rray.MISSING <- function(op, x, y) {

  res <- switch(op,
         "+" = +as_array(x),
         "-" = -as_array(x)
  )

  vec_restore(res, x)
}

# ------------------------------------------------------------------------------
# vctrs_rray <-> numeric / matrix / array

#' @method vec_arith.vctrs_rray numeric
#' @export
vec_arith.vctrs_rray.numeric <- vec_arith.vctrs_rray.vctrs_rray

#' @method vec_arith.numeric vctrs_rray
#' @export
vec_arith.numeric.vctrs_rray <- vec_arith.vctrs_rray.vctrs_rray

# ------------------------------------------------------------------------------
# vctrs_rray <-> logical / matrix / array

#' @method vec_arith.vctrs_rray logical
#' @export
vec_arith.vctrs_rray.logical <- vec_arith.vctrs_rray.vctrs_rray

#' @method vec_arith.logical vctrs_rray
#' @export
vec_arith.logical.vctrs_rray <- vec_arith.vctrs_rray.vctrs_rray
