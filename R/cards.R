
#' Retrieve a card from the Scryfall API using the card's name.
#'
#' For both exact and fuzzy, card names are case-insensitive and punctuation is
#' optional (you can drop apostrophes and periods etc). For example: "fIReBALL" is
#' the same as "Fireball" and "smugglers copter" is the same as "Smuggler's Copter".
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
#' @import tidyr
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

  Sys.sleep(1)
  req <- GET(url)
  res <- content(req)

  tibble(i = 1) %>%
    mutate(data = lst(res)) %>%
    unnest_wider(data) %>%
    select(-i)
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

  Sys.sleep(1)
  req <- GET(url)
  res <- content(req)

  tibble(i = 1) %>%
    mutate(data = lst(res)) %>%
    unnest_wider(data) %>%
    select(-i)
}

#' Search for cards based on scryfall's search syntax.
#'
#' Scryfall's API returns a maximum of 175 cards per page.
#'
#' @param q Query, using scryfall's syntax.
#' @param unique Whether scryfall should remove possible duplicates in the results ("cards" (default), "art", "prints")
#' @param order Method for how the returned cards should be sorted.
#' @param dir The direction to sort cards.
#' @param include_extras When TRUE, extra cards (e.g. tokens) will be included (default: FALSE).
#' @param page Which page number to return; defaults to 1.
#'
#' @return A tibble containing card information.
#'
#' Scryfall's search syntax reference can be [found here.](https://scryfall.com/docs/syntax) Below is further information on different options that can be specified for the function arguments.
#'
#' _**`unique`**_
#'
#' Further information on `unique`, from scryfall's documentation:
#'
#' - *cards* (default) Removes duplicate gameplay objects (cards that share a name and have the same functionality). For example, if your search matches more than one print of Pacifism, only one copy of Pacifism will be returned.
#' - *art* Returns only one copy of each unique artwork for matching cards. For example, if your search matches more than one print of Pacifism, one card with each different illustration for Pacifism will be returned, but any cards that duplicate artwork already in the results will be omitted.
#' - *prints* Returns all prints for all cards matched (disables rollup). For example, if your search matches more than one print of Pacifism, all matching prints will be returned.
#'
#' _**`order`**_
#'
#' Further information on `order`, from scryfall's documentation:
#'
#' - *name* (default) Sort cards by name, A → Z
#' - *set* Sort cards by their set and collector number: AAA/#1 → ZZZ/#999
#' - *released* Sort cards by their release date: Newest → Oldest
#' - *rarity* Sort cards by their rarity: Common → Mythic
#' - *color* Sort cards by their color and color identity: WUBRG → multicolor → colorless
#' - *usd* Sort cards by their lowest known U.S. Dollar price: 0.01 → highest, null last
#' - *tix* Sort cards by their lowest known TIX price: 0.01 → highest, null last
#' - *eur* Sort cards by their lowest known Euro price: 0.01 → highest, null last
#' - *cmc* Sort cards by their converted mana cost: 0 → highest
#' - *power* Sort cards by their power: null → highest
#' - *toughness* Sort cards by their toughness: null → highest
#' - *edhrec* Sort cards by their EDHREC ranking: lowest → highest
#' - *artist* Sort cards by their front-side artist name: A → Z
#'
#' _**`dir`**_
#'
#' - *auto* (default) Scryfall will automatically choose the most inuitive direction to sort
#' - *asc* Sort ascending (the direction of the arrows in the previous table)
#' - *desc* Sort descending (flip the direction of the arrows in the previous table)
#'
#' @export
search_cards <- function(q, unique = "cards", order = "name", dir = "auto", include_extras = FALSE, page = 1) {
  base_url <- "https://api.scryfall.com/cards/search/"

  qry <- utils::URLencode(q, reserved = TRUE)
  url <- str_glue("{base_url}?order={order}&unique={unique}&dir={dir}&q={qry}")

  Sys.sleep(1)
  req <- GET(url)

  # TODO: this error message is unhelpful, come up with something better
  stop_if(status_code(req), ~. != 200, msg = "Bad request")

  res0 <- content(req)
  more <- res0$has_more

  # handle instances where the query returns more than 175 cards
  if (more) {
    cards <- unpack_card_response(res0)
    res_l <- res0

    while (more) {
      Sys.sleep(1)

      req_new <- GET(res_l$next_page)

      stop_if(status_code(req_new), ~. != 200, msg = "Paging failed...")

      res_n <- content(req_new)
      cards <- bind_rows(cards, unpack_card_response(res_n))

      more <- res_n$has_more

      if (more) res_l <- res_n
    }

    cards
  } else {
    unpack_card_response(res0)
  }
}

#' Return card API results as a data frame.
#'
#' @param req Response object, containing a list of card information to be converted into a tibble.
#'
#' @return A tibble with unpacked card information.
#'
#' @import dplyr
#' @import tibble
unpack_card_response <- function(req) {
  as_tibble(req) %>%
    select(data) %>%
    unnest_wider(data)
}
