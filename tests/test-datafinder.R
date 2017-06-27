if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/project/Studies/begin.view?")
context_of(file = "test-datafinder.R", 
           what = "Data Finder", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Overview: /Studies")

Sys.sleep(3)

test_that("'Data Finder' module is present", {
  module <- remDr$findElements(using = "id", value = "dataFinderApp")
  expect_equal(length(module), 1)
})

test_that("subject group controller is present", {
  filterArea <- remDr$findElements(using = "id", value = "filterArea")
  expect_equal(length(filterArea), 1)
  
  groupLabel <- filterArea[[1]]$findChildElements(using = "class", value = "labkey-group-label")
  expect_equal(length(groupLabel), 1)
  
  loadMenu <- filterArea[[1]]$findChildElements(using = "id", value = "loadMenu")
  expect_equal(length(loadMenu), 1)
  
  saveMenu <- filterArea[[1]]$findChildElements(using = "id", value = "saveMenu")
  expect_equal(length(saveMenu), 1)
  
  sendMenu <- filterArea[[1]]$findChildElements(using = "id", value = "sendMenu")
  expect_equal(length(sendMenu), 1)
})

test_that("search box is present", {
  searchBox <- remDr$findElements(using = "class", value = "studyfinder-header")
  expect_equal(length(searchBox), 1)
  
  searchTems <- searchBox[[1]]$findChildElements(using = "id", value = "searchTerms")
  expect_equal(length(searchTems), 1)
  
  studySubsetSelect <- searchBox[[1]]$findChildElements(using = "name", value = "studySubsetSelect")
  expect_equal(length(studySubsetSelect), 1)
  
  subsetOptions <- studySubsetSelect[[1]]$findChildElements(using = "class", value = "ng-scope")
  expect_gte(length(subsetOptions), 3)
})

test_that("selection panel is present", {
  selectionPanel <- remDr$findElements(using = "id", value = "selectionPanel")
  expect_equal(length(selectionPanel), 1)
  
  summaryArea <- selectionPanel[[1]]$findChildElements(using = "id", value = "summaryArea")
  expect_equal(length(summaryArea), 1)
  
  facetPanel <- selectionPanel[[1]]$findChildElements(using = "id", value = "facetPanel")
  expect_equal(length(facetPanel), 1)
  
  facets <- facetPanel[[1]]$findChildElements(using = "class", value = "facet")
  expect_equal(length(facets), 10)
  expect_match(facets[[1]]$getElementText()[[1]], "Species")
  expect_match(facets[[2]]$getElementText()[[1]], "Condition")
  expect_match(facets[[3]]$getElementText()[[1]], "Type")
  expect_match(facets[[4]]$getElementText()[[1]], "Research focus")
  expect_match(facets[[5]]$getElementText()[[1]], "Assay")
  expect_match(facets[[6]]$getElementText()[[1]], "Day of Study")
  expect_match(facets[[7]]$getElementText()[[1]], "Gender")
  expect_match(facets[[8]]$getElementText()[[1]], "Race")
  expect_match(facets[[9]]$getElementText()[[1]], "Age")
  expect_match(facets[[10]]$getElementText()[[1]], "Study")
})

test_that("study panel is present", {
  studyPanel <- remDr$findElements(using = "id", value = "studypanel")
  expect_equal(length(studyPanel), 1)
  
  studyCards<- studyPanel[[1]]$findChildElements(using = "class", value = "labkey-study-card")
  expect_gt(length(studyCards), 0)
  
  if (length(studyCards) > 0) {
    cardSummary <- studyCards[[1]]$findChildElements(using = "class", value = "labkey-study-card-summary")
    cardSummary[[1]]$clickElement()
    Sys.sleep(1)
    
    studyDetail <- remDr$findElements(using = "class", value = "labkey-study-detail")
    expect_equal(length(studyDetail), 1)
    
    studyDemographics <- studyDetail[[1]]$findChildElements(using = "class", value = "study-demographics")
    expect_equal(length(studyDemographics), 1)
  }
})