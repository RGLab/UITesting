if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/project/Studies/begin.view?")
context_of(file = "test-datafinder.R",
           what = "Data Finder",
           url = pageURL)

test_connection(remDr = remDr,
                pageURL = pageURL,
                expectedTitle = "Overview: /Studies")

sleep_for(3)

test_that("'Quick Help' is present", {
  remDr$executeScript(script = "start_tutorial();",
                      args = list("dummy"))
  sleep_for(3)

  quickHelp <- remDr$findElements(using = "class",
                                  value = "hopscotch-bubble")
  expect_gte(length(quickHelp), 1)

  if (length(quickHelp) >= 1) {
    titles <- c("Data Finder",
                "Study Panel",
                "Summary",
                "Filters",
                "Quick Search")
    for (i in seq_along(titles)) {
      helpTitle <- quickHelp[[1]]$findChildElements(using = "class",
                                                    value = "hopscotch-title")
      expect_equal(helpTitle[[1]]$getElementText()[[1]], titles[i])

      nextButton <- quickHelp[[1]]$findChildElements(using = "class",
                                                     value = "hopscotch-next")
      expect_equal(length(nextButton), 1)

      closeButton <- quickHelp[[1]]$findChildElements(using = "class",
                                                      value = "hopscotch-close")
      expect_equal(length(closeButton), 1)

      if (i == length(titles)) {
        closeButton[[1]]$clickElement()
      } else {
        nextButton[[1]]$clickElement()
        sleep_for(1)
      }
    }
  }
})

test_studiesTab()

test_that("'Data Finder' module is present", {
  module <- remDr$findElements(using = "id", value = "dataFinderApp")
  expect_equal(length(module), 1)
})

test_that("subject group controller is present", {
  filterArea <- remDr$findElements(using = "id", value = "filterArea")
  expect_length(filterArea, 1)

  groupLabel <- filterArea[[1]]$findChildElements(using = "class", value = "labkey-group-label")
  expect_length(groupLabel, 1)

  manageMenu <- filterArea[[1]]$findChildElements(using = "id", value = "df-manageMenu")
  expect_length(manageMenu, 1)
  if (length(manageMenu) == 1) {
    sleep_for(10, condition = expression(manageMenu[[1]]$isElementDisplayed()[[1]]))

    manageMenu[[1]]$clickElement()
    sleep_for(1)
    manageItems <- manageMenu[[1]]$findChildElements(using = "class", value = "df-menu-item-link")
    expect_length(manageItems, 1)
  }

  loadMenu <- filterArea[[1]]$findChildElements(using = "id", value = "loadMenu")
  expect_length(loadMenu, 1)
  if (length(loadMenu) == 1) {
    loadMenu[[1]]$clickElement()
    sleep_for(1)
    loadItems <- loadMenu[[1]]$findChildElements(using = "class", value = "df-menu-item-link")
    expect_gt(length(loadItems), 0)
  }

  saveMenu <- filterArea[[1]]$findChildElements(using = "id", value = "saveMenu")
  expect_length(saveMenu, 1)
  if (length(saveMenu) == 1) {
    saveMenu[[1]]$clickElement()
    sleep_for(1)
    saveItems <- saveMenu[[1]]$findChildElements(using = "class", value = "df-menu-item-link")
    expect_length(saveItems, 2)
  }

  sendMenu <- filterArea[[1]]$findChildElements(using = "id", value = "sendMenu")
  expect_length(sendMenu, 1)
})

test_that("search box is present", {
  searchBox <- remDr$findElements(using = "class", value = "studyfinder-header")
  expect_length(searchBox, 1)

  searchTems <- searchBox[[1]]$findChildElements(using = "id", value = "searchTerms")
  expect_length(searchTems, 1)

  studySubsetSelect <- searchBox[[1]]$findChildElements(using = "name", value = "studySubsetSelect")
  expect_length(studySubsetSelect, 1)

  subsetOptions <- studySubsetSelect[[1]]$findChildElements(using = "class", value = "ng-scope")
  expect_gte(length(subsetOptions), 3)
})

test_that("selection panel is present", {
  selectionPanel <- remDr$findElements(using = "id", value = "selectionPanel")
  expect_length(selectionPanel, 1)

  summaryArea <- selectionPanel[[1]]$findChildElements(using = "id", value = "summaryArea")
  expect_length(summaryArea, 1)

  facetPanel <- selectionPanel[[1]]$findChildElements(using = "id", value = "facetPanel")
  expect_length(facetPanel, 1)

  facets <- facetPanel[[1]]$findChildElements(using = "class", value = "df-facet")
  expect_length(facets, 10)
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
  expect_length(studyPanel, 1)

  studyCards<- studyPanel[[1]]$findChildElements(using = "class", value = "labkey-study-card")
  expect_gt(length(studyCards), 0)

  if (length(studyCards) > 0) {
    cardSummary <- studyCards[[1]]$findChildElements(using = "class", value = "labkey-study-card-summary")
    cardSummary[[1]]$clickElement()
    sleep_for(1)

    studyDetail <- remDr$findElements(using = "class", value = "labkey-study-detail")
    expect_length(studyDetail, 1)

    studyDemographics <- studyDetail[[1]]$findChildElements(using = "class", value = "study-demographics")
    expect_length(studyDemographics, 1)
  }
})
