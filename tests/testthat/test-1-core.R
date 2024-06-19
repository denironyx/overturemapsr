


test_that("get_all_overture_types returns all overture types", {
  expected_types <- names(all_type_theme_map())
  result <- get_all_overture_types()

  expect_type(result, "character")
  expect_equal(sort(result), sort(expected_types))
  expect_length(result, length(expected_types))
})

test_that("dataset_path returns correct S3 path for a given type", {
  test_type <- "building"
  expected_path <- paste0("s3://overturemaps-us-west-2/release/2024-05-16-beta.0/theme=buildings/type=building/")

  result <- dataset_path(test_type)
  expect_type(result, "character")
  expect_equal(result, expected_path)
})

