# Create a data.frame from a structured list

Converts a structured, column-oriented list into a flat `data.frame`,
using the first element of the list to define the expected structure
(length and names).

## Usage

``` r
list_to_df_expand(x, category_col = "category", dropped_attr = "dropped")
```

## Arguments

- x:

  A named list. Each element is expected to have the same length and
  names as the first element.

- category_col:

  Name of the column containing category labels. If `NULL`, no category
  column is added and category labels are used as row names instead.

- dropped_attr:

  Name of the attribute used to store excluded elements (stored
  unchanged). If `NULL`, no such attribute is added.

## Value

A `data.frame` with one row per category and one or more columns per
retained list element.

## Details

Only elements matching the structure of the first element are included
in the result. Other elements are excluded. Optionally, excluded
elements can be stored unchanged as an attribute.

Nested lists or multi-element vectors are expanded into multiple columns
so that the returned data frame never contains list columns.

This function is intended for column-oriented or table-like list
structures, such as those commonly found in JSON metadata or dimension
specifications.

## Note

This function is written and documented with help from ChatGPT.

## Examples

``` r
x <- list(
  A = c(a = 1, b = 2, c = 3),
  B = list(
    a = c(x = 10, y = 20),
    b = c(x = 11, y = 21),
    c = c(x = 12, y = 22)
  ),
  bad = c(a = 1, b = 2)  # wrong length -> excluded
)

df <- list_to_df_expand(x)
df
#>   category A B.x B.y
#> 1        a 1  10  20
#> 2        b 2  11  21
#> 3        c 3  12  22

attr(df, "dropped")
#> $bad
#> a b 
#> 1 2 
#> 

# Use row names instead of a category column:
df2 <- list_to_df_expand(x, category_col = NULL)
df2
#>   A B.x B.y
#> a 1  10  20
#> b 2  11  21
#> c 3  12  22

# Disable storing excluded elements:
df3 <- list_to_df_expand(x, dropped_attr = NULL)
df3
#>   category A B.x B.y
#> 1        a 1  10  20
#> 2        b 2  11  21
#> 3        c 3  12  22
```
