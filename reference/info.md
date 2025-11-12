# Extract info or note parts of the comment attribute

The functions `info()` and `note()` provide access to different parts of
an object's comment attribute, which is accessed by
[`comment()`](https://rdrr.io/r/base/comment.html).

## Usage

``` r
info(x)

note(x)
```

## Arguments

- x:

  Object with a `comment` attribute.

## Value

- `note()` returns all elements in the `comment` attribute that
  originate from the *note* field. The `"note"` name is then removed.

- `info()` returns the remaining elements in the `comment` attribute.

## Details

The `comment` attribute is assumed to be derived from JSON-stat2
metadata, where some elements originate from text in a *note* field.

The `comment` attribute of data downloaded by the package is constructed
by `c(unlist(obj[c("label", "source", "updated")]),`
`unlist(obj$extension$px[c("tableid", "contents")]),`
`unlist(obj["note"]))`

where `obj` is a list containing the JSON-stat2 metadata. Thus, possible
none-existing elements are ignored.
