if (!exists("context_of")) source("initialize.R")


pageURL <- paste0(site_url, "/project/Studies/begin.view?pageId=DataAccess")
context_of(file = "test-modules-da.R",
           what = "Data Access Module",
           url = pageURL)

test_connection(remDr, pageURL, "DataAccess: /Studies")

sleep_for(5)

datasets <- c("Demographics",
              "",
              "Enzyme-linked immunosorbent assay (ELISA)",
              "Enzyme-Linked ImmunoSpot (ELISPOT)",
              "Flow cytometry analyzed results",
              "Hemagglutination inhibition (HAI)",
              "Human leukocyte antigen (HLA) typing",
              "Multiplex bead array asssay",
              "Neutralizing antibody titer",
              "Polymerisation chain reaction (PCR)")

test_that("choose dataset button is present and functioning", {
  # Find and open "choose dataset" button
  gridDropdowns <- remDr$findElements("css selector", ".data-access-dropdown")
  chooseDatasetButton <- gridDropdowns[[1]]
  expect_equal(chooseDatasetButton$getElementText()[[1]], "Demographics")
  chooseDatasetButton$clickElement()

  # Check contents of choose dataset dropdown
  children <- chooseDatasetButton$findChildElements("tag name", "li")
  childText <- unlist(lapply(children, function(x) x$getElementText()))
  expect_equal(childText, datasets)

  # Check that clicking HAI will change the title of the data grid
  hai <- children[[which(grepl("HAI", childText))]]
  hai$clickElement()
  sleep_for(3)
  expect_equal(chooseDatasetButton$getElementText()[[1]], "Hemagglutination Inhibition (HAI)")
})

test_that("grid is present", {
  # Select demographics
  gridDropdowns <- remDr$findElements("css selector", ".data-access-dropdown")
  chooseDatasetButton <- gridDropdowns[[1]]
  chooseDatasetButton$clickElement()
  children <- chooseDatasetButton$findChildElements("tag name", "li")
  children[[1]]$clickElement()
  sleep_for(3)
  expect_equal(chooseDatasetButton$getElementText()[[1]], "Demographics")

  # Check that grid headers are what we expect for demographics
  grid <- remDr$findElements("class", "labkey-data-region")
  expect_equal(length(grid), 1)
  headers <- grid[[1]]$findChildElements("tag", "th")
  headerText <- unlist(lapply(headers, function(x) x$getElementText()))
  expect_equal(headerText[1:6], c("", "Participant ID", "Cohort", "Phenotype", "Gender", "Age Reported"))

  # Check that there is data present
  rows <- grid[[1]]$findChildElements("tag", "tr")
  expect_gt(length(rows), 10)
})

test_that("data explorer button works", {
  # select HAI
  gridDropdowns <- remDr$findElements("css selector", ".data-access-dropdown")
  chooseDatasetButton <- gridDropdowns[[1]]
  chooseDatasetButton$clickElement()
  children <- chooseDatasetButton$findChildElements("tag name", "li")
  childText <- unlist(lapply(children, function(x) x$getElementText()))
  hai <- children[[which(grepl("HAI", childText))]]
  hai$clickElement()
  sleep_for(3)
  expect_equal(chooseDatasetButton$getElementText()[[1]], "Hemagglutination Inhibition (HAI)")
  # Find data explorer button and click it
  gridButtons <- remDr$findElements("css selector", ".labkey-button-bar>.labkey-button")
  buttonText <- unlist(lapply(gridButtons, function(x) x$getElementText()))
  expect_true("Data Explorer" %in% buttonText)
  dataExplorerButton <- gridButtons[[which(buttonText == "Data Explorer")]]
  dataExplorerButton$clickElement()
  expect_equal(remDr$getCurrentUrl()[[1]], paste0(site_url, "/DataExplorer/Studies/begin.view?dataset=hai&schema=study"))
})
