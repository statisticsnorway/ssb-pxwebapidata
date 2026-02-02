# Ensure JSON-stat2 output format in PxWebApi v2 URLs

Ensures that a PxWebApi v2 URL requests data in JSON-stat2 format by
enforcing `outputFormat=json-stat2`.

## Usage

``` r
ensure_json_stat2(url)
```

## Arguments

- url:

  A character string of length one giving a PxWebApi v2 data URL.

## Value

A character string with `outputFormat=json-stat2` enforced.

## Details

The function behaves as follows:

- If the URL already contains `outputFormat=json-stat2`, it is returned
  unchanged.

- If the URL contains an `outputFormat` parameter with another value
  (e.g. `csv`), only the value is replaced by `json-stat2`, leaving the
  rest of the URL unchanged.

- If the URL does not contain any `outputFormat` parameter,
  `outputFormat=json-stat2` is appended.

Matching of parameter names and values is case-insensitive, but the
resulting URL always uses the canonical camelCase form
`outputFormat=json-stat2`.

This function is intended for internal use to guarantee a consistent and
standardized output format across different PxWebApi v2 providers.

## Note

This function is written and documented with help from ChatGPT.

## Examples

``` r
url1 <- "https://api.no/data?lang=en"
url1
#> [1] "https://api.no/data?lang=en"
ensure_json_stat2(url1)
#> [1] "https://api.no/data?lang=en&outputFormat=json-stat2"

url2 <- paste0(url1, "&valueCodes[Tid]=top(2)")
url2
#> [1] "https://api.no/data?lang=en&valueCodes[Tid]=top(2)"
ensure_json_stat2(url2)
#> [1] "https://api.no/data?lang=en&valueCodes[Tid]=top(2)&outputFormat=json-stat2"

url3 <- paste0(url1, "&outputFormat=csv&valueCodes[Tid]=?")
url3
#> [1] "https://api.no/data?lang=en&outputFormat=csv&valueCodes[Tid]=?"
ensure_json_stat2(url3)
#> [1] "https://api.no/data?lang=en&outputFormat=json-stat2&valueCodes[Tid]=?"
```
