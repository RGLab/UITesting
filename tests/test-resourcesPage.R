if (!exists("remDr")) source("initialize.R")

page_url <- paste0(site_url, "/project/Studies/begin.view?pageId=Resources")
context_of("test-resourcesPage.R", "Resources Page", page_url)

test_connection(remDr, page_url, "Resources: /Studies")

sleep_for(5)

test_that("all webpart is present", {
  test_presence_of_single_item('app')
})

test_that("About tab has correct elements", {

  div <- remDr$findElement('id', 'About')
  expect_length(div, 1)

  paragraphs <- div$findChildElements('tag name', 'p')
  expect_length(paragraphs, 3)

  test_presence_of_single_img(div)
})

test_that("Data Standards tab has correct elements", {

  tab <- remDr$findElement('id', 'DataStandardsDropdown')
  tab$clickElement()

  navbarLi <- remDr$findElement('id', 'navbar-link-data-standards')
  assayOptions <- navbarLi$findChildElements('tag name', 'li')
  expect_length(assayOptions, 3)

  assayTitles <- sapply(assayOptions, function(li){
    ahref <- li$findChildElement('tag name', 'a')
    innerText <- ahref$getElementText()[[1]]
  })
  expectedAssayTitles <- c("Cytometry",
                          "Gene Expression",
                          "Immune Response")
  expect_true(all.equal(assayTitles, expectedAssayTitles))

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
  getBarPlotWidths <- function(rectsContainer){
    widths <- unlist(sapply(rectsContainer, function(rect){
      width <- rect$getElementAttribute('width')
    }))
  }

  # ----
  tab <- remDr$findElement('id', 'StudyStatsDropdown')
  tab$clickElement()

  navbarLi <- remDr$findElement('id', 'navbar-link-study-stats')
  reportOptions <- navbarLi$findChildElements('tag name', 'li')
  expect_length(reportOptions, 3)

  reportTitles <- sapply(reportOptions, function(li){
    ahref <- li$findChildElement('tag name', 'a')
    innerText <- ahref$getElementText()[[1]]
  })
  expectedReportTitles <- c("Most Accessed",
                          "Most Cited",
                          "Similar Studies")
  expect_true(all.equal(reportTitles, expectedReportTitles))

  # Most accessed studies
  reportOptions[[1]]$clickElement()

  mostAccessedDiv <- remDr$findElement('id', '#most-accessed')
  h2 <- mostAccessedDiv$findChildElement('tag name', 'h2')
  expect_length(h2, 1)

  ul <- mostAccessedDiv$findChildElement('tag name', 'ul')
  liElements <- ul$findChildElements('tag name', 'li')
  expect_length(liElements, 3)

  plot <- mostAccessedDiv$findChildElement('id', 'ma-barplot-byStudy')
  rects <- plot$findChildElements('tag name', 'rect')
  allUxWidths <- getBarPlotWidths(rects)
  expect_true(length(allUxWidths) > 150)

  selectOrderBtn <- remDr$findElement('id', 'ma-bar-order-select-dropdown')
  expect_length(selectOrderBtn, 1)
  selectOrderBtn$clickElement()

  parentDiv <- remDr$findElement('css', "[class = 'dropdown open btn-group']")
  ahrefs <- parentDiv$findChildElements('tag name', 'a')
  expect_length(ahrefs, 3)
  orderOptions <- unlist(sapply(ahrefs, function(a){
    text <- a$getElementText()
  }))

  expectedOrderOptions <- c("UI Pageviews",
                            "ImmuneSpaceR connections",
                            "All interactions")
  expect_true(all.equal(orderOptions, expectedOrderOptions))

  ahrefs[[1]]$clickElement()
  plot <- remDr$findElement('id', 'ma-barplot-byStudy')
  rects <- plot$findChildElements('tag name', 'rect')
  pageViewWidths <- getBarPlotWidths(rects)

  expect_true(!isTRUE(all.equal(pageViewWidths, allUxWidths)))

  selectOrderBtn <- remDr$findElement('id', 'ma-bar-order-select-dropdown')
  selectOrderBtn$clickElement()
  parentDiv <- remDr$findElement('css', "[class = 'dropdown open btn-group']")
  ahrefs <- parentDiv$findChildElements('tag name', 'a')

  ahrefs[[2]]$clickElement()
  plot <- remDr$findElement('id', 'ma-barplot-byStudy')
  rects <- plot$findChildElements('tag name', 'rect')
  isrConnectionsWidths <- getBarPlotWidths(rects)

  expect_true(!isTRUE(all.equal(isrConnectionsWidths, pageViewWidths)))

  selectPlotTypeBtn <- remDr$findElement('id', 'ma-type-select-dropdown')
  selectPlotTypeBtn$clickElement()
  parentDiv <- remDr$findElement('css', "[class = 'dropdown open btn-group']")
  ahrefs <- parentDiv$findChildElements('tag name', 'a')

  expect_length(ahrefs, 2)
  plotTypeOptions <- unlist(sapply(ahrefs, function(a){
    text <- a$getElementText()
  }))

  expectedPlotTypeOptions <- c("By Study",
                               "By Month")
  expect_true(all.equal(plotTypeOptions, expectedPlotTypeOptions))
  ahrefs[[2]]$clickElement()

  selectOrderBtn <- remDr$findElements('id', 'ma-bar-order-select-dropdown')
  expect_length(selectOrderBtn, 0)

  plot <- remDr$findElement('id', 'ma-lineplot-byMonth')
  paths <- plot$findChildElements('tag name', 'path')
  expect_length(paths, 2)


    # select by time plot

    # by time
      # check select order btn not present
      # check plot is present and has values


  # Most cited studies
    # Plot is present
    # button changes order

  # Similar studies
    # All plots are present and button cycles through them
})



