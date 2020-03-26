if (!exists("remDr")) source("initialize.R")

page_url <- paste0(site_url, "/project/Studies/begin.view?")
context_of("test-datafinder.R", "Data Finder", page_url)

test_connection(remDr, page_url, "Find: /Studies")

# reload page to get laoder wheel
remDr$navigate(page_url)
test_presence_of_single_item("loader-1")
sleep_for(5)

# TODO: rewrite once quick-help is added back
# test_that("'Quick Help' is present", {
#   remDr$executeScript("start_tutorial();")
#   sleep_for(3)
#
#   quick_help <- remDr$findElements("class", "hopscotch-bubble")
#   expect_gte(length(quick_help), 1)
#
#   if (length(quick_help) >= 1) {
#     titles <- c(
#       "Data Finder",
#       "Study Panel",
#       "Summary",
#       "Filters",
#       "Quick Search"
#     )
#     for (i in seq_along(titles)) {
#       sleep_for(1)
#       help_title <- quick_help[[1]]$findChildElements(
#         "class", "hopscotch-title"
#       )
#       expect_equal(help_title[[1]]$getElementText()[[1]], titles[i])
#
#       next_button <- quick_help[[1]]$findChildElements(
#         "class", "hopscotch-next"
#       )
#       expect_equal(length(next_button), 1)
#
#       close_button <- quick_help[[1]]$findChildElements(
#         "class", "hopscotch-close"
#       )
#       expect_equal(length(close_button), 1)
#
#       if (i == length(titles)) {
#         close_button[[1]]$clickElement()
#       } else {
#         next_button[[1]]$clickElement()
#       }
#     }
#   }
# })

test_studies_tab()

test_that("'Data Finder' module is present", {
  test_presence_of_single_item("app")
})

test_that("participant group buttons are available", {
  linkIds <- c("manage-participant-group-link",
               "send-participant-group-link",
               "export-datasets-link",
               "open-rstudio-link")
  lapply(linkIds, test_presence_of_single_item)

  buttonIds <- paste0(c("Load", "Clear", "Save"), "-participant-group-btn")
  lapply(buttonIds, test_presence_of_single_item)
})

test_that("Current participant group info is present", {
  test_presence_of_single_item("current-participant-group-info-banner")
})

test_that("Filter banner is present", {
  test_presence_of_single_item("df-active-filter-bar")

  # Test for hidden banner
  hiddenBanner <- remDr$findElements("class name", "df-banner-wrapper")
  expect_equal(length(hiddenBanner), 1)

  # Make sure it's hidden
  expect_true(all(unlist(hiddenBanner[[1]]$getElementSize() == 0)))

})

test_that("Filter selector buttons are present", {
  studyDesign <- c("Condition",
                   "ResearchFocus",
                   "ExposureMaterial",
                   "ExposureProcess",
                   "Species")
  participantCharacteristics <- c("Gender",
                                  "Age",
                                  "Race")
  availableData <- c("Timepoint",
                     "SampleType",
                     "Assay")
  dropdownButtonGroups <- list(studyDesign,
                               participantCharacteristics,
                               availableData)
  lapply(dropdownButtonGroups, function(subgroupIds){
    subgroupIds <- paste0("df-content-dropdown-", subgroupIds)
    lapply(subgroupIds, test_presence_of_single_item)
  })

  assayTimepointBtnId <- "content-dropdown-button-heatmap-selector"
  test_presence_of_single_item(assayTimepointBtnId)

  applyFiltersBtnId <- "action-button-Apply"
  test_presence_of_single_item(applyFiltersBtnId)
})

test_that("Plot tabs are present", {
  tabs <- c("study",
            "participant",
            "data")
  tabs <- paste0("tab-find-", tabs)
  dmp <- lapply(tabs, test_presence_of_single_item)
})

test_that("plots are present for each tab", {

  test_barplot <- function(id){
    svgId <- paste0('svg-barplot-', id)
    el <- remDr$findElement('id', svgId)
    expect_length(el, 1)

    if ( length(el) > 0 ) {
      rectsContainer <- paste0('barplot', id)
      el <- remDr$findElements('id', rectsContainer)
      expect_length(el, 1)

      rects <- el[[1]]$findChildElements('class', 'rect')
      expect_gt(length(rects), 0)

      yAxisLabels <- paste0('yaxis-labels-short-', id)
      el <- remDr$findElement('id', yAxisLabels)
      expect_length(el, 1)

      xAxis <- paste0('xaxis-', id)
      el <- remDr$findElement('id', xAxis)
      expect_length(el, 1)

      # TODO: use xPath to match X axis text
    }
  }

  # Study Design - study cards
  studyDesignPlots <- c("Condition",
                        "ExposureProcess",
                        "ResearchFocus",
                        "ExposureMaterial")

  dmp <- lapply(studyDesignPlots, test_barplot)

  # Participant Characteristics - view of pids table
  participantCharsPlots <- c("Age",
                             "Gender",
                             "Race")

  dmp <- lapply(participantCharsPlots, test_barplot)

  # Available Assay Data - assay data view
  test_barplot("SampleType")

  heatmapSvg <- remDr$findElement('id', 'heatmap-heatmap1')
  expect_length(heatmapSvg, 1)

  if ( length(heatmapSvg) > 0 ) {
    rectsContainer <- heatmapSvg$findChildElement('id', 'heatmap')
    rects <- rectsContainer$findChildElements('tag name', 'rect')
    expect_gt(length(rects), 0)

    yAxisLabels <- heatmapSvg$findElement('id', 'yaxis-labels')
    expect_length(yAxisLabels, 1)

    xAxisLabels <- heatmapSvg$findElement('id', 'xaxis-labels')
    expect_length(xAxisLabels, 1)
  }

})


test_that("Outputs change when filters are applied", {

  getPlotValues <- function(plotName){
    barplot <- remDr$findElement('id', paste0('barplot', plotName))
    bars <- barplot$findChildElements('class', 'rect')
    values <- sapply(bars, function(bar){
      return(as.numeric(unlist(bar$getElementAttribute('width'))))
    })
  }

  getBannerValues <- function(){
    bannerDiv <- remDr$findElement('id','df-active-filter-bar')
    ems <- bannerDiv$findChildElements('class', 'filter-indicator')
    innerTexts <- sapply(ems, function(em){
      return(unlist(em$getElementText()))
    })
  }

  preSelectConditionPlotValues <- getPlotValues('Condition')
  expect_true(all(preSelectConditionPlotValues > 0))

  preSelectRacePlotValues <- getPlotValues('Race')
  expect_true(all(preSelectRacePlotValues > 0))

  # Get original values for Banner - empty
  preSelectBannerValues <- getBannerValues()
  expect_true(all(preSelectBannerValues == "No filters currently applied"))

  # select filters
  conditionFilter <- remDr$findElement('id', "df-content-dropdown-Condition")
  conditionFilter$clickElement()
  influenzaCheckBox <- conditionFilter$findChildElement('xpath',
                                                        '//*/input[@value="Influenza"]')
  influenzaCheckBox$clickElement()

  genderFilter <- remDr$findElement('id', 'df-content-dropdown-Gender')
  genderFilter$clickElement()
  femaleCheckBox <- genderFilter$findChildElement('xpath',
                                                  '//*/input[@value="Female"]')
  femaleCheckBox$clickElement()

  # apply filters
  applyBtn <- remDr$findElement('id', 'action-button-Apply')
  applyBtn$clickElement()

  sleep_for(4)

  # filter banner changes
  postSelectBannerValues <- getBannerValues()
  expectedBannerValues <- c("Condition: Influenza",
                            "Gender: Female",
                            "No filters currently applied")
  expect_true(all.equal(postSelectBannerValues, expectedBannerValues))

  postSelectConditionPlotValues <- getPlotValues('Condition')
  conditionsWithPositiveValues <- sum(postSelectConditionPlotValues > 0)
  expect_true(conditionsWithPositiveValues == 1)

  postSelectRacePlotValues <- getPlotValues('Race')
  expect_true(all(preSelectRacePlotValues != postSelectRacePlotValues))

  # Click clear
  clearAllBtn <- remDr$findElement('id', 'Clear-participant-group-btn')
  clearAllBtn$clickElement()
  clearAllLink <- remDr$findElement('id', 'Clear-All-link')
  clearAllLink$clickElement()

  sleep_for(3)

  # check original condition bar plot vals are back
  postClearConditionPlotValues <- getPlotValues('Condition')
  expect_true(all.equal(postClearConditionPlotValues, preSelectConditionPlotValues))

  postClearRacePlotValues <- getPlotValues('Race')
  expect_true(all.equal(postClearRacePlotValues, preSelectRacePlotValues))

  # Get original values for Banner - empty
  postClearBannerValues <- getBannerValues()
  expect_true(all.equal(postClearBannerValues, preSelectBannerValues))
})

