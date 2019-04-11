## ----include = FALSE-----------------------------------------------------
library(knitr)
library(PxWebApiData)
options(max.print = 50)

## ----eval=TRUE, tidy = FALSE, comment=NA---------------------------------
ApiData("http://data.ssb.no/api/v0/en/table/04861", 
        Region = c("0811", "0301"), ContentsCode = "Bosatte", Tid = c(1, 2, -2, -1))


## ----eval=TRUE, tidy = FALSE, comment=NA---------------------------------

ApiData("http://data.ssb.no/api/v0/en/table/04861", 
        Region = FALSE, ContentsCode = TRUE, Tid = 3i)


## ----eval=TRUE, tidy = FALSE, comment=NA---------------------------------
ApiData("http://data.ssb.no/api/v0/en/table/04861",  returnMetaFrames = TRUE)


