# R package PxWebApiData

[![Mentioned in Awesome Official
Statistics](https://awesome.re/mentioned-badge.svg)](http://www.awesomeofficialstatistics.org)

| [PxWebApiData on CRAN](https://cran.r-project.org/package=PxWebApiData) |     | [pkgdown website](https://statisticsnorway.github.io/ssb-pxwebapidata/) |     | [GitHub Repository](https://github.com/statisticsnorway/ssb-pxwebapidata) |
|-------------------------------------------------------------------------|-----|-------------------------------------------------------------------------|-----|---------------------------------------------------------------------------|

------------------------------------------------------------------------

**PX-Web data by API**: The R package **PxWebApiData** supports both
**PxWebApi v1** and **PxWebApi v2**.

The example code reads data from three national statistical institutes:
Statistics Norway, Statistics Sweden, and Statistics Finland.

------------------------------------------------------------------------

### PxWebApi v1

PxWebApi v1 is supported through the long-established ApiData()
interface.

📌 **Function reference:**

- [ApiData()](https://statisticsnorway.github.io/ssb-pxwebapidata/reference/ApiData.html)

📌 **Vignette:**

- [Using PxWebApi v1 with
  PxWebApiData](https://cran.r-project.org/web/packages/PxWebApiData/vignettes/pxwebapi_v1.html)

------------------------------------------------------------------------

### PxWebApi v2

PxWebApi v2 is supported through a set of new functions.

📌 **Function references:**

- [get_api_data()](https://statisticsnorway.github.io/ssb-pxwebapidata/reference/get_api_data.html)
  – retrieve data from a pre-made URL
- [query_url()](https://statisticsnorway.github.io/ssb-pxwebapidata/reference/query_url.html)
  – generate a data URL from specifications
- [api_data()](https://statisticsnorway.github.io/ssb-pxwebapidata/reference/api_data.html)
  – specify and retrieve data in one step (closely related to ApiData()
  for PxWebApi v1)
- [meta_frames()](https://statisticsnorway.github.io/ssb-pxwebapidata/reference/meta_frames.html)
  – metadata structured as data frames
- [meta_data()](https://statisticsnorway.github.io/ssb-pxwebapidata/reference/meta_data.html)
  – metadata downloaded without further processing
- [meta_code_list()](https://statisticsnorway.github.io/ssb-pxwebapidata/reference/meta_code_list.html)
  – metadata for code lists

📌 **Vignette:**

- [Using PxWebApi v2 with
  PxWebApiData](https://cran.r-project.org/web/packages/PxWebApiData/vignettes/pxwebapi_v2.html)

------------------------------------------------------------------------

Official version on CRAN:
<https://cran.r-project.org/package=PxWebApiData>
