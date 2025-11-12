# MakeUrl from id

MakeUrl from id

## Usage

``` r
MakeUrl(id, urlType = "SSB")
```

## Arguments

- id:

  integer

- urlType:

  Currently two possibilities: "SSB" (Norwegian) or "SSBen" (English)

## Value

url as string

## Examples

``` r
MakeUrl(4861)
#> [1] "https://data.ssb.no/api/v0/no/table/04861"
MakeUrl(4861, "SSBen")
#> [1] "https://data.ssb.no/api/v0/en/table/04861"
```
