if (!exists("remDr")) source("initialize.R")

page_url <- paste0(site_url, "/project/Studies/begin.view?pageId=Resources")

context_of("test-resourcesPage.R", "Resources Page", page_url)

test_connection(remDr, page_url, "Resources: /Studies")

sleep_for(2)

test_that("test navigating to link tabs", {
  remDr$findElements("id", "headerUserDropdown")[[1]]$clickElement()

  remDr$findElements("css", "li#headerUserDropdown ul.dropdown-menu.dropdown-menu-right li")[[9]]$clickElement()
  site_title <- remDr$getTitle()[[1]]
  expect_equal(site_title, "Welcome to ImmuneSpace")

  remDr$navigate(paste0(site_url, "/project/Studies/begin.view?pageId=Resources&tab=Reports"))
  site_title <- remDr$getTitle()[[1]]
  expect_equal(site_title, "Sign In: /Studies")

  remDr$findElements("id", "email")[[1]]$sendKeysToElement(list(ISR_LOGIN))
  remDr$findElements("id", "password")[[1]]$sendKeysToElement(list(ISR_PWD))
  remDr$findElements("css", "a.labkey-button.primary.signin-btn")[[1]]$clickElement()
  sleep_for(5)
  site_title <- remDr$getTitle()[[1]]
  expect_equal(site_title, "Resources: /Studies")
  current_url <- paste0(page_url, "&tab=Reports")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(unlist(remDr$findElements("css", "div.tab-content div#Reports")[[1]]$getElementAttribute("aria-hidden")), "false")
})


test_that("test clicking linkable tabs", {
  navigate_to_link("Reports")
  sleep_for(2)
  current_url <- paste0(page_url, "&tab=Reports")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(unlist(remDr$findElements("css", "nav.navbar.navbar-default ul.nav.navbar-nav li")[[1]]$getElementAttribute("class")), "active")
  expect_equal(unlist(remDr$findElements("css", "div.tab-content div#Reports")[[1]]$getElementAttribute("aria-hidden")), "false")


  navigate_to_link("Tools")
  sleep_for(10)
  current_url <- paste0(page_url, "&tab=Tools")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(unlist(remDr$findElements("css", "nav.navbar.navbar-default ul.nav.navbar-nav li a#Tools")[[1]]$getElementAttribute("aria-selected")), "true")
  expect_equal(unlist(remDr$findElements("css", "div.tab-content div#Tools")[[1]]$getElementAttribute("aria-hidden")), "false")

  navigate_to_link("ImmuneSpaceR")
  sleep_for(2)
  current_url <- paste0(page_url, "&tab=ImmuneSpaceR")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(unlist(remDr$findElements("css", "nav.navbar.navbar-default ul.nav.navbar-nav li a#ImmuneSpaceR")[[1]]$getElementAttribute("aria-selected")), "true")
  expect_equal(unlist(remDr$findElements("css", "div.tab-content div#ImmuneSpaceR")[[1]]$getElementAttribute("aria-hidden")), "false")

  remDr$findElements("css", "div#resources-page ul.nav.navbar-nav li.dropdown")[[1]]$clickElement()
  sleep_for(1)
  navigate_to_link("MostAccessed")
  sleep_for(1)
  current_url <- paste0(page_url, "&tab=MostAccessed")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(unlist(remDr$findElements("css", "nav.navbar.navbar-default ul.nav.navbar-nav li")[[2]]$getElementAttribute("class")), "active dropdown")
  expect_equal(unlist(remDr$findElements("css", "div.tab-content div#MostAccessed")[[1]]$getElementAttribute("aria-hidden")), "false")

  remDr$findElements("css", "div#resources-page ul.nav.navbar-nav li.dropdown")[[1]]$clickElement()
  navigate_to_link("MostCited")
  sleep_for(1)
  current_url <- paste0(page_url, "&tab=MostCited")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(unlist(remDr$findElements("css", "div.tab-content div#MostCited")[[1]]$getElementAttribute("aria-hidden")), "false")

  remDr$findElements("css", "div#resources-page ul.nav.navbar-nav li.dropdown")[[1]]$clickElement()
  navigate_to_link("SimilarStudies")
  sleep_for(1)
  current_url <- paste0(page_url, "&tab=SimilarStudies")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(unlist(remDr$findElements("css", "div.tab-content div#SimilarStudies")[[1]]$getElementAttribute("aria-hidden")), "false")
})

test_that("test linking tabs from alternative url", {
  remDr$navigate("https://www.google.com/")
  expect_equal(unlist(remDr$getCurrentUrl()), "https://www.google.com/")

  remDr$navigate(page_url)
  sleep_for(5)
  current_url <- paste0(page_url, "&tab=Reports")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(unlist(remDr$findElements("css", "nav.navbar.navbar-default ul.nav.navbar-nav li")[[1]]$getElementAttribute("class")), "active")
  expect_equal(unlist(remDr$findElements("css", "div.tab-content div#Reports")[[1]]$getElementAttribute("aria-hidden")), "false")

  remDr$goBack()
  sleep_for(5)
  expect_equal(unlist(remDr$getCurrentUrl()), "https://www.google.com/")

  remDr$goForward()
  sleep_for(5)
  current_url <- paste0(page_url, "&tab=Reports")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(unlist(remDr$findElements("css", "nav.navbar.navbar-default ul.nav.navbar-nav li")[[1]]$getElementAttribute("class")), "active")
  expect_equal(unlist(remDr$findElements("css", "div.tab-content div#Reports")[[1]]$getElementAttribute("aria-hidden")), "false")

  remDr$goBack()
  sleep_for(5)
  expect_equal(unlist(remDr$getCurrentUrl()), "https://www.google.com/")

  remDr$navigate(paste0(page_url, "&tab=SimilarStudies"))
  sleep_for(1)
  current_url <- paste0(page_url, "&tab=SimilarStudies")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#SimilarStudies")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$goBack()
  sleep_for(5)
  expect_equal(unlist(remDr$getCurrentUrl()), "https://www.google.com/")

  remDr$goForward()
  sleep_for(1)
  current_url <- paste0(page_url, "&tab=SimilarStudies")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#SimilarStudies")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")
})

test_that("forward and back buttons", {
  current_url <- paste0(page_url, "&tab=SimilarStudies")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)

  navigate_to_link("ImmuneSpaceR")
  sleep_for(20)

  current_url <- paste0(page_url, "&tab=ImmuneSpaceR")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(unlist(remDr$findElements("css", "nav.navbar.navbar-default ul.nav.navbar-nav li a#ImmuneSpaceR")[[1]]$getElementAttribute("aria-selected")), "true")
  expect_equal(unlist(remDr$findElements("css", "div.tab-content div#ImmuneSpaceR")[[1]]$getElementAttribute("aria-hidden")), "false")

  remDr$goBack()
  sleep_for(5)

  current_url <- paste0(page_url, "&tab=SimilarStudies")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#SimilarStudies")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$goForward()
  sleep_for(20)
  current_url <- paste0(page_url, "&tab=ImmuneSpaceR")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(unlist(remDr$findElements("css", "nav.navbar.navbar-default ul.nav.navbar-nav li a#ImmuneSpaceR")[[1]]$getElementAttribute("aria-selected")), "true")
  expect_equal(unlist(remDr$findElements("css", "div.tab-content div#ImmuneSpaceR")[[1]]$getElementAttribute("aria-hidden")), "false")

  remDr$goBack()
  sleep_for(5)
})

test_that("page refresh", {
  current_url <- paste0(page_url, "&tab=SimilarStudies")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)

  remDr$refresh()
  sleep_for(5)
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#SimilarStudies")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$findElements("id", "ImmuneSpaceR")[[1]]$clickElement()
  sleep_for(1)
  current_url <- paste0(page_url, "&tab=ImmuneSpaceR")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#ImmuneSpaceR")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$refresh()
  sleep_for(10)
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#ImmuneSpaceR")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")
})


test_that("all webpart is present", {
  test_presence_of_single_item("resources-page")
})

test_that("Highlighted Reports tab has correct elements", {
  navigate_to_link("Reports")

  div <- remDr$findElement("id", "Reports-content")
  expect_length(div, 1)

  # number of reports is greater than 0
  tableRows <- div$findChildElements("tag name", "tr")
  expect_length(tableRows, 6)

  # pictures and text are present
  actualHeaders <- unlist(sapply(tableRows, function(tr) {
    imgTd <- tr$findChildElement("class", "hr-imgCol")
    test_presence_of_single_img(imgTd)

    infoTd <- tr$findChildElement("class", "hr-infoCol")
    ahref <- infoTd$findChildElement("tag name", "a")
    expect_length(ahref, 1)

    header <- infoTd$findChildElement("tag name", "h2")
    headerText <- header$getElementText()
  }))

  expectedHeaders <- c(
    "Correlation of HAI/VN and plasma cell counts",
    "Measuring plasmablast abundance by multi-parameter flow cytometry",
    "Multiple custom reports related to CyTOF and Flow Cytometry Data",
    "Correlating HAI with flow cytometry and ELISPOT results",
    "Influenza Vaccine Meta-Analysis to define genetic predictors of vaccine response",
    "Standardizing Flow Cytometry Immunophenotyping from Reagents to Analyses: Results of the Human ImmunoPhenotyping Consortium"
  )

  expect_true(all.equal(actualHeaders, expectedHeaders))
})

test_that("Study Statistics tab has correct elements", {
  getBarPlotWidths <- function(rectsContainer) {
    widths <- unlist(sapply(rectsContainer, function(rect) {
      width <- rect$getElementAttribute("width")
    }))
  }

  # ----
  click_target_dropdown("Study Statistics")

  reportOptions <- get_dropdown_options()
  expect_length(reportOptions, 3)

  expectedReportTitles <- c(
    "Most Accessed",
    "Most Cited",
    "Similar Studies"
  )
  check_dropdown_titles(expectedReportTitles, reportOptions)

  ###########################
  #  Most accessed studies  #
  ###########################
  reportOptions[[1]]$clickElement()
  sleep_for(2)

  mostAccessedDiv <- remDr$findElement("id", "most-accessed-content")
  h2 <- mostAccessedDiv$findChildElements("tag name", "h2")
  expect_length(h2, 1)

  # --- check byStudy ---
  byStudyDiv <- mostAccessedDiv$findChildElement("id", "byStudy")

  plot <- byStudyDiv$findChildElement("id", "ma-barplot-byStudy")
  rects <- plot$findChildElements("tag name", "rect")
  allUxWidths <- getBarPlotWidths(rects)
  expect_true(length(allUxWidths) > 150)

  selectOrderBtn <- remDr$findElement("id", "ma-bar-order-select-dropdown")
  expect_length(selectOrderBtn, 1)
  selectOrderBtn$clickElement()

  parentDiv <- remDr$findElement("css", "[class = 'dropdown open btn-group']")
  ahrefs <- parentDiv$findChildElements("tag name", "a")
  expect_length(ahrefs, 3)
  orderOptions <- unlist(sapply(ahrefs, function(a) {
    text <- a$getElementText()
  }))

  expectedOrderOptions <- c(
    "UI Pageviews",
    "ImmuneSpaceR connections",
    "All interactions"
  )
  expect_true(all.equal(orderOptions, expectedOrderOptions))

  ahrefs[[1]]$clickElement()
  sleep_for(2)
  plot <- remDr$findElement("id", "ma-barplot-byStudy")
  rects <- plot$findChildElements("tag name", "rect")
  pageViewWidths <- getBarPlotWidths(rects)

  expect_true(!isTRUE(all.equal(pageViewWidths, allUxWidths)))

  selectOrderBtn <- remDr$findElement("id", "ma-bar-order-select-dropdown")
  selectOrderBtn$clickElement()
  parentDiv <- remDr$findElement("css", "[class = 'dropdown open btn-group']")
  ahrefs <- parentDiv$findChildElements("tag name", "a")

  ahrefs[[2]]$clickElement()
  sleep_for(2)
  plot <- remDr$findElement("id", "ma-barplot-byStudy")
  rects <- plot$findChildElements("tag name", "rect")
  isrConnectionsWidths <- getBarPlotWidths(rects)

  expect_true(!isTRUE(all.equal(isrConnectionsWidths, pageViewWidths)))

  selectPlotTypeBtn <- remDr$findElement("id", "ma-type-select-dropdown")
  selectPlotTypeBtn$clickElement()
  parentDiv <- remDr$findElement("css", "[class = 'dropdown open btn-group']")
  ahrefs <- parentDiv$findChildElements("tag name", "a")

  expect_length(ahrefs, 2)
  plotTypeOptions <- unlist(sapply(ahrefs, function(a) {
    text <- a$getElementText()
  }))

  expectedPlotTypeOptions <- c(
    "By Study",
    "By Month"
  )
  expect_true(all.equal(plotTypeOptions, expectedPlotTypeOptions))
  ahrefs[[2]]$clickElement()
  sleep_for(2)

  selectOrderBtn <- remDr$findElements("id", "ma-bar-order-select-dropdown")
  expect_length(selectOrderBtn, 0)

  plot <- remDr$findElement("id", "ma-lineplot-byMonth")
  paths <- plot$findChildElements("tag name", "path")
  domains <- sapply(paths, function(x) {
    x$getElementAttribute("class")
  })
  paths <- paths[lengths(domains) == 0] # domain paths are for axis labels
  expect_length(paths, 2)

  ########################
  #  Most Cited Studies  #
  ########################
  click_target_dropdown("Study Statistics")
  reportOptions <- get_dropdown_options()
  reportOptions[[2]]$clickElement()

  sleep_for(2)

  mostCitedDiv <- remDr$findElement("id", "#most-cited")
  h2 <- mostCitedDiv$findChildElement("tag name", "h2")
  expect_length(h2, 1)

  ul <- mostCitedDiv$findChildElement("tag name", "ul")
  liElements <- ul$findChildElements("tag name", "li")
  expect_length(liElements, 3)

  plot <- mostCitedDiv$findChildElement("id", "mc-barplot-byPubId")
  rects <- plot$findChildElements("tag name", "rect")
  byPubIdWidths <- getBarPlotWidths(rects)
  expect_true(length(byPubIdWidths) > 65)

  selectOrderBtn <- remDr$findElement("id", "order-select-dropdown")
  expect_length(selectOrderBtn, 1)
  selectOrderBtn$clickElement()

  parentDiv <- remDr$findElement("css", "[class = 'dropdown open btn-group']")
  ahrefs <- parentDiv$findChildElements("tag name", "a")
  expect_length(ahrefs, 3)
  orderOptions <- unlist(sapply(ahrefs, function(a) {
    text <- a$getElementText()
  }))

  expectedOrderOptions <- c(
    "Most Cited",
    "Study ID",
    "Most Recent"
  )
  expect_true(all.equal(orderOptions, expectedOrderOptions))

  ahrefs[[2]]$clickElement()
  sleep_for(2)

  plot <- remDr$findElement("id", "mc-barplot-byPubId")
  rects <- plot$findChildElements("tag name", "rect")
  byMostCitedWidths <- getBarPlotWidths(rects)

  expect_true(!isTRUE(all.equal(byPubIdWidths, byMostCitedWidths)))

  #####################
  #  Similar Studies  #
  #####################

  # -- Assays --
  click_target_dropdown("Study Statistics")
  reportOptions <- get_dropdown_options()
  reportOptions[[3]]$clickElement()

  similarStudiesDiv <- remDr$findElement("id", "similar-studies-content")
  h2 <- similarStudiesDiv$findChildElement("tag name", "h2")
  expect_length(h2, 1)

  ul <- similarStudiesDiv$findChildElement("tag name", "ul")
  liElements <- ul$findChildElements("tag name", "li")
  expect_length(liElements, 2)

  assaysDiv <- similarStudiesDiv$findChildElement("id", "assays")
  plots <- assaysDiv$findChildElements("tag name", "svg")
  expect_length(plots, 8)

  circles <- plots[[1]]$findChildElements("tag name", "circle")
  expect_true(length(circles) > 95)

  byAssayIds <- unlist(sapply(plots, function(plot) {
    id <- plot$getElementAttribute("id")
  }))

  selectOrderBtn <- similarStudiesDiv$findChildElements("id", "order-select-dropdown")
  expect_length(selectOrderBtn, 1)
  selectOrderBtn[[1]]$clickElement()

  parentDiv <- remDr$findElement("css", "[class = 'dropdown open btn-group']")
  ahrefs <- parentDiv$findChildElements("tag name", "a")
  expect_length(ahrefs, 3)
  orderOptions <- unlist(sapply(ahrefs, function(a) {
    text <- a$getElementText()
  }))

  expectedOrderOptions <- c(
    "Assay Data Available",
    "Study Design",
    "Condition Studied"
  )
  expect_true(all.equal(orderOptions, expectedOrderOptions))

  ahrefs[[2]]$clickElement()
  sleep_for(2)

  # -- similar study design --
  similarStudiesDiv <- remDr$findElement("id", "similar-studies-content")
  studyDesignDiv <- similarStudiesDiv$findChildElement("id", "studyDesign")
  plots <- studyDesignDiv$findChildElements("tag name", "svg")
  expect_length(plots, 4)

  circles <- plots[[1]]$findChildElements("tag name", "circle")
  expect_true(length(circles) > 95)

  byStudyDesignIds <- unlist(sapply(plots, function(plot) {
    id <- plot$getElementAttribute("id")
  }))

  expect_true(!isTRUE(all.equal(byAssayIds, byStudyDesignIds)))

  # -- condition studied --
  selectOrderBtn[[1]]$clickElement()
  ahrefs[[3]]$clickElement()

  conditionDiv <- similarStudiesDiv$findChildElement("id", "condition")
  plots <- conditionDiv$findChildElements("tag name", "svg")
  expect_length(plots, 16)
})

test_that("HIPC Tools tab has correct elements", {
  navigate_to_link("Tools")

  div <- remDr$findElement("id", "tools-content")
  expect_length(div, 1)

  sections <- div$findChildElements("tag name", "p")
  expect_length(sections, 5)
})

test_that("HIPC ImmuneSpaceR tab has correct elements", {
  navigate_to_link("ImmuneSpaceR")

  sleep_for(3)

  iframe <- remDr$findElement("tag", "iframe")
  expect_length(iframe, 1)

  # TODO: how to inspect iframe contents?
})
