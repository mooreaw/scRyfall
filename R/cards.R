
#' Retrieve a card from the Scryfall API using the card's name.
#'
#' For both exact and fuzzy, card names are case-insensitive and punctuation is
#' optional (you can drop apostrophes and periods etc). For example: fIReBALL is
#' the same as Fireball and smugglers copter is the same as Smuggler's Copter.
#'
#' @param name The card name to be searched for.
#' @param fuzzy Whether to search for an exact match, or to use a fuzzy search.
#' @param set (Optional) A set code to limit the search to one set.
#'
#' @return A tibble containing card information.
#'
#' @importFrom attempt stop_if stop_if_not stop_if_any
#' @import httr
#' @import stringr
#' @import purrr
#'
#' @export
get_card_by_name <- function(name, fuzzy = FALSE, set = NULL) {
  stop_if(name, is.null, msg = "A name must be supplied in order to request card data.")
  stop_if_not(name, is.character, msg = "Please provide a string.")

  name <- name %>%
    str_remove_all("[[:punct:]]") %>%
    str_squish() %>%
    str_replace_all(" ", "+")

  base_url <- "https://api.scryfall.com/cards/named?"

  if (fuzzy) {
    url <- str_c(base_url, "fuzzy=", name)
  } else {
    url <- str_c(base_url, "exact=", name)
  }

  if (!is.null(set)) {
    url <- str_c(url, "&set=", set)
  }

  card_content <- map(
    url,
    function(link) {
      Sys.sleep(.5) # UPDATE ME
      res <- GET(link)
      check_status(res)
      content(res)
    }
  )

  unpack_card_response(card_content)
}

#' Retrieve a card from the Scryfall API using the card's ID.
#'
#' @param id ID value(s) to search for.
#' @param type Which ID type to use ("scryfall" (default), "mtgo", "arena", "collector", "multiverse").
#' @param face Which card face to return.
#' @param version Which image version to return ("" (default), "small", "normal", "large").
#' @param set Which set to request (Optional).
#'
#' @return A tibble containing card information.
#'
#' @export
get_card_by_id <- function(id, type = "scryfall", format = NULL, face = NULL, version = NULL, set = NULL) {

  stop_if(id, is.null, msg = "An ID must be supplied in order to request card data.")
  stop_if_any(type, ~!. %in% c("scryfall", "mtgo", "arena", "collector", "multiverse"), msg = "Please use a valid ID type ('scryfall', 'mtgo', 'arena', 'collector').")

  if (length(id) > 1 & length(type) > 1 & length(type) != length(id)) {
    stop("Please specify an individual ID type for each card, or use a single ID type.")
  }

  # stop_if_any(id, ~str_detect(., "[A-Z}|[a-z]|[[:punct:]]"), msg = "ID values must contain only numeric values.")

  base_url <- "https://api.scryfall.com/cards/"

  url <- case_when(
    type == "scryfall"   ~ str_c(base_url, "", id, "/"),
    type == "mtgo"       ~ str_c(base_url, "mtgo/", id, "/"),
    type == "arena"      ~ str_c(base_url, "arena/", id, "/"),
    type == "multiverse" ~ str_c(base_url, "multiverse/", id, "/"),
    TRUE                 ~ str_c(base_url, "collector/", id, "/")
  )

  card_content <- map(
    url,
    function(link) {
      Sys.sleep(.5) # UPDATE ME
      res <- GET(link)
      check_status(res)
      content(res)
    }
  )

  unpack_card_response(card_content)
}

# FIXME: need to figure out a clean way to ensure that all the IDs are returned
# even if they're null

#' Return card API results as a data frame.
#'
#' @param card_content List of card information to be converted into a tibble.
#'
#' @return A tibble with unpacked card information.
#'
#' @import dplyr
#' @import tibble
unpack_card_response <- function(card_content) {
  tibble(
    name             = map_chr(card_content, "name"),
    scryfall_id      = map_chr(card_content, "id"),
    oracle_id        = map_chr(card_content, "oracle_id"),
    multiverse_ids   = map(card_content, "multiverse_ids"),
    # arena_id         = map_chr(card_content, "arena_id"),
    # mtgo_id          = map_chr(card_content, "mtgo_id"),
    # mtgo_foil_id     = map_chr(card_content, "mtgo_foil_id"),
    collector_number = map_chr(card_content, "collector_number"),
    mana_cost        = map_chr(card_content, "mana_cost"),
    set              = map_chr(card_content, "set"),
    set_name         = map_chr(card_content, "set_name"),
    cmc              = map_dbl(card_content, "cmc"),
    type             = map_chr(card_content, "type_line"),
    text             = map_chr(card_content, "oracle_text"),
    colors           = map(card_content, "colors"),
    color_identity   = map(card_content, "color_identity")
  )
}
