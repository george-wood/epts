test_that("NULL path returns names of example files", {
  example_file <- epts_example()
  expect_true("fifa_example.txt" %in% example_file)
  expect_true("fifa_example.xml" %in% example_file)
  expect_true(is.character(example_file))
})

test_that("providing example file name returns full path", {
  expect_true(file.exists(epts_example("fifa_example.txt")))
})
