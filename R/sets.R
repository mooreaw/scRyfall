#' Get a tibble of all MtG sets
#'
#' @return A tibble of sets
#'
#' @export
get_sets <- function() {
  base_url <- "https://api.scryfall.com/sets"

  Sys.sleep(5)
  req <- GET(base_url)
  res <- content(req)

  as_tibble(res)
}

#' Get an individual set based on its 3-letter identifier
#'
#' @param code The set's 3-letter code
#'
#' @return A tibble containing the requested set
#'
#' @export
get_set_by_code <- function(code) {
  base_url <- "https://api.scryfall.com/sets/"

  Sys.sleep(1)
  url <- str_c(base_url, str_squish(code))
  req <- GET(url)
  res <- content(req)

  as_tibble(res)
}

#' TODO
get_set_by_id <- function(id, type) {
  NULL
}
