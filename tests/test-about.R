if (!exists("remDr")) source("initialize.R")

page_url <- paste0(site_url, "/project/home/begin.view?")

context_of("test-aboutPage.R", "About Page", page_url)

test_connection(remDr, page_url, "About: /home")

sleep_for(5)


test_that("test clicking linkable tabs", {
  current_url <- paste0(page_url, "tab=About")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#About")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")
  remDr$findElements("id", "DataStandards")[[1]]$clickElement()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=DataStandards")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#DataStandards")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")


  remDr$findElements("id", "DataReleases")[[1]]$clickElement()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=DataReleases")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#DataReleases")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")


  remDr$findElements("id", "SoftwareUpdates")[[1]]$clickElement()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=SoftwareUpdates")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#SoftwareUpdates")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")


  remDr$findElements("id", "RSessionInfo")[[1]]$clickElement()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=RSessionInfo")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#RSessionInfo")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")


  remDr$findElements("css", "div#about-page ul.nav.navbar-nav li.dropdown")[[1]]$clickElement()
  sleep_for(1)
  remDr$findElements("id", "GeneExpression")[[1]]$clickElement()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=GeneExpression")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#GeneExpression")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")
})

test_that("test forward and back buttons on linkable tabs", {
  current_url <- paste0(page_url, "tab=GeneExpression")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#GeneExpression")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")


  remDr$goBack()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=RSessionInfo")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#RSessionInfo")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")


  remDr$goBack()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=SoftwareUpdates")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#SoftwareUpdates")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")


  remDr$goBack()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=DataReleases")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#DataReleases")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")


  remDr$goBack()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=DataStandards")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#DataStandards")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")


  remDr$goBack()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=About")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#About")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$goForward()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=DataStandards")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#DataStandards")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$goForward()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=DataReleases")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#DataReleases")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$goForward()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=SoftwareUpdates")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#SoftwareUpdates")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$goForward()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=RSessionInfo")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#RSessionInfo")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$goForward()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=GeneExpression")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#GeneExpression")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")
})

test_that("test linking tabs from alternative url", {
  remDr$navigate("https://www.google.com/")
  expect_equal(unlist(remDr$getCurrentUrl()), "https://www.google.com/")

  remDr$navigate(page_url)
  sleep_for(5)
  current_url <- paste0(page_url, "tab=About")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#About")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$goBack()
  sleep_for(5)
  expect_equal(unlist(remDr$getCurrentUrl()), "https://www.google.com/")

  remDr$goForward()
  sleep_for(5)
  current_url <- paste0(page_url, "tab=About")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#About")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$goBack()
  sleep_for(5)
  expect_equal(unlist(remDr$getCurrentUrl()), "https://www.google.com/")

  remDr$navigate(paste0(page_url, "tab=GeneExpression"))
  sleep_for(1)
  current_url <- paste0(page_url, "tab=GeneExpression")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#GeneExpression")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$goBack()
  sleep_for(5)
  expect_equal(unlist(remDr$getCurrentUrl()), "https://www.google.com/")

  remDr$goForward()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=GeneExpression")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#GeneExpression")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")
})

test_that("page refresh", {
  current_url <- paste0(page_url, "tab=GeneExpression")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)

  remDr$refresh()
  sleep_for(5)
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#GeneExpression")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$findElements("id", "SoftwareUpdates")[[1]]$clickElement()
  sleep_for(1)
  current_url <- paste0(page_url, "tab=SoftwareUpdates")
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#SoftwareUpdates")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")

  remDr$refresh()
  sleep_for(5)
  expect_equal(unlist(remDr$getCurrentUrl()), current_url)
  expect_equal(remDr$findElements("css", "div.tab-content div#SoftwareUpdates")[[1]]$getElementAttribute("aria-hidden")[[1]], "false")
})

test_that("all webpart is present", {
  test_presence_of_single_item("about-page")
})


test_that("About tab has correct elements", {
  tab <- remDr$findElement("id", "About")
  tab$clickElement()
  sleep_for(1)
  
  div <- remDr$findElement("id", "About-content")
  expect_length(div, 1)

  if (length(div) == 1) {
    img <- remDr$findElement("xpath", "//img[@src='/AboutPage/images/flow.png']")
    expect_length(img, 1)
  }
  
  title <- div$findChildElements("tag name", "h2")
  expect_length(title, 1)
  expect_equal(title[[1]]$getElementText()[[1]], "About ImmuneSpace")

  paragraphs <- div$findChildElements("tag name", "p")
  expect_length(paragraphs, 6)
  expect_equal(paragraphs[[1]]$getElementText()[[1]], "ImmuneSpace blossomed from a shared idea that generating large amounts collaborative data, cross-center and cross-assay, to characterize the status of the immune system in diverse populations under normal conditions and in response to various stimuli would be a beneficial platform. The Human Immunology Project Consortium (HIPC) program, an organization founded by the NIAID-DAIT, released ImmuneSpace in January 15, 2016.")
  expect_equal(paragraphs[[2]]$getElementText()[[1]], "Since its release, ImmuneSpace has developed into powerful data management and analysis engine, where datasets can be easily explored and analyzed using state-of-the-art computational tools. ImmuneSpace takes advantage of the considerable infrastructure already developed through another HIPC platform, ImmPort, which serves as a repository of data generated by investigators funded by DAIT. Data are submitted by each HIPC center to ImmPort using a set of standardized data templates. Once ImmPort has made these data public through routine data releases, the data are transferred to ImmuneSpace where integrative modeling across various data types and HIPC centers are enabled.")
  expect_equal(paragraphs[[3]]$getElementText()[[1]], "ImmuneSpace provides multiple ways to interact with, visualize, and analyze data. Each study contains tabs to view raw data, run common analyses, and look at custom reports. All the analyses make use of the R statistical language, leveraging Rserve to improve performance and knitr to enable full reproducibility.")
  expect_equal(paragraphs[[4]]$getElementText()[[1]], "Support:")
  expect_equal(paragraphs[[5]]$getElementText()[[1]], "Connect with us via Slack slack workspace")
  expect_equal(paragraphs[[6]]$getElementText()[[1]], "You can also reach the team at ops@immunespace.org")

  test_presence_of_single_img(div)
})

test_that("Data Standards tab has correct elements", {
  tab <- remDr$findElement("id", "DataStandards")
  tab$clickElement()
  sleep_for(1)

  div <- remDr$findElement("id", "DataStandards-content")
  expect_length(div, 1)

  paragraphs <- div$findChildElements("tag name", "p")
  expect_length(paragraphs, 12)
})

test_that("Data Processing tab has correct elements", {
  click_target_dropdown("Data Processing")

  assayOptions <- get_dropdown_options()
  expect_length(assayOptions, 1)

  expectedAssayTitles <- "Gene Expression"
  check_dropdown_titles(expectedAssayTitles, assayOptions)

  assayOptions[[1]]$clickElement()
  sleep_for(1)

  div <- remDr$findElement("id", "GeneExpression")
  expect_length(div, 1)

  if (length(div) == 1) {
    img <- remDr$findElement("xpath", "//img[@src='/AboutPage/images/ge_standardization.png']")
    expect_length(img, 1)
  }
})

test_that("Data Releases tab has correct elements", {
  tab <- remDr$findElement("id", "DataReleases")
  tab$clickElement()
  sleep_for(1)

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
  sleep_for(1)

  div <- remDr$findElement("id", "SoftwareUpdates-content")
  expect_length(div, 1)

  paragraphs <- div$findChildElements("tag name", "p")
  expect_gt(length(paragraphs), 26)
})

test_that("R Session Info tab has correct elements", {
  tab <- remDr$findElement("id", "RSessionInfo")
  tab$clickElement()
  sleep_for(1)

  # Rmd html output is appended as child and there is no 'id' of the div directly
  div <- remDr$findElement("class", "labkey-knitr")
  expect_length(div, 1)

  codeChunks <- div$findChildElements("tag name", "code")
  expect_length(codeChunks, 2)

  htmlWidget <- div$findChildElements("css selector", "div.html-widget")
  expect_length(htmlWidget, 1)

  dataTable <- htmlWidget[[1]]$findChildElement("tag", "table")
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
