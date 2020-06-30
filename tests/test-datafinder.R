if (!exists("remDr")) source("initialize.R")

page_url <- paste0(site_url, "/project/Studies/begin.view?")
context_of("test-datafinder.R", "Data Finder", page_url)

test_connection(remDr, page_url, "Studies: /Studies")

# reload page to get loader wheel
remDr$navigate(page_url)
test_presence_of_single_item("loader-1")
sleep_for(20)

test_main_menu_tab()

# check for tabs -- there should be none.
test_that("Correct tabs are present", {
  nav_tab <- remDr$findElement("id", "nav_tabs")
  tabs_ul <- nav_tab$findChildElement("css selector", "ul[id=lk-nav-tabs-separate]")
  tabs <- tabs_ul$findChildElements("css selector", "a")
  expect_length(tabs, 0)
})

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

test_that("'Data Finder' module is present", {
  test_presence_of_single_item("data-finder")
})

# --------------------- BANNER ---------------------------
test_that("Correct banner is present", {
  # Test for hidden banner
  hiddenBanner <- remDr$findElement("id", "filter-banner")
  expect_length(hiddenBanner, 1)

  # Make sure it's hidden
  expect_true(hiddenBanner$getElementSize()$width == 0)

  # Test for data finder banner
  activeBanner <- remDr$findElement("id", "data-finder-app-banner")
  expect_length(activeBanner, 1)

  # Make sure it's visible
  expect_true(activeBanner$getElementSize()$width > 0)

})

test_that("banner dropdown menus work", {
  bannerDropdowns <- remDr$findElements("css selector", "#data-finder-app-banner .df-outer-dropdown")
  buttonText <- c("Select Participants", "Manage")

  expect_equal(length(bannerDropdowns), 2)
  expect_equal(
    unlist(lapply(bannerDropdowns, function(x){return(x$getElementText())})),
    buttonText
  )

  exploreDataDropdown <- bannerDropdowns[[1]]
  exploreDataOptions <- exploreDataDropdown$findChildElement("css selector", "ul")
  expect_true(exploreDataOptions$getElementSize()$width == 0)
  exploreDataDropdown$clickElement()
  expect_true(exploreDataOptions$getElementSize()$width > 0)
  exploreDataOptionsText <- c("Select Participants", "Visualize", "QC", "Analyze")
  expect_equal(
    unlist(lapply(exploreDataOptions$findChildElements("css selector", "li"),
                  function(x){x$getElementText()})),
    exploreDataOptionsText
  )

  optionsDropdown <- bannerDropdowns[[2]]
  optionsDropdownOptions <- optionsDropdown$findChildElement("css selector", "ul")
  expect_true(optionsDropdownOptions$getElementSize()$width == 0)
  optionsDropdown$clickElement()
  expect_true(optionsDropdownOptions$getElementSize()$width > 0)
  optionsList <- optionsDropdown$findChildElements("css selector", ".btn>ul>li")
  expect_equal(
    unlist(lapply(optionsList, function(x){x$getElementText()})),
    c("Save", "Save As", "My Groups Dashboard", "Send", "Load")
  )

  loadGroupsDropdown <- optionsList[[5]]
  loadGroupsOptions <- loadGroupsDropdown$findChildElements("css selector", "li")
  expect_true(loadGroupsOptions[[1]]$getElementSize()$width == 0)
  loadGroupsDropdown$clickElement()
  expect_true(loadGroupsOptions[[1]]$getElementSize()$width > 0)

  optionsDropdown$clickElement()
  expect_true(loadGroupsOptions[[1]]$getElementSize()$width == 0)
  expect_true(optionsDropdownOptions$getElementSize()$width == 0)

})

test_that("banner buttons are present", {
  buttonText <- c("Download Data", "Open In RStudio")
  buttonHref <- paste0(site_url,
                       c("/immport/Studies/exportStudyDatasets.view?", "/rstudio/start.view?"))

  bannerButtons <- remDr$findElements("css selector", "#data-finder-app-banner .df-highlighted-button")
  expect_length(bannerButtons, 2)
  expect_equal(unlist(lapply(bannerButtons, function(x)x$getElementText())),
               buttonText)
  expect_equal(unlist(lapply(bannerButtons, function(x)x$getElementAttribute("href"))),
               buttonHref)

})


# --------------- FILTERS --------------------------

test_that("Filter dropdown works", {
  filterDropdown <- remDr$findElement("css selector", "#data-finder-filters .df-outer-dropdown")
  expect_equal(filterDropdown$findChildElement("css selector", "button")$getElementText()[[1]], "Filters")
  filterContent <- filterDropdown$findChildElement("class", "dropdown-menu")
  expect_true(filterContent$getElementSize()$width == 0)
  filterDropdown$clickElement()
  expect_true(filterContent$getElementSize()$width > 0)
  filterDropdown$clickElement()
  expect_true(filterContent$getElementSize()$width == 0)
})

test_that("Filter selector buttons are present", {
  filterDropdownButton <- remDr$findElement("css selector", "#data-finder-filters .df-outer-dropdown")
  filterDropdownButton$clickElement()
  filterDropdown <- remDr$findElement("css selector", "#data-finder-filters .dropdown-menu")

  studyDesignOptions <- c("Condition",
                   "Research Focus",
                   "Study")
  participantCharacteristicsOptions <- c("Gender",
                                  "Age",
                                  "Race")
  dropdownButtonGroups <- filterDropdown$findChildElements("class", "filter-dropdown-set")
  expect_length(dropdownButtonGroups, 2)
  expect_equal(unlist(lapply(dropdownButtonGroups[[1]]$findChildElements("class", "df-filter-dropdown"),
         function(filterButton) {
           filterButton$findChildElement("css selector", "button")$getElementText()
         })), studyDesignOptions)
  expect_equal(unlist(lapply(dropdownButtonGroups[[2]]$findChildElements("class", "df-filter-dropdown"),
                function(filterButton) {
                  filterButton$findChildElement("css selector", "button")$getElementText()
                })), participantCharacteristicsOptions)
  filterDropdownButton$clickElement()
})

test_that("Filter selector choices are present", {
  filterDropdownButton <- remDr$findElement("css selector", "#data-finder-filters .df-outer-dropdown")
  filterDropdownButton$clickElement()
  filterSets <- remDr$findElements("css selector", "#data-finder-filters .filter-dropdown-set")

  lapply(filterSets, function(filterSet){
    lapply(filterSet$findChildElements("class", "df-filter-dropdown"), function(filterDropdown){
      dropdownButton <- filterDropdown$findChildElement("css selector", "button")
      dropdownMenu <- filterDropdown$findChildElement("class", "filter-menu")
      expect_equal(dropdownMenu$getElementSize()$width, 0)
      dropdownButton$clickElement()
      expect_gt(dropdownMenu$getElementSize()$width, 0)
      filterOptions <- dropdownMenu$findChildElements("class", "checkbox")
      expect_gt(length(filterOptions), 0)
      dropdownButton$clickElement()
    })
  })
  filterDropdownButton$clickElement()
})


# -------- Plot tabs -------------------

test_that("Plot tabs work", {
  plotTabs <- remDr$findElement("id", "data-finder-viz")

  tabTitles <- c("Selected Participants", "Selected Studies")
  tabTitleElements <- plotTabs$findChildElements("class", "df-tab-title")
  expect_equal(unlist(lapply(tabTitleElements,function(x)x$getElementText())),
               tabTitles)

  selectedParticipantsTitle <- tabTitleElements[[1]]
  selectedStudiesTitle <- tabTitleElements[[2]]

  selectedParticipantsContent <- remDr$findElement("id", "df-tab-selected-participants")
  selectedStudiesContent <- remDr$findElement("id", "df-tab-selected-studies")

  selectedParticipantsTitle$clickElement()
  expect_gt(selectedParticipantsContent$getElementSize()$width, 0)
  expect_true(grepl("active", selectedParticipantsContent$getElementAttribute("class")))
  expect_equal(selectedStudiesContent$getElementSize()$width, 0)
  expect_false(grepl("active", selectedStudiesContent$getElementAttribute("class")))

  selectedStudiesTitle$clickElement()
  expect_equal(selectedParticipantsContent$getElementSize()$width, 0)
  expect_false(grepl("active", selectedParticipantsContent$getElementAttribute("class")))
  expect_gt(selectedStudiesContent$getElementSize()$width, 0)
  expect_true(grepl("active", selectedStudiesContent$getElementAttribute("class")))

  selectedParticipantsTitle$clickElement()
  expect_gt(selectedParticipantsContent$getElementSize()$width, 0)
  expect_true(grepl("active", selectedParticipantsContent$getElementAttribute("class")))
  expect_equal(selectedStudiesContent$getElementSize()$width, 0)
  expect_false(grepl("active", selectedStudiesContent$getElementAttribute("class")))
})

test_that("Barplots are present", {

  test_barplot <- function(id){
    svgId <- paste0('svg-barplot-', id)
    el <- remDr$findElement('id', svgId)
    expect_length(el, 1)

    if ( length(el) > 0 ) {
      rectsContainer <- paste0('bars-', id)
      el <- remDr$findElements('id', rectsContainer)
      expect_length(el, 1)

      bars <- el[[1]]$findChildElements('class', 'rect')
      expect_gt(length(bars), 0)

      yAxisLabels <- paste0('yaxis-labels-short-', id)
      el <- remDr$findElement('id', yAxisLabels)
      expect_length(el, 1)
      labelText <- el$findChildElements('css selector', 'text')
      labelCount <- length(labelText)
      expect_gt(labelCount, 1)

      hoverLabels <- paste0('yaxis-labels-', id)
      el <- remDr$findElement('id', hoverLabels)
      expect_length(el, 1)
      longLabels <- el$findChildElements('class', 'yaxis-long-label-container')
      expect_length(longLabels, labelCount)

      xAxis <- paste0('xaxis-', id)
      el <- remDr$findElement('id', xAxis)
      expect_length(el, 1)
      xAxisTitle <- el$findChildElement("class", "x-axis-title")
      expect_equal(xAxisTitle$getElementText()[[1]], "Participants")

    }
  }

  # Study Design
  studyDesignPlots <- c("Condition",
                        "ResearchFocus")

  dmp <- lapply(studyDesignPlots, test_barplot)

  # Participant Characteristics
  participantCharsPlots <- c("Age",
                             "Gender",
                             "Race")

  dmp <- lapply(participantCharsPlots, test_barplot)

  # Available Assay Data
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

test_that("Study Cards are present", {
  selectedStudiesTitle <- remDr$findElements("class", "df-tab-title")[[2]]
  selectedStudiesTitle$clickElement()
  studyCards <- remDr$findElements("class", "study-card")
  expect_gt(length(studyCards), 100)
})

# --------------------- APPLYING FILTERS -------------------------------

test_that("Outputs change when filters are applied", {

  getPlotValues <- function(plotName){
    barplot <- remDr$findElement('id', paste0('bars-', plotName))
    bars <- barplot$findChildElements('class', 'rect')
    values <- sapply(bars, function(bar){
      return(as.numeric(unlist(bar$getElementAttribute('width'))))
    })
  }

  getBannerValues <- function(){
    bannerDiv <- remDr$findElement('id','data-finder-app-banner')
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
  filterDropdownButton <- remDr$findElement("css selector", "#data-finder-filters .df-outer-dropdown")
  filterDropdownButton$clickElement()
  filterDropdown <- remDr$findElement("css selector", "#data-finder-filters .dropdown-menu")

  conditionFilter <- filterDropdown$findChildElement('id', "df-filter-dropdown-Condition")
  conditionFilter$clickElement()
  influenzaCheckBox <- conditionFilter$findChildElement('xpath',
                                                        '//*/input[@value="Influenza"]')
  influenzaCheckBox$clickElement()

  genderFilter <- remDr$findElement('id', 'df-filter-dropdown-Gender')
  genderFilter$clickElement()
  femaleCheckBox <- genderFilter$findChildElement('xpath',
                                                  '//*/input[@value="Female"]')
  femaleCheckBox$clickElement()

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
  clearAllBtn <- remDr$findElement('id', 'clear-all-button')
  clearAllBtn$clickElement()

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

# --------------------- OTHER -------------------------

test_that("Summary numbers match visualizations", {
  summaryTextEl <- remDr$findElement("id", "data-finder-app-banner")$findChildElement("class", "df-group-summary-counts")
  summaryText <- summaryTextEl$getElementText()[[1]]

  # Make sure barplots have rendered
  selectedParticipantsTitle <- remDr$findElements("class", "df-tab-title")[[1]]
  selectedParticipantsTitle$clickElement()

  studyCards <- remDr$findElements("class", "study-card")
  totalStudies <- length(studyCards)

  genderNumberEls <- remDr$findElement("id", "barplot-container-Gender")$findChildElements("class", "label-number")
  genderNumbers <- unlist(lapply(genderNumberEls, function(el) as.numeric(el$getElementText()[[1]])))
  totalParticipants <- sum(genderNumbers)

  expect_equal(summaryText, paste0(totalParticipants, " participants from ", totalStudies, " studies"))
})

