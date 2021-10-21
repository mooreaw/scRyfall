# scRyfall

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/ndrewwm/scRyfall/workflows/R-CMD-check/badge.svg)](https://github.com/ndrewwm/scRyfall/actions)

`scRyfall` is an R-wrapper for the *Scryfall* API, built with *tidy* principles (e.g. results are returned as `tibble`s).

<!--
[Scryfall's API documentation.](https://scryfall.com/docs/api)

[Scryfall's syntax guide.](https://scryfall.com/docs/syntax)
-->

## Installation

This package is a work-in-progress and many features are not yet implemented. The package is not yet on CRAN, but you can install it using:

```r
devtools::install_github("ndrewwm/scRyfall")
```

## Cards

`search_cards()`

- Parses valid Scryfall [query syntax](https://scryfall.com/docs/syntax), and returns matching cards as a `tibble`.

```r
search_cards("c:U Mizz")
#> # A tibble: 7 × 67
#>   object id         oracle_id    multiverse_ids mtgo_id
#>   <chr>  <chr>      <chr>        <list>           <int>
#> 1 card   762d568d-… 48a909b6-e6… <list [1]>       57916
#> 2 card   d9859344-… 02d998a6-0a… <list [1]>       46307
#> 3 card   d0ea2c3a-… f787c6cf-a4… <list [1]>          NA
#> 4 card   1b1c4bed-… 899d58dc-60… <list [1]>          NA
#> 5 card   6f3d2dc5-… 33666a98-81… <list [1]>       69757
#> 6 card   56a2609d-… 10764b35-5c… <list [1]>       72022
#> 7 card   395465b8-… 959acb66-84… <list [1]>          NA
#> # … with 62 more variables: mtgo_foil_id <int>,
#> #   tcgplayer_id <int>, cardmarket_id <int>,
#> #   name <chr>, lang <chr>, released_at <chr>,
#> #   uri <chr>, scryfall_uri <chr>, layout <chr>,
#> #   highres_image <lgl>, image_status <chr>,
#> #   image_uris <list>, mana_cost <chr>, cmc <dbl>,
#> #   type_line <chr>, oracle_text <chr>, power <chr>, …
```

`get_card_by_name()`

```r
get_card_by_name("Ajani's Pridemate")
#> # A tibble: 1 × 63
#>   object id         oracle_id    multiverse_ids mtgo_id
#>   <chr>  <chr>      <chr>        <list>           <int>
#> 1 card   b3656310-… 95e94dea-5a… <list [1]>       71614
#> # … with 58 more variables: arena_id <int>,
#> #   tcgplayer_id <int>, cardmarket_id <int>,
#> #   name <chr>, lang <chr>, released_at <chr>,
#> #   uri <chr>, scryfall_uri <chr>, layout <chr>,
#> #   highres_image <lgl>, image_status <chr>,
#> #   image_uris <list>, mana_cost <chr>, cmc <dbl>,
#> #   type_line <chr>, oracle_text <chr>, power <chr>, …
```

`get_card_by_id()`

```r
get_card_by_id("e92c7477-d453-4fa4-acf4-3835ab9eb55a", "scryfall")
#> # A tibble: 1 × 61
#>   object id         oracle_id    multiverse_ids mtgo_id
#>   <chr>  <chr>      <chr>        <list>           <int>
#> 1 card   e92c7477-… 3407fe41-fd… <list [1]>       83095
#> # … with 56 more variables: arena_id <int>,
#> #   tcgplayer_id <int>, cardmarket_id <int>,
#> #   name <chr>, lang <chr>, released_at <chr>,
#> #   uri <chr>, scryfall_uri <chr>, layout <chr>,
#> #   highres_image <lgl>, image_status <chr>,
#> #   image_uris <list>, mana_cost <chr>, cmc <dbl>,
#> #   type_line <chr>, oracle_text <chr>, …
```

## Sets

`get_set_by_code()`

```r
get_set_by_code("mid")
#> # A tibble: 1 × 17
#>   object id     code  mtgo_code arena_code tcgplayer_id
#>   <chr>  <chr>  <chr> <chr>     <chr>             <int>
#> 1 set    44b8e… mid   mid       mid                2864
#> # … with 11 more variables: name <chr>, uri <chr>,
#> #   scryfall_uri <chr>, search_uri <chr>,
#> #   released_at <chr>, set_type <chr>,
#> #   card_count <int>, digital <lgl>,
#> #   nonfoil_only <lgl>, foil_only <lgl>,
#> #   icon_svg_uri <chr>
```

`get_set_by_id()`

```r
get_set_by_id()
```

`get_sets()`

```r
get_sets()
```
