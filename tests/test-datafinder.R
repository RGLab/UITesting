if (!exists("remDr")) source("initialize.R")

page_url <- paste0(site_url, "/project/Studies/begin.view?")
context_of("test-datafinder.R", "Data Finder", page_url)

test_connection(remDr, page_url, "Overview: /Studies")

sleep_for(3)

test_that("'Quick Help' is present", {
  remDr$executeScript("start_tutorial();")
  sleep_for(3)

  quick_help <- remDr$findElements("class", "hopscotch-bubble")
  expect_gte(length(quick_help), 1)

  if (length(quick_help) >= 1) {
    titles <- c(
      "Data Finder",
      "Study Panel",
      "Summary",
      "Filters",
      "Quick Search"
    )
    for (i in seq_along(titles)) {
      help_title <- quick_help[[1]]$findChildElements(
        "class", "hopscotch-title"
      )
      expect_equal(help_title[[1]]$getElementText()[[1]], titles[i])

      next_button <- quick_help[[1]]$findChildElements(
        "class", "hopscotch-next"
      )
      expect_equal(length(next_button), 1)

      close_button <- quick_help[[1]]$findChildElements(
        "class", "hopscotch-close"
      )
      expect_equal(length(close_button), 1)

      if (i == length(titles)) {
        close_Button[[1]]$clickElement()
      } else {
        next_button[[1]]$clickElement()
        sleep_for(1)
      }
    }
  }
})

test_studies_tab()

test_that("'Data Finder' module is present", {
  module <- remDr$findElements("id", "dataFinderApp")
  expect_equal(length(module), 1)
})

test_that("subject group controller is present", {
  filter_area <- remDr$findElements("id", "filterArea")
  expect_length(next_button, 1)

  group_label <- next_button[[1]]$findChildElements("class", "labkey-group-label")
  expect_length(group_label, 1)

  manage_menu <- next_button[[1]]$findChildElements("id", "df-manageMenu")
  expect_length(manage_menu, 1)
  if (length(manage_menu) == 1) {
    sleep_for(
      10, condition = expression(manage_menu[[1]]$isElementDisplayed()[[1]])
    )

    manage_menu[[1]]$clickElement()
    sleep_for(1)
    manage_items <- manage_menu[[1]]$findChildElements("class", "df-menu-item-link")
    expect_length(manage_items, 1)
  }

  load_menu <- filter_area[[1]]$findChildElements("id", "loadMenu")
  expect_length(load_menu, 1)
  if (length(load_menu) == 1) {
    load_menu[[1]]$clickElement()
    sleep_for(1)
    load_items <- load_menu[[1]]$findChildElements("class", "df-menu-item-link")
    expect_gt(length(load_items), 0)
  }

  save_menu <- filter_area[[1]]$findChildElements("id", "saveMenu")
  expect_length(save_menu, 1)
  if (length(save_menu) == 1) {
    save_menu[[1]]$clickElement()
    sleep_for(1)
    save_items <- save_menu[[1]]$findChildElements("class", "df-menu-item-link")
    expect_length(save_items, 2)
  }

  send_menu <- filter_area[[1]]$findChildElements("id", "sendMenu")
  expect_length(send_menu, 1)
})

test_that("search box is present", {
  search_box <- remDr$findElements("class", "studyfinder-header")
  expect_length(search_box, 1)

  search_terms <- search_box[[1]]$findChildElements("id", "searchTerms")
  expect_length(search_terms, 1)

  study_subset_select <- search_box[[1]]$findChildElements(
    "name", "studySubsetSelect"
  )
  expect_length(study_subset_select, 1)

  subset_options <- study_subset_select[[1]]$findChildElements(
    "class", "ng-scope"
  )
  expect_gte(length(subset_options), 3)
})

test_that("selection panel is present", {
  selection_panel <- remDr$findElements("id", "selectionPanel")
  expect_length(selection_panel, 1)

  summary_area <- selection_panel[[1]]$findChildElements("id", "summaryArea")
  expect_length(summary_area, 1)

  facet_panel <- selection_panel[[1]]$findChildElements("id", "facetPanel")
  expect_length(facet_panel, 1)

  facets <- facet_panel[[1]]$findChildElements("class", "df-facet")
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
  study_panel <- remDr$findElements("id", "studypanel")
  expect_length(study_panel, 1)

  study_cards<- study_panel[[1]]$findChildElements("class", "labkey-study-card")
  expect_gt(length(study_cards), 0)

  if (length(study_cards) > 0) {
    card_summary <- study_cards[[1]]$findChildElements(
      "class", "labkey-study-card-summary"
    )
    card_summary[[1]]$clickElement()
    sleep_for(1)

    study_detail <- remDr$findElements("class", "labkey-study-detail")
    expect_length(study_detail, 1)

    study_demographics <- studyDetail[[1]]$findChildElements(
      "class", "study-demographics"
    )
    expect_length(study_demographics, 1)
  }
})
