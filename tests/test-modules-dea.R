if (!exists("context_of")) source("initialize.R")


page_url <- paste0(site_url, "/DifferentialExpressionAnalysis/Studies/", "SDY269", "/begin.view")
context_of(
  file = "test-modules-dea.R",
  what = paste0("Differential Expression (", "SDY269", ")"),
  url = page_url
)

test_connection(remDr, page_url, "Differential Expression: /Studies/SDY269")

# Check for title
test_that("Differential Expression title is displayed correctly", {
  dea_title <- remDr$findElements("css selector", ".panel h3")
  dea_webpart_title_text <- dea_title[[1]]$getElementText()[[1]]
  expect_equal(dea_webpart_title_text, "Differential Expression")
  dea_title_text <- dea_title[[2]]$getElementText()[[1]]
  expect_equal(dea_title_text, "Differential Expression Analysis Results")
})


# Check for table
test_that("Results table is present", {
  dea_table <- remDr$findElements("css selector", "#de-results table.labkey-data-region")
  expect_equal(length(dea_table), 1)
})


