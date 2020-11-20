## ----include = FALSE----------------------------------------------------------
library(knitr)
library(PxWebApiData)
options(max.print = 50)

## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------
ApiData("http://data.ssb.no/api/v0/en/table/04861", 
        Region = c("1103", "0301"), ContentsCode = "Bosatte", Tid = c(1, 2, -2, -1))


## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------

x <- ApiData("http://data.ssb.no/api/v0/en/table/04861", 
        Region = FALSE, ContentsCode = TRUE, Tid = 3i)


## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------

x[[1]]

x[[2]]

## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------
ApiData("http://data.ssb.no/api/v0/en/table/04861",  returnMetaFrames = TRUE)


## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------
ApiData("http://data.ssb.no/api/v0/no/table/07459", 
        Region = list("agg:KommSummer", c("K-3001", "K-3002")), 
        Tid = 3i,
        Alder = list("agg:TodeltGrupperingB", c("H17", "H18")),
        Kjonn = TRUE)



## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------
ApiData("http://data.ssb.no/api/v0/en/table/04861",  returnApiQuery = TRUE)


## ----eval=TRUE, comment=NA, tidy=FALSE----------------------------------------
x <- ApiData("https://data.ssb.no/api/v0/dataset/934516.json?lang=en", getDataByGET = TRUE)
x[[1]]


## -----------------------------------------------------------------------------

library(PxWebApiData)


## -----------------------------------------------------------------------------

variables <- ApiData("https://data.ssb.no/api/v0/no/table/07964/", 
                     returnMetaFrames = TRUE)

names(variables)


## -----------------------------------------------------------------------------

values <- ApiData("https://data.ssb.no/api/v0/no/table/07964/", 
                  returnMetaData = TRUE)

values[[1]]$values
values[[2]]$values
values[[3]]$values


## -----------------------------------------------------------------------------

data <- ApiData("https://data.ssb.no/api/v0/en/table/07964/",
                Tid = c("2017", "2018"), # Define year to 2017 and 2018
                NACE2007 = "G-N", # Define the services sector
                ContentsCode = c("KvinneligFoUpers")) # Define women R&D personell

data <- data[[1]] # Extract the first list element, which contains full variable names.

head(data)


