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
