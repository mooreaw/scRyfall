test_that("All get_card_ functions return a tibble.", {
  cc_name <- get_card_by_name("Cryptic Command")
  cc_id   <- get_card_by_id("30f6fca9-003b-4f6b-9d6e-1e88adda4155")

  expect_true(is_tibble(cc_name))
  expect_true(is_tibble(cc_id))
})

test_that("The search_cards() function should return a tibble.", {
  expect_true(is_tibble(search_cards("!Negate")))
})

test_that("fuzzy = TRUE should give the same results as non fuzzy, assuming the same card", {
  cc_name_1 <- get_card_by_name("ajanis pridemate", fuzzy = TRUE)
  cc_name_2 <- get_card_by_name("Ajani's Pridemate")

  expect_equal(cc_name_1$name, cc_name_2$name)
  expect_equal(cc_name_1$scryfall_id, cc_name_2$scryfall_id)
  expect_equal(cc_name_1$set_name, cc_name_2$set_name)
})

test_that("Searching for a frequently printed card, by name, should return at least 1 result.", {
  n1 <- get_card_by_name("Negate")
  n2 <- search_cards("!Negate")

  expect_gt(nrow(n1), 0)
  expect_gt(nrow(n2), 0)
})

test_that("get_card_by_name() returns only one card at a time.", {
  nm_cards <- c("Ajani's Pridemate", "Elspeth, Knight Errant")

  res <- get_card_by_name(nm_cards)

  # only one card should be returned
  expect_equal(nrow(res), 1L)

  # the card returned should be the first supplied
  expect_equal(res$name, "Ajani's Pridemate")
})

test_that("get_card_by_id() will fail if the number of id types isn't equal to the number of cards.", {
  # 3 card IDs, 2 types
  id_cards <- c("30f6fca9-003b-4f6b-9d6e-1e88adda4155", "70901356-3266-4bd9-aacc-f06c27271de5", "b3656310-093d-4724-a399-7f7010843b1f")
  types <- c("scryfall", "scryfall")

  expect_error(get_card_by_id(id_cards, types))
})

test_that("When using the set argument, get_card_by_name() fails if you don't provide a set for each card.", {
  # assuming you're looking up cards from different sets, each card needs to get
  # a unique value for its set
  nm_cards <- c("Negate", "Ajani's Pridemate", "Shock")
  sets <- c("xln", "m19")

  expect_error(get_card_by_name(nm_cards, set = sets))

  # but, you can recycle a set over a list of cards you know are in the same set
  # expect_success(get_card_by_name(nm_cards, set = "m19"))
})

# TODO
test_that("Cards missing arena or MTGO IDs get NA in their columns.", {
  skip("Not implemented.")
})

test_that("Double-faced cards are handled sensibly.", {
  get_card_by_name("Delver of Secrets")
})
