# Convert a list of records to a data.frame

Converts a list where each element represents a record (row) into a
`data.frame`. Missing fields are filled with `NA`.

## Usage

``` r
list_records_to_df(x)
```

## Arguments

- x:

  A list of records. Each record should be a named list or similar
  structure. Records may have different sets of fields.

## Value

A `data.frame` with one row per record and columns corresponding to the
union of all field names.

## Details

List-valued fields are flattened by collapsing their contents into a
single character value. This guarantees that the returned data frame
contains no list columns, but nested structure is not preserved.

This function is intended for row-oriented data structures, such as JSON
arrays of objects.

## Note

This function is written and documented with help from ChatGPT.

## Examples

``` r
x <- list(
  list(id = 1, name = "Ada", tags = list("a", "b")),
  list(id = 2, name = "Bo"),
  list(id = 3, name = "Cy", tags = list("x"))
)

list_records_to_df(x)
#>   id name tags
#> 1  1  Ada a, b
#> 2  2   Bo <NA>
#> 3  3   Cy    x
```
