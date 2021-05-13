if (!exists("remDr")) source("initialize.R")

page_url <- paste0(site_url, "/project/home/begin.view?")

context_of("test-aboutPage.R", "About Page", page_url)

test_connection(remDr, page_url, "About: /home")

sleep_for(5)

test_that("all webpart is present", {
  test_presence_of_single_item("about-page")
})


test_that("About tab has correct elements", {
  div <- remDr$findElement("id", "About-content")
  expect_length(div, 1)

  paragraphs <- div$findChildElements("tag name", "p")
  expect_length(paragraphs, 5)

  test_presence_of_single_img(div)
})

test_that("Data Standards tab has correct elements", {
  tab <- remDr$findElement("id", "DataStandards")
  tab$clickElement()

  div <- remDr$findElement("id", "DataStandards-content")
  expect_length(div, 1)

  paragraphs <- div$findChildElements("tag name", "p")
  expect_length(paragraphs, 13)
})

test_that("Data Processing tab has correct elements", {
  click_target_dropdown("Data Processing")

  assayOptions <- get_dropdown_options()
  expect_length(assayOptions, 1)

  expectedAssayTitles <- "Gene Expression"
  check_dropdown_titles(expectedAssayTitles, assayOptions)

  assayOptions[[1]]$clickElement()

  div <- remDr$findElement("id", "gene-expression")
  expect_length(div, 1)

  if (length(div) == 1) {
    img <- remDr$findElement("xpath", "//img[@src='/AboutPage/images/ge_standardization.png']")
    expect_length(img, 1)
  }
})

test_that("Data Releases tab has correct elements", {
  tab <- remDr$findElement("id", "DataReleases")
  tab$clickElement()

  div <- remDr$findElement("id", "DataReleases-content")
  expect_length(div, 1)

  paragraphs <- div$findChildElements("tag name", "p")
  expect_length(paragraphs, 2)

  table <- div$findChildElements("tag name", "table")
  expect_length(table, 1)

  cols <- div$findChildElements("tag name", "th")
  expect_length(cols, 4)

  colTitles <- sapply(cols, function(x) {
    title <- x$getElementText()[[1]]
  })
  expectedTitles <- c("Version", "Date", "Affected Studies", "Description")
  expect_equal(colTitles, expectedTitles)

  rows <- div$findChildElements("tag name", "td")
  expect_gt(length(rows), 100)
})

test_that("Software Updates tab has correct elements", {
  tab <- remDr$findElement("id", "SoftwareUpdates")
  tab$clickElement()

  div <- remDr$findElement("id", "SoftwareUpdates-content")
  expect_length(div, 1)

  paragraphs <- div$findChildElements("tag name", "p")
  expect_gt(length(paragraphs), 33)
})

test_that("R Session Info tab has correct elements", {
  tab <- remDr$findElement("id", "RSessionInfo")
  tab$clickElement()

  # Rmd html output is appended as child and there is no 'id' of the div directly
  div <- remDr$findElement("class", "labkey-knitr")
  expect_length(div, 1)

  codeChunks <- div$findChildElements("tag name", "code")
  expect_length(codeChunks, 2)

  htmlWidget <- div$findChildElement("tag", "div")
  expect_true(grepl("htmlwidget", htmlWidget$getElementAttribute("id")[[1]]))

  dataTable <- htmlWidget$findChildElement("tag", "table")
  tableHeaders <- dataTable$findChildElements("tag", "th")
  expect_length(tableHeaders, 5)

  colNames <- sapply(tableHeaders, function(x) {
    name <- x$getElementText()[[1]]
  })
  expectedTitles <- c("package", "attached", "version", "date", "source")
  expect_equal(colNames, expectedTitles)

  # This means that the table didn't render correctly!
  rows <- dataTable$findChildElements("tag", "tr")
  expect_gt(length(rows), 10)
})
