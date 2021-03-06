context("test-squeeze")

test_that("various squeeze variations work", {

  x <- rray(1:10, c(10, 1))
  expect_equal(vec_dim(rray_squeeze(x)), 10)

  # Nothing
  y <- rray_reshape(x, c(5, 2))
  expect_equal(vec_dim(rray_squeeze(y)), c(5, 2))

  z <- rray_reshape(x, c(1, 10))
  expect_equal(vec_dim(rray_squeeze(z)), 10)

  # 3D
  w <- rray_reshape(x, c(5, 2, 1))
  expect_equal(vec_dim(rray_squeeze(w)), c(5, 2))

  # Multi dimension drop
  a <- rray_reshape(x, c(10, 1, 1))
  expect_equal(vec_dim(rray_squeeze(a)), 10)

  # (10, 1, 2) -> (10, 2)
  # middle dimension collapse
  b <- rray_broadcast(x, c(10, 1, 2))
  expect_equal(vec_dim(rray_squeeze(b)), c(10, 2))

  c <- rray_broadcast(z, c(1, 10, 2))
  expect_equal(vec_dim(rray_squeeze(c)), c(10, 2))

})

test_that("dimension names behavior is consistent", {

  x <- rray(1:10, c(1, 10))
  x <- set_col_names(x, letters[1:10])
  y <- t(x)

  # when it makes sense, names are kept
  expect_equal(
    n_dim_names(rray_squeeze(y), 1),
    letters[1:10]
  )

  # it doesn't make sense to keep dim names
  # because the corresponding dim size changes
  # (i.e. size 1 to 10)
  expect_equal(
    n_dim_names(rray_squeeze(x), 1),
    NULL
  )

})

test_that("explicit dimensions can be specified", {

  x <- rray(1:10, c(1, 10, 1))

  # (1, 10, 1) -> drop 1 -> (10, 1)
  expect_equal(vec_dim(rray_squeeze(x, 1)), c(10, 1))

  # (1, 10, 1) -> drop 3 -> (1, 10)
  expect_equal(vec_dim(rray_squeeze(x, 3)), c(1, 10))
})

test_that("can squeeze base objects", {

  x_arr <- array(
    c(1,2,3,4),
    dim = c(2,1,2),
    dimnames = list(c("r1", "r2"), c("c1"), c("d1", "d2"))
  )

  x_arr2 <- array(1:8, c(8, 1, 1))

  x_base <- drop(x_arr)
  x_base <- set_col_names(x_base, character())

  expect_equal(
    rray_squeeze(x_arr, 2),
    x_base
  )

  expect_is(
    rray_squeeze(x_arr2),
    "array"
  )

  expect_equal(
    rray_squeeze(x_arr2),
    array(1:8, dimnames = list(NULL))
  )

})
