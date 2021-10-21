test_that("Results should be tibbles.", {
  all_sets <- get_sets()
  set_mid  <- get_set_by_code("mid")
  # set_afr  <- get_set_by_id()

  expect_true(is_tibble(all_sets))
  expect_true(is_tibble(set_mid))
  # expect_true(is_tibble(set_afr))
})
