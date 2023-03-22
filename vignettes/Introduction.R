## ----include = FALSE----------------------------------------------------------
library(knitr)
library(PxWebApiData)
options(max.print = 36)

## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------
ApiData("http://data.ssb.no/api/v0/en/table/04861",
        Region = c("1103", "0301"), ContentsCode = "Bosatte", Tid = c(1, 2, -2, -1))


## ----include = FALSE----------------------------------------------------------
options(max.print = 75)

## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------
ApiData12("http://data.ssb.no/api/v0/en/table/04861",
        Region = c("1103", "0301"), ContentsCode = "Bosatte", Tid = c(1, 2, -2, -1))


## ----include = FALSE----------------------------------------------------------
options(max.print = 45)

## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------

x <- ApiData("http://data.ssb.no/api/v0/en/table/04861",
        Region = FALSE, ContentsCode = TRUE, Tid = 3i)


## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------

x[[1]]

x[[2]]

## ---- comment=NA--------------------------------------------------------------

comment(x)


## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------
ApiData("http://data.ssb.no/api/v0/en/table/04861",  returnMetaFrames = TRUE)


## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------
ApiData("http://data.ssb.no/api/v0/no/table/07459",
        Region = list("agg:KommSummer", c("K-3001", "K-3002")),
        Tid = 4i,
        Alder = list("agg:TodeltGrupperingB", c("H17", "H18")),
        Kjonn = TRUE)



## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------
  Region = list("vs:Fylker",c("01","02"))
  Region = list(c("01","02"))


## ----eval=TRUE, tidy = FALSE, comment=NA--------------------------------------
ApiData("http://data.ssb.no/api/v0/en/table/04861",  returnApiQuery = TRUE)


## ----eval=TRUE, comment=NA, tidy=FALSE----------------------------------------
x <- GetApiData("https://data.ssb.no/api/v0/dataset/934516.json?lang=en")
x[[1]]
comment(x)


## ----eval=TRUE, tidy = FALSE, comment=NA, encoding = "UTF-8"------------------

urlEurostat <- paste0(   # Here the long url is split into several lines using paste0 
  "https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/prc_hicp_mv12r", 
  "?format=JSON&lang=EN&lastTimePeriod=2&coicop=CP00&geo=NO&geo=EU")
urlEurostat
GetApiData12(urlEurostat)


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

mydata <- ApiData("https://data.ssb.no/api/v0/en/table/07964/",
                Tid = c("2019", "2020"), # Define year to 2019 and 2020
                NACE2007 = "G-N", # Define the services sector
                ContentsCode = c("KvinneligFoUpers")) # Define women R&D personell

mydata <- mydata[[1]] # Extract the first list element, which contains full variable names.

head(mydata)


## -----------------------------------------------------------------------------

comment(mydata)


