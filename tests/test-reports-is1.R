if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(site_url, "/project/HIPC/IS1/begin.view?pageId=Report")
context_of(file = "test-reports-is1.R",
           what = "IS1 Report",
           url = pageURL)

test_connection(remDr = remDr,
                pageURL = pageURL,
                expectedTitle = "Analysis: /HIPC/IS1")

test_that("report is generated", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  expect_equal(length(labkey_knitr), 1)

  report_header <- labkey_knitr[[1]]$findChildElements(using = "id",
                                                       value = "publication-info")
  expect_equal(length(report_header), 1)
  expect_equal(report_header[[1]]$getElementText()[[1]],
               "PUBLICATION INFO")
})

test_that("report is producing figures and tables", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")

  # check figures
  figures <- labkey_knitr[[1]]$findChildElements(using = "css selector",
                                                 value = "img")
  expect_length(figures, 9)

  if (length(figures) > 0) {
    fig1 <- figures[[1]]$getElementAttribute("src")
    expect_equal(fig1[[1]], paste0(siteURL, "/ImmuneSignatures/images/fig1.png"))
  }

  # check tables
  tables <- labkey_knitr[[1]]$findChildElements(using = "class",
                                                value = "dataTables_wrapper")
  expect_length(tables, 6)

  # check data for tables
  widget_data <- labkey_knitr[[1]]$findChildElements(using = "css selector",
                                                     value = "script[data-for]")
  expect_length(widget_data, 6)
})
