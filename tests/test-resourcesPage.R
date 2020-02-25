if (!exists("remDr")) source("initialize.R")

page_url <- paste0(site_url, "/project/Studies/begin.view?pageId=Resources")
context_of("test-resourcesPage.R", "Resources Page", page_url)

test_connection(remDr, page_url, "Resources: /Studies")

sleep_for(5)

test_that("all webpart is present", {
  test_presence_of_single_item('app')
})

test_that("About tab has correct elements", {

  aboutDiv <- remDr$findElement('id', 'About')
  expect_length(aboutDiv, 1)

  aboutParagraphs <- aboutDiv$findChildElements('tag name', 'p')
  expect_length(aboutParagraphs, 3)

  test_presence_of_single_img(AboutDiv)
})

test_that("Data Standards tab has correct elements", {

  tab <- remDr$findElement('id', 'DataStandardsDropdown')
  tab$clickElement()

  navbarLi <- remDr$findElement('id', 'navbar-link-data-standards')
  assayOptions <- navbarLi$findChildElements('tag name', 'li')
  expect_length(assayOptions, 3)

  assayTexts <- sapply(assayOptions, function(li){
    ahref <- li$findChildElement('tag name', 'a')
    innerText <- ahref$getElementText()[[1]]
  })
  expectedAssayTexts <- c("Cytometry",
                          "Gene Expression",
                          "Immune Response")
  expect_true(all.equal(assayTexts, expectedAssayTexts))

  assayOptions[[2]]$clickElement()

  div <- remDr$findElement('id', 'DataStandards')
  test_presence_of_single_img(div)
})

test_that("HIPC Tools tab has correct elements", {
  navigate_to_link("tools")

  div <- remDr$findElement('id', 'Tools')
  expect_length(div, 1)

  sections <- div$findChildElements('tag name', 'p')
  expect_length(sections, 4)
})

test_that("Highlighted Reports tab has correct elements", {
  navigate_to_link("reports")

  div <- remDr$findElement('id', 'Reports')
  expect_length(div, 1)

  # number of reports is greater than 0
  tableRows <- div$findChildElements('tag name', 'tr')
  expect_length(tableRows, 6)

  # pictures and text are present
  actualHeaders <- unlist(sapply(tableRows, function(tr){
    imgTd <- tr$findChildElement('class', 'hr-imgCol')
    test_presence_of_single_img(imgTd)

    infoTd <- tr$findChildElement('class', 'hr-infoCol')
    ahref <- infoTd$findChildElement('tag name', 'a')
    expect_length(ahref, 1)

    header <- infoTd$findChildElement('tag name', 'h2')
    headerText <- header$getElementText()
  }))

  expectedHeaders <- c("SDY144",
                       "SDY180",
                       "SDY207",
                       "SDY269",
                       "ImmuneSignatures 1",
                       "Lyoplate")

  expect_true(all.equal(actualHeaders, expectedHeaders))

})

test_that("Study Statistics tab has correct elements", {
  # Most accessed studies
    # by study
      # button to order is present
      # button changes order

    # by time
      # button to order is not present


  # Most cited studies
    # Plot is present
    # button changes order

  # Similar studies
    # All plots are present and button cycles through them
})

test_presence_of_single_img <- function(el){
  img <- el$findChildElement('tag name', 'img')
  expect_length(img, 1)

  if(length(img) > 0){
    imgSrc <- img$getElementAttribute('src')[[1]]
    res <- httr::GET(imgSrc)
    expect_true(res$status_code == 200)
  }
}

navigate_to_link <- function(linkName){
  navbarLi <- remDr$findElement('id', paste0('navbar-link-', linkName))
  ahref <- navbarLi$findChildElement('tag name', 'a')
  ahref$clickElement()
}


# test_that("'Data Finder' module is present", {
#   test_presence_of_single_item("app")
# })
#
# test_that("participant group buttons are available", {
#   linkIds <- c("manage-participant-group-link",
#                "send-participant-group-link",
#                "export-datasets-link",
#                "open-rstudio-link")
#   lapply(linkIds, test_presence_of_single_item)
#
#   buttonIds <- paste0(c("Load", "Clear", "Save"), "-participant-group-btn")
#   lapply(buttonIds, test_presence_of_single_item)
# })
#
# test_that("Current participant group info is present", {
#   test_presence_of_single_item("current-participant-group-info-banner")
# })
#
# test_that("Filter banner is present", {
#   test_presence_of_single_item("filters-banner")
# })
#
# test_that("Filter selector buttons are present", {
#   studyDesign <- c("Condition",
#                    "ResearchFocus",
#                    "ExposureMaterial",
#                    "ExposureProcess",
#                    "Species")
#   participantCharacteristics <- c("Gender",
#                                   "Age",
#                                   "Race")
#   availableData <- c("Timepoint",
#                      "SampleType",
#                      "Assay")
#   dropdownButtonGroups <- list(studyDesign,
#                                participantCharacteristics,
#                                availableData)
#   lapply(dropdownButtonGroups, function(subgroupIds){
#     subgroupIds <- paste0(subgroupIds, "-filter-dropdown")
#     lapply(subgroupIds, test_presence_of_single_item)
#   })
#
#   assayTimepointBtnId <- "content-dropdown-button-heatmap-selector"
#   test_presence_of_single_item(assayTimepointBtnId)
#
#   applyFiltersBtnId <- "action-button-Apply"
#   test_presence_of_single_item(applyFiltersBtnId)
# })
#
# test_that("Plot tabs are present", {
#   tabs <- c("study",
#             "participant",
#             "data")
#   tabs <- paste0("tab-find-", tabs)
#   dmp <- lapply(tabs, test_presence_of_single_item)
# })
#
# test_that("plots are present for each tab", {
#
#   test_barplot <- function(id){
#     svgId <- paste0('svg-barplot-', id)
#     el <- remDr$findElement('id', svgId)
#     expect_length(el, 1)
#
#     if ( length(el) > 0 ) {
#       rectsContainer <- paste0('barplot', id)
#       el <- remDr$findElements('id', rectsContainer)
#       expect_length(el, 1)
#
#       rects <- el[[1]]$findChildElements('class', 'rect')
#       expect_gt(length(rects), 0)
#
#       yAxisLabels <- paste0('yaxis-labels-short-', id)
#       el <- remDr$findElement('id', yAxisLabels)
#       expect_length(el, 1)
#
#       xAxis <- paste0('xaxis-', id)
#       el <- remDr$findElement('id', xAxis)
#       expect_length(el, 1)
#
#       # TODO: use xPath to match X axis text
#     }
#   }
#
#   # Study Design - study cards
#   studyDesignPlots <- c("Condition",
#                         "ExposureProcess",
#                         "ResearchFocus",
#                         "ExposureMaterial")
#
#   dmp <- lapply(studyDesignPlots, test_barplot)
#
#   # Participant Characteristics - view of pids table
#   participantCharsPlots <- c("Age",
#                              "Gender",
#                              "Race")
#
#   dmp <- lapply(participantCharsPlots, test_barplot)
#
#   # Available Assay Data - assay data view
#   test_barplot("SampleType")
#
#   heatmapSvg <- remDr$findElement('id', 'heatmap-heatmap1')
#   expect_length(heatmapSvg, 1)
#
#   if ( length(heatmapSvg) > 0 ) {
#     rectsContainer <- heatmapSvg$findChildElement('id', 'heatmap')
#     rects <- rectsContainer$findChildElements('tag name', 'rect')
#     expect_gt(length(rects), 0)
#
#     yAxisLabels <- heatmapSvg$findElement('id', 'yaxis-labels')
#     expect_length(yAxisLabels, 1)
#
#     xAxisLabels <- heatmapSvg$findElement('id', 'xaxis-labels')
#     expect_length(xAxisLabels, 1)
#   }
#
# })
#
#
# test_that("Outputs change when filters are applied", {
#
#   getPlotValues <- function(plotName){
#     barplot <- remDr$findElement('id', paste0('barplot', plotName))
#     bars <- barplot$findChildElements('class', 'rect')
#     values <- sapply(bars, function(bar){
#       return(as.numeric(unlist(bar$getElementAttribute('width'))))
#     })
#   }
#
#   getBannerValues <- function(){
#     bannerDiv <- remDr$findElement('id','filters-banner')
#     ems <- bannerDiv$findChildElements('class', 'filter-indicator')
#     innerTexts <- sapply(ems, function(em){
#       return(unlist(em$getElementText()))
#     })
#   }
#
#   preSelectConditionPlotValues <- getPlotValues('Condition')
#   expect_true(all(preSelectConditionPlotValues > 0))
#
#   preSelectRacePlotValues <- getPlotValues('Race')
#   expect_true(all(preSelectRacePlotValues > 0))
#
#   # Get original values for Banner - empty
#   preSelectBannerValues <- getBannerValues()
#   expect_true(all(preSelectBannerValues == "No filters currently applied"))
#
#   # select filters
#   conditionFilter <- remDr$findElement('id', 'Condition-filter-dropdown')
#   conditionFilter$clickElement()
#   influenzaCheckBox <- conditionFilter$findChildElement('xpath',
#                                                         '//*/input[@value="Influenza"]')
#   influenzaCheckBox$clickElement()
#
#   genderFilter <- remDr$findElement('id', 'Gender-filter-dropdown')
#   genderFilter$clickElement()
#   femaleCheckBox <- genderFilter$findChildElement('xpath',
#                                                   '//*/input[@value="Female"]')
#   femaleCheckBox$clickElement()
#
#   # apply filters
#   applyBtn <- remDr$findElement('id', 'action-button-Apply')
#   applyBtn$clickElement()
#
#   sleep_for(4)
#
#   # filter banner changes
#   postSelectBannerValues <- getBannerValues()
#   expectedBannerValues <- c("Condition: Influenza",
#                             "Gender: Female",
#                             "No filters currently applied")
#   expect_true(all.equal(postSelectBannerValues, expectedBannerValues))
#
#   postSelectConditionPlotValues <- getPlotValues('Condition')
#   conditionsWithPositiveValues <- sum(postSelectConditionPlotValues > 0)
#   expect_true(conditionsWithPositiveValues == 1)
#
#   postSelectRacePlotValues <- getPlotValues('Race')
#   expect_true(all(preSelectRacePlotValues != postSelectRacePlotValues))
#
#   # Click clear
#   clearAllBtn <- remDr$findElement('id', 'Clear-participant-group-btn')
#   clearAllBtn$clickElement()
#   clearAllLink <- remDr$findElement('id', 'Clear-All-link')
#   clearAllLink$clickElement()
#
#   sleep_for(3)
#
#   # check original condition bar plot vals are back
#   postClearConditionPlotValues <- getPlotValues('Condition')
#   expect_true(all.equal(postClearConditionPlotValues, preSelectConditionPlotValues))
#
#   postClearRacePlotValues <- getPlotValues('Race')
#   expect_true(all.equal(postClearRacePlotValues, preSelectRacePlotValues))
#
#   # Get original values for Banner - empty
#   postClearBannerValues <- getBannerValues()
#   expect_true(all.equal(postClearBannerValues, preSelectBannerValues))
# })

