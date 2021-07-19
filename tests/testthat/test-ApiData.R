context("ApiData.R")


test_that("ApiData - Readymade SSB-data with urlType", {
  skip_on_cran()
  ssb1066 <- ApiData(1066, getDataByGET = TRUE, urlType = "SSB")
  expect_true(is.data.frame(ssb1066[[1]]))
  expect_equal(names(ssb1066)[2], "dataset")
  expect_true(grepl("etter næring, måned og statistikkvariabel", names(ssb1066)[1]))
})

test_that("ApiData - SCB-data using TRUE and FALSE", {
  skip_on_cran()
  urlSCB <- "https://api.scb.se/OV0104/v1/doris/sv/ssd/BE/BE0101/BE0101A/BefolkningNy"
  a1 <- ApiData(urlSCB, Region = FALSE, Civilstand = "G", Alder = "19", Kon = "2", ContentsCode = c("Folkmängd", "Folkökning"), Tid = "1969")
  a2 <- ApiData(urlSCB, Region = FALSE, Civilstand = "gifta", Alder = "19 år", Kon = "kvinnor", ContentsCode = c("BE0101N1", "BE0101N2"), Tid = "1969")
  a3 <- ApiData(urlSCB, Region = FALSE, Civilstand = 2, Alder = 20, Kon = 2, ContentsCode = TRUE, Tid = 2)
  expect_equal(is.data.frame(a1[[1]]), TRUE)
  expect_equal(is.integer(a1[[1]][, "value"]), TRUE)
  expect_equal(is.character(a1[[2]][, "ContentsCode"]), TRUE)
  expect_equal(a1[[1]][, "value"], a1[[2]][, "value"])
  expect_equal(a1, a2)
  expect_equal(a1, a3)
})

if(FALSE) # url not working
test_that("ApiData - StatFin-data with special characters", {
  skip_on_cran()
  urlStatFin <- "https://pxnet2.stat.fi/PXWeb/api/v1/en/StatFin/eli/eot/asui/statfin_eot_pxt_11wu.px"
  url2 = "https://pxnet2.stat.fi/PXWeb/api/v1/en/StatFin/maa/akmer/statfin_akmer_pxt_001.px"
  #urlStatFin <- "https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/tym/tyonv/statfin_tyonv_pxt_001.px"
  
  a1 <- ApiData(urlStatFin, `Henkilön kotitalouden elinvaihe` = "10",
                `Vakava aineellinen puute ja vajaatyöllisyys` = "SS",
                Tiedot = TRUE,
                Vuosi = c("2008","2009"))
                #Kuukausi = c("2006M02"), Alue2018 = c("005"), Muuttujat = c("TYOTTOMAT"))
  
  a1 <- ApiData(urlStatFin, Kuukausi = c("2006M02"), Alue2018 = c("005"), Muuttujat = c("TYOTTOMAT"))
  a2 <- ApiData(urlStatFin, Kuukausi = "2006M02", Alue2018 = "Alajärvi Kunta", Muuttujat = "Työttömät")
  a3 <- ApiData(urlStatFin, Kuukausi = 2, Alue2018 = 2, Muuttujat = 2)
  expect_equal(a1[[1]]$Alue2018, "Alajärvi Kunta")
  expect_equal(a1, a2)
  expect_equal(a1, a3)
})


test_that("ApiData - SSB-data advanced use", {
  skip_on_cran()
  urlSSB <- "https://data.ssb.no/api/v0/en/table/04861"
  a1 <- ApiData(urlSSB, Region = list("039*"), ContentsCode = TRUE, Tid = 2i)
  a2 <- ApiData(urlSSB, Region = "0399", ContentsCode = list("all", "*"), Tid = -(1:2))
  a3 <- ApiData(urlSSB, Region = "Uoppgitt komm. Oslo", ContentsCode = c("Area of urban settlements (km²)", "Bosatte"), Tid = list("top", "2"))
  expect_equal(a1, a2)
  expect_equal(a1, a3)
})


test_that("ApiData - SSB-data with returnMetaFrames", {
  skip_on_cran()
  urlSSB <- "https://data.ssb.no/api/v0/en/table/04861"
  mf <- ApiData(urlSSB, returnMetaFrames = TRUE)
  expect_equal(names(mf), c("Region", "ContentsCode", "Tid"))
  expect_equivalent(attr(mf, "text")[c("Region", "ContentsCode", "Tid")], c("region", "contents", "year"))
  expect_equivalent(c(attr(mf, "elimination"), attr(mf, "time")), c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE))
  expect_equal(mf[[1]]$valueTexts[mf[[1]]$values == "0121"], "Rømskog (-2019)") 
  expect_equal(mf[[2]]$valueTexts, c("Area of urban settlements (km²)", "Number of residents"))
  expect_equivalent(sapply(mf, class), rep("data.frame", 3))
  expect_equivalent(sapply(mf[[3]], class), c("character", "character"))
})

test_that("ApiData - dataset output", {
  skip_on_cran()
  a   <- ApiData(4861, Region = c("1103", "0301"), ContentsCode=2, Tid=c(1, -1)) 
  a1  <- ApiData1(4861, Region = c("1103", "0301"), ContentsCode=2, Tid=c(1, -1)) 
  a2  <- ApiData2(4861, Region = c("1103", "0301"), ContentsCode=2, Tid=c(1, -1)) 
  a12 <- ApiData12(4861, Region = c("1103", "0301"), ContentsCode=2, Tid=c(1, -1)) 
  
  expect_equivalent(a1, a[[1]])
  expect_equivalent(a2, a[[2]])
  expect_equivalent(a1, a12[, names(a1)])
  expect_equivalent(a2, a12[, names(a2)])
  expect_equal(names(a[[1]]), names(a1))
  expect_equal(names(a[[2]]), names(a2))
  expect_equal(comment(a12), names(a))
  expect_equal(comment(a1), comment(a12)[1])
  expect_equal(comment(a2), comment(a12)[2])

  a   <-   GetApiData("https://data.ssb.no/api/v0/dataset/1066.json?lang=en") 
  a1  <-  GetApiData1("https://data.ssb.no/api/v0/dataset/1066.json?lang=en") 
  a2  <-  GetApiData2("https://data.ssb.no/api/v0/dataset/1066.json?lang=en") 
  a12 <- GetApiData12("https://data.ssb.no/api/v0/dataset/1066.json?lang=en") 
  
  expect_equivalent(a1, a[[1]])
  expect_equivalent(a2, a[[2]])
  expect_equivalent(a1, a12[, names(a1)])
  expect_equivalent(a2, a12[, names(a2)])
  expect_equal(names(a[[1]]), names(a1))
  expect_equal(names(a[[2]]), names(a2))
  expect_equal(comment(a12), names(a))
  expect_equal(comment(a1), comment(a12)[1])
  expect_equal(comment(a2), comment(a12)[2])
  

  if(FALSE){
    a   <-   PxData("https://api.scb.se/OV0104/v1/doris/sv/ssd/BE/BE0101/BE0101A/BefolkningNy", Region = TRUE, Civilstand = TRUE, Alder = 1:10, Kon = FALSE, ContentsCode = "BE0101N1", Tid = 1:10, verbosePrint = TRUE)
    a1  <-  PxData1("https://api.scb.se/OV0104/v1/doris/sv/ssd/BE/BE0101/BE0101A/BefolkningNy", Region = TRUE, Civilstand = TRUE, Alder = 1:10, Kon = FALSE, ContentsCode = "BE0101N1", Tid = 1:10, verbosePrint = TRUE)
    a2  <-  PxData2("https://api.scb.se/OV0104/v1/doris/sv/ssd/BE/BE0101/BE0101A/BefolkningNy", Region = TRUE, Civilstand = TRUE, Alder = 1:10, Kon = FALSE, ContentsCode = "BE0101N1", Tid = 1:10, verbosePrint = TRUE)
    a12 <- PxData12("https://api.scb.se/OV0104/v1/doris/sv/ssd/BE/BE0101/BE0101A/BefolkningNy", Region = TRUE, Civilstand = TRUE, Alder = 1:10, Kon = FALSE, ContentsCode = "BE0101N1", Tid = 1:10, verbosePrint = TRUE)
    expect_equivalent(a1, a[[1]])
    expect_equivalent(a2, a[[2]])
    expect_equivalent(a1, a12[, names(a1)])
    expect_equivalent(a2, a12[, names(a2)])
    expect_equal(names(a[[1]]), names(a1))
    expect_equal(names(a[[2]]), names(a2))
    expect_equal(comment(a12), names(a))
    expect_equal(comment(a1), comment(a12)[1])
    expect_equal(comment(a2), comment(a12)[2])
  }
  
  a    <-   PxData("01222", c("1103", "0301"), c(4, 9), 2i)
  a1   <-  PxData1("01222", c("1103", "0301"), c(4, 9), 2i)
  a2   <-  PxData2("01222", c("1103", "0301"), c(4, 9), 2i)
  a12  <- PxData12("01222", c("1103", "0301"), c(4, 9), 2i)
  
  expect_equivalent(a1, a[[1]])
  expect_equivalent(a2, a[[2]])
  expect_equivalent(a1, a12[, names(a1)])
  expect_equivalent(a2, a12[, names(a2)])
  expect_equal(names(a[[1]]), names(a1))
  expect_equal(names(a[[2]]), names(a2))
  expect_equal(comment(a12), names(a))
  expect_equal(comment(a1), comment(a12)[1])
  expect_equal(comment(a2), comment(a12)[2])
  
  
  b   <-   pxwebData("01222", c("1103", "0301"), c(4, 9), 2i)
  b1  <-  pxwebData1("01222", c("1103", "0301"), c(4, 9), 2i)
  b2  <-  pxwebData2("01222", c("1103", "0301"), c(4, 9), 2i)
  b12 <- pxwebData12("01222", c("1103", "0301"), c(4, 9), 2i)
  
  
  expect_equivalent(b1, b[[1]])
  expect_equivalent(b2, b[[2]])
  expect_equivalent(b1, b12[, names(b1)])
  expect_equivalent(b2, b12[, names(b2)])
  expect_equal(names(b[[1]]), names(b1))
  expect_equal(names(b[[2]]), names(b2))
  expect_equal(comment(b12), names(b))
  expect_equal(comment(b1), comment(b12)[1])
  expect_equal(comment(b2), comment(b12)[2])
  
  
})

















