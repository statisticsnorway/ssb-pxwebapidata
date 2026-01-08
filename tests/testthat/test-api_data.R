context("api_data.R")


# Helper functions copied from test-ApiData.R
Expect_equivalent <- function(a, b, ...) {
  if (is.null(a) | is.null(b)) {
    return(NULL)
  }
  expect_equivalent(a, b, ...)
} 
Expect_equal <- function(a, b, ...) {
  if (is.null(a) | is.null(b)) {
    return(NULL)
  }
  expect_equal(a, b, ...)
} 


test_that("api_data - SCB-data", {
  url_scb <- "https://statistikdatabasen.scb.se/api/v2/tables/TAB4537/data?lang=sv"
  a1 <- api_data(url_scb, Region = "??", Kon = "2", ContentsCode = "000000VK", Tid = c("2016", "2017"))
  query_url_scb <- query_url(url_scb, Region = "00", Kon = 1, ContentsCode = 0, Tid = 1:2, use_index = TRUE)
  a2 <- get_api_data(query_url_scb)
  a3 <- api_data(url_scb, Region = 1, Kon = "kvinnor", ContentsCode = TRUE, Tid = 2:3)
  Expect_equal(a1, a2)
  Expect_equal(a1, a3)
})


test_that("api_data - makeNAstatus is in use", {
  skip_on_cran()
  a <- api_data_2("04469", Tid = "2020", ContentsCode = 1, Alder = TRUE, Region = "3011")
  if (!is.null(a)) {
    NAstatus <- a$NAstatus
    names(NAstatus) = a$Alder
    NAstatus[c("999", "0-66", "67-74", "75-79", "80-84", "85-89", "090+", "888")]
    expect_equal(
      as.character(NAstatus[c("999", "0-66", "67-74", "75-79", "80-84", "85-89", "090+", "888")]), 
      c(NA, ":", ":", ":", ":", ":", ":", ".."))
  }
})



test_that("api_data - metadata", {
  skip_on_cran() # to avoid elapsed time > 5s
  url_scb <- "https://statistikdatabasen.scb.se/api/v2/tables/TAB4537/data?lang=en"
  mf <- meta_frames(url_scb)
  if (!is.null(mf)) {
    expect_equal(sapply(mf[c("Kon", "Tid")], attr, "elimination"), c(Kon = TRUE, Tid = FALSE))
    url_code_list <- attr(mf[["Region"]], "code_lists")$links[1]
    df <- meta_code_list(url_code_list)
    if (!is.null(df)) {
      expect_true(all(c("code", "label", "valueMap") %in% names(df)))
    }
  }
})



test_that("api_data - dataset output and info/note", {
  skip_on_cran() # to avoid elapsed time > 5s
  a <- api_data(4861, Region = c("1103", "0301"), ContentsCode = 2, Tid = c(1, -1))
  a1 <- api_data_1(4861, Region = c("1103", "0301"), ContentsCode = 2, Tid = c(1, -1))
  a2 <- api_data_2(4861, Region = c("1103", "0301"), ContentsCode = 2, Tid = c(1, -1))
  a12 <- api_data_12(4861, Region = c("1103", "0301"), ContentsCode = 2, Tid = c(1, -1))
  Expect_equal(a1, a[[1]])
  Expect_equal(a2, a[[2]])
  Expect_equivalent(a1, a12[, names(a1)])
  Expect_equivalent(a2, a12[, names(a2)])
  if (!is.null(a) & !is.null(a1) & !is.null(a12)) {
    expect_equal(as.vector(sort(comment(a))), as.vector(sort(c(info(a1), note(a12)))))
  }
})
