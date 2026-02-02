## PxWebApiData 1.9.0
* Major update with new functions related to PxWebApi **v2**
  - `get_api_data()`: retrieve data from a pre-made URL
  - `query_url()`: generate a URL from specifications
  - `api_data()`: specify and retrieve data in one step
    - closely related to `ApiData()` for PxWebApi v1
  - `meta_frames()`: metadata structured as data frames
  - `meta_data()`: metadata downloaded without further processing
  - `meta_code_list()`: metadata for code lists, by default structured as a data frame
* The package now includes three vignettes
  - *Using PxWebApi v1 with PxWebApiData* (the original introduction vignette)
  - *Using PxWebApi v2 with PxWebApiData*
  - *Introduction to PxWebApiData*, which points to the two version-specific
    vignettes while preserving the original vignette URL


## PxWebApiData	1.1.1
* Extended `comment()` to include note elements and added `info()` and `note()` functions
  - Reflects an enhancement in the JSON-stat2 metadata, where *note* is introduced as a new field
  - Updated documentation for the `makeNAstatus` parameter to reference `note()` for explanation of NA status codes
  - Addresses [issue #18](https://github.com/statisticsnorway/ssb-pxwebapidata/issues/18)



## PxWebApiData	1.1.0
* Switch from readymade datasets to PxWebApi 2 for Statistics Norway examples  
  - Replaced readymade dataset examples  
  - Included text about PxWebApi 2 as the new primary API for Statistics Norway (v1 still available with POST)  
* Strengthened error handling for GET requests  
  - Added more robust checks of responses and status codes  


## PxWebApiData	1.0.0
* This package has been a stable workhorse, now updated to version 1.0.0.
* This package now has a documentation site at 
    [https://statisticsnorway.github.io/ssb-pxwebapidata](https://statisticsnorway.github.io/ssb-pxwebapidata/), 
     providing easy access to vignettes and guides.
* Now the  comment attribute also includes elements `tableid` and `contents` whenever these are available.
* Minor updates with no changes in functionality
  - Changed package license to MIT, in accordance with the policy at Statistics Norway.
  - Updated outdated region codes in the vignette under _Aggregations using filter agg_.
  - Some technical changes in documentation to comply with standards.


## PxWebApiData	0.9.0

* Minor update regarding warnings:
  - Previously, some warnings were suppressed to comply with the CRAN policy (refer to version 0.6.0 below). Now, these warnings are instead converted to messages.

## PxWebApiData	0.8.0

* `responseFormat`, new parameter to `ApiData` with `"json-stat2"` as default.
  - Previously, `"json-stat2"` was not used.
* Now a comment attribute with elements `label`, `source` and `updated` is added to output as a named three-element character vector.
  - Thus, the comment attribute has been changed from the previous version
  - Run the `comment` function to obtain this information.
* Eurostat data example included in the vignette.   
* More changes to meet CRAN policy as in version 0.6.0 (also when `apiPackage = "pxweb"`)  


## PxWebApiData	0.7.0

* `makeNAstatus`, new parameter to `ApiData` which represents new functionality.
  - When missing entries in `value`, the function tries to add an additional variable, named `NAstatus`, with status codes.


## PxWebApiData	0.6.0

* Changes to meet CRAN policy:
  - *Packages which use Internet resources should fail gracefully with an informative message if the resource is not available or has changed (and not give a check warning nor error).*

## PxWebApiData	0.5.0

* Possible to return a single data set as a data frame: First, second or both combined. 
  - Handled by the new parameter `returnDataSet`. Possible non-NULL values are `1`, `2` and `12`. 
  - New wrapper functions. Function names ending with `1`, `2` or `12`.

  
##  PxWebApiData	0.4.0

* Last version before any news
