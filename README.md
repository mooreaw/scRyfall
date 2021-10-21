# scRyfall

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/ndrewwm/scRyfall/workflows/R-CMD-check/badge.svg)](https://github.com/ndrewwm/scRyfall/actions)

`scRyfall` is an R-wrapper for the *Scryfall* API.

[Scryfall's API documentation](https://scryfall.com/docs/api) [Scryfall's syntax guide](https://scryfall.com/docs/syntax)

## Installation

This package is a work-in-progress and many features are not yet implemented. The package is not yet on CRAN, but you can install it using:

```r
devtools::install_github("ndrewwm/scRyfall")
```

## Cards

`search_cards()`

- Parses valid Scryfall query syntax, and returns matching cards as a `tibble`.

```r
search_cards("c:U Mizz")
```

`get_card_by_name()`

```r
get_card_by_name("Ajani's Pridemate")
```

`get_card_by_id()`

```r
get_card_by_id("e92c7477-d453-4fa4-acf4-3835ab9eb55a", "scryfall")
```

## Sets

`get_set_by_code()`

```r
get_set_by_code("mid")
```

`get_set_by_id()`

```r
get_set_by_id()
```

`get_sets()`

```r
get_sets()
```
