if (!exists("remDr")) source("initialize.R")

page_url <- paste0(site_url, "/project/Studies/begin.view?pageId=About")

context_of("test-aboutPage.R", "About Page", page_url)

test_connection(remDr, page_url, "About: /Studies")

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
  tab <- remDr$findElement('id', 'navbar-link-data-standards')
  tab$clickElement()

  div <- remDr$findElement('id', 'DataStandards')
  expect_length(div, 1)

  paragraphs <- div$findChildElements('tag name', 'p')
  expect_length(paragraphs, 13)
})

test_that("Data Processing tab has correct elements", {

  tab <- remDr$findElement('id', 'DataProcessingDropdown')
  tab$clickElement()

  navbarLi <- remDr$findElement('id', 'navbar-link-data-processing')
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

  div <- remDr$findElement('id', 'DataProcessing')
  test_presence_of_single_img(div)
})
