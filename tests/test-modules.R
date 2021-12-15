if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(site_url, "/project/Studies/SDY269/begin.view?pageId=Modules")
context_of(
  file = "test-modules.R",
  what = "Modules",
  url = pageURL
)

test_connection(remDr, pageURL, "Modules: /Studies/SDY269")

test_that("'Active Modules' module is present", {
  panel <- remDr$findElements(using = "class", value = "x-panel")
  expect_equal(length(panel), 1)

  gee_link <- remDr$findElements(using = "css selector", value = "a[href$='/GeneExpressionExplorer/Studies/SDY269/begin.view']")
  expect_equal(length(gee_link), 1)

  gsea_link <- remDr$findElements(using = "css selector", value = "a[href$='/GeneSetEnrichmentAnalysis/Studies/SDY269/begin.view']")
  expect_equal(length(gsea_link), 1)

  irp_link <- remDr$findElements(using = "css selector", value = "a[href$='/ImmuneResponsePredictor/Studies/SDY269/begin.view']")
  expect_equal(length(irp_link), 1)
})

test_that("Available studies respect Data Finder filters", {

  # navigate to data finder
  df_url <- paste0(site_url, "/project/Studies/begin.view?")
  remDr$navigate(df_url)
  sleep_for(15)

  # click "Filter button"
  filterDropdownButton <- remDr$findElement("css selector", "#data-finder-filters > * .df-outer-dropdown > * .btn-default")
  expect_equal(filterDropdownButton$getElementText()[[1]], "Filters")
  filterDropdownButton$clickElement()

  # select "Influenza" from "Condition" filter
  conditionDropdownButton <- remDr$findElement("css selector", "#df-filter-dropdown-Condition > * .btn-default")
  expect_equal(conditionDropdownButton$getElementText()[[1]], "Condition")
  conditionDropdownButton$clickElement()

  conditionOptions <- remDr$findElements("css selector", ".filter-dropdown-set > * div#Condition input[name='Condition']")
  conditionOptions[[9]]$clickElement() #influenza
  conditionDropdownButton$clickElement()

  # select "Female" from "Gender" filter
  genderDropdownButton <- remDr$findElement("css selector", "#df-filter-dropdown-Gender > * .btn-default")
  expect_equal(genderDropdownButton$getElementText()[[1]], "Gender")
  genderDropdownButton$clickElement()

  genderOptions <- remDr$findElements("css selector", ".filter-dropdown-set > * div#Gender input[name='Gender']")
  genderOptions[[1]]$clickElement() #female
  genderDropdownButton$clickElement()

  sleep_for(5)

  # make sure the correct filters are selected and displayed
  filterOptionDisplays <- remDr$findElements("css selector", "#data-finder div#df-filter-summary .col-sm-4 .filter-indicator")
  expect_length(filterOptionDisplays, 3)

  expect_equal(filterOptionDisplays[[1]]$getElementText()[[1]], "Condition: Influenza")
  expect_equal(filterOptionDisplays[[2]]$getElementText()[[1]], "Gender: Female")

  # navigate to active modules
  active_modules_url <- paste0(site_url, "/project/Studies/begin.view?pageId=analyze")
  remDr$navigate(active_modules_url)
  sleep_for(15)

  # check that the appropriate number of studies are displayed
  dr_studies <- remDr$findElement("css selector", "div.studies-DimensionReduction")
  expect_equal(dr_studies$getElementText()[[1]], "32 available studies:\nSDY34, SDY56, SDY61, SDY63, SDY67, SDY112, SDY113, SDY241, SDY269, SDY270, SDY305, SDY312, SDY314, SDY315, SDY395, SDY400, SDY404, SDY406, SDY472, SDY478, SDY514, SDY515, SDY519, SDY520, SDY522, SDY640, SDY887, SDY1086, SDY1119, SDY1276, SDY1466, SDY1468")
  dr_study_links <- remDr$findElements("css selector", "div.studies-DimensionReduction > a")
  expect_length(dr_study_links[], 32)

  gee_studies <- remDr$findElement("css selector", "div.studies-GeneExpressionExplorer")
  expect_equal(gee_studies$getElementText()[[1]], "19 available studies:\nSDY56, SDY61, SDY63, SDY67, SDY112, SDY113, SDY269, SDY270, SDY305, SDY312, SDY315, SDY400, SDY404, SDY406, SDY520, SDY522, SDY640, SDY1119, SDY1276")
  gee_study_links <- remDr$findElements("css selector", "div.studies-GeneExpressionExplorer > a")
  expect_length(gee_study_links[], 19)

  gsea_studies <- remDr$findElement("css selector", "div.studies-GeneSetEnrichmentAnalysis")
  expect_equal(gsea_studies$getElementText()[[1]], "14 available studies:\nSDY56, SDY61, SDY63, SDY67, SDY269, SDY270, SDY400, SDY404, SDY520, SDY522, SDY640, SDY1086, SDY1119, SDY1276")
  gsea_study_links <- remDr$findElements("css selector", "div.studies-GeneSetEnrichmentAnalysis > a")
  expect_length(gsea_study_links[], 14)

  irp_studies <- remDr$findElement("css selector", "div.studies-ImmuneResponsePredictor")
  expect_equal(irp_studies$getElementText()[[1]], "10 available studies:\nSDY56, SDY63, SDY269, SDY400, SDY404, SDY520, SDY640, SDY1086, SDY1119, SDY1276")
  irp_study_links <- remDr$findElements("css selector", "div.studies-ImmuneResponsePredictor > a")
  expect_length(irp_study_links[], 10)

  remDr$navigate(pageURL)
})