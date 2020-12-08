if (!exists("context_of")) source("initialize.R")


pageURL <- paste0(site_url, "/project/Studies/begin.view?pageId=DataAccess")
context_of(file = "test-modules-da.R",
           what = "Data Access Module",
           url = pageURL)

test_connection(remDr, pageURL, "DataAccess: /Studies")

test_that("choose dataset button is present and functioning", {
  # Find and open "choose dataset" button
  gridDropdowns <- remDr$findElements("css selector", ".labkey-button-bar>.lk-menu-drop")
  chooseDatasetButton <- gridDropdowns[[1]]
  expect_equal(chooseDatasetButton$getElementText()[[1]], "Choose Dataset")
  chooseDatasetButton$clickElement()
  children <- chooseDatasetButton$findChildElements("tag name", "li")
  childText <- unlist(lapply(children, function(x) x$getElementText()))
  expect_equal(sort(unique(childText)), sort(c("Demographics", "Assays", "Analyzed Results", "")))

  # Check contents of choose dataset dropdown
  assaysButton <- children[[2]]
  expect_equal(assaysButton$getElementText()[[1]], "Assays")
  assaysButton$clickElement()
  assays <- assaysButton$findChildElements("tag", "li")
  expect_equal(length(assays), 10)
  hai <- assays[[5]]
  expect_equal(hai$getElementText()[[1]], "Hemagglutination inhibition (HAI)")

  # Check that clicking HAI will change the title of the data grid
  hai$clickElement()
  sleep_for(3)
  daTitle <- remDr$findElement("class", "data-access-title")
  expect_equal(daTitle$getElementText()[[1]], "Hemagglutination inhibition (HAI)")
})

test_that("grid is present", {
  # Select demographics
  gridDropdowns <- remDr$findElements("css selector", ".labkey-button-bar>.lk-menu-drop")
  chooseDatasetButton <- gridDropdowns[[1]]
  chooseDatasetButton$clickElement()
  children <- chooseDatasetButton$findChildElements("tag name", "li")
  children[[1]]$clickElement()
  sleep_for(3)
  daTitle <- remDr$findElement("class", "data-access-title")
  expect_equal(daTitle$getElementText()[[1]], "Demographics")

  # Check that grid headers are what we expect for demographics
  grid <- remDr$findElements("class", "labkey-data-region")
  expect_equal(length(grid), 1)
  headers <- grid[[1]]$findChildElements("tag", "th")
  headerText <- unlist(lapply(headers, function(x) x$getElementText()))
  expect_equal(headerText[1:5], c("Participant ID", "Cohort", "Phenotype", "Gender", "Age Reported"))

  # Check that there is data present
  rows <- grid[[1]]$findChildElements("tag", "tr")
  expect_gt(length(rows), 10)
})
