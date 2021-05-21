# scRyfall

Scryfall is an R-wrapper for the *Scryfall* API.

A link to Scryfall's API documentation [is here.](https://scryfall.com/docs/api)

## Installation

This package is very much a work-in-progress and many features are not implemented yet, but if you want to install the package to take a look at things locally, you can use:

```
devtools::install_github("mooreaw/scRyfall")
```

## Basic Use

`search_cards()`

- Parses valid Scryfall query syntax, and returns matching cards as a `tibble`.

```
> search_cards("c:U Mizz")
# A tibble: 7 x 12
  name   scryfall_id collector_number mana_cost set   set_name   cmc type 
  <chr>  <chr>       <chr>            <chr>     <chr> <chr>    <dbl> <chr>
1 Mizzi… 762d568d-a… 64               {2}{U}    ori   Magic O…     3 Crea…
2 Mizzi… d9859344-4… 45               {U}       rtr   Return …     1 Inst…
3 Mizzi… d0ea2c3a-c… 50               {2}{U}{R} c15   Command…     4 Lege…
4 Niv-M… 1b1c4bed-9… 184              {2}{U}{U… c17   Command…     6 Lege…
5 Niv-M… 6f3d2dc5-7… 192              {U}{U}{U… grn   Guilds …     6 Lege…
6 Niv-M… 56a2609d-b… 208              {W}{U}{B… war   War of …     5 Lege…
7 Niv-M… 395465b8-f… 225              {2}{U}{U… c20   Command…     6 Lege…
# … with 4 more variables: rarity <chr>, text <chr>, colors <list>,
#   color_identity <list>
```

`get_cards_by_name()`

- Convenience function, in case you are just trying to find cards by name
- Can search for multiple cards if passed a vector of card names

```
> get_card_by_name("Ajani's Pridemate")
# A tibble: 1 x 12
  name   scryfall_id collector_number mana_cost set   set_name   cmc type 
  <chr>  <chr>       <chr>            <chr>     <chr> <chr>    <dbl> <chr>
1 Ajani… b3656310-0… 4                {1}{W}    war   War of …     2 Crea…
# … with 4 more variables: rarity <chr>, text <chr>, colors <list>,
#   color_identity <list>
```
