if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(site_url, "/project/Studies/SDY269/begin.view?pageId=Modules")
context_of(file = "test-modules.R",
           what = "Modules",
           url = pageURL)

test_connection(remDr, pageURL, "Modules: /Studies/SDY269")

test_that("'Active Modules' module is present", {
  panel <- remDr$findElements(using = "class", value = "x-panel")
  expect_equal(length(panel), 1)

  de_link <- remDr$findElements(using = "css selector", value = "a[href$='/DataExplorer/Studies/SDY269/begin.view']")
  expect_equal(length(de_link), 1)

  gee_link <- remDr$findElements(using = "css selector", value = "a[href$='/GeneExpressionExplorer/Studies/SDY269/begin.view']")
  expect_equal(length(gee_link), 1)

  gsea_link <- remDr$findElements(using = "css selector", value = "a[href$='/GeneSetEnrichmentAnalysis/Studies/SDY269/begin.view']")
  expect_equal(length(gsea_link), 1)

  irp_link <- remDr$findElements(using = "css selector", value = "a[href$='/ImmuneResponsePredictor/Studies/SDY269/begin.view']")
  expect_equal(length(irp_link), 1)
})
